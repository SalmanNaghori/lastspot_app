-- ==============================================================================
-- Migration: 202610180002_chat_push_notifications.sql
-- Purpose:   Implement robust server-side chat push notification dispatch for
--            both direct and group conversations. Ensures recipient membership
--            is resolved, excludes the sender, inserts clean notification rows,
--            and triggers the FCM Edge Function push dispatcher.
--
-- Safety:    Idempotent trigger replacement. Does NOT drop or alter existing tables
--            or column data. Preserves Supabase Realtime publications.
-- ==============================================================================

-- 1. Ensure `notifications` table has appropriate indexes and realtime publication
create index if not exists idx_notifications_user_id_created_at
  on public.notifications (user_id, created_at desc);

create index if not exists idx_notifications_user_id_is_read
  on public.notifications (user_id, is_read);

do $$
begin
  alter publication supabase_realtime add table public.notifications;
exception
  when duplicate_object then null;
end;
$$;

-- 2. Chat message notification trigger function
create or replace function public.notify_chat_message()
returns trigger as $$
declare
  v_conv record;
  v_sender_name text;
  v_recipient_record record;
  v_title text;
  v_notification_id uuid;
  v_edge_function_url text;
  v_service_role_key text;
begin
  -- Retrieve conversation details
  select id, request_id, chat_type
  into v_conv
  from public.chat_conversations
  where id = NEW.conversation_id;

  if not found then
    return NEW;
  end if;

  -- Retrieve sender display name
  select coalesce(full_name, 'Someone')
  into v_sender_name
  from public.profiles
  where id = NEW.sender_id;

  if v_sender_name is null or trim(v_sender_name) = '' then
    v_sender_name := 'Someone';
  end if;

  v_title := v_sender_name || ' sent you a message';

  -- If group chat linked to a request, sync any accepted participants into chat_members
  if v_conv.chat_type != 'direct' and v_conv.request_id is not null then
    insert into public.chat_members (conversation_id, user_id)
    select v_conv.id, rp.user_id
    from public.request_participants rp
    where rp.request_id = v_conv.request_id
    on conflict (conversation_id, user_id) do nothing;

    -- Also ensure request host is member
    insert into public.chat_members (conversation_id, user_id)
    select v_conv.id, r.user_id
    from public.requests r
    where r.id = v_conv.request_id
    on conflict (conversation_id, user_id) do nothing;
  end if;

  -- Iterate through all conversation members EXCEPT the sender
  for v_recipient_record in
    select distinct cm.user_id
    from public.chat_members cm
    where cm.conversation_id = NEW.conversation_id
      and cm.user_id != NEW.sender_id
  loop
    -- Insert user-facing notification row
    insert into public.notifications (
      user_id,
      title,
      body,
      type,
      data,
      is_read,
      created_at
    )
    values (
      v_recipient_record.user_id,
      v_title,
      NEW.content,
      'chat_message',
      jsonb_build_object(
        'type', 'chat_message',
        'conversation_id', NEW.conversation_id,
        'message_id', NEW.id,
        'sender_id', NEW.sender_id,
        'chat_type', v_conv.chat_type,
        'request_id', v_conv.request_id,
        'title', v_title,
        'body', NEW.content,
        'sender_name', v_sender_name
      ),
      false,
      now()
    )
    returning id into v_notification_id;

    -- If pg_net extension exists, trigger the send-push Edge Function asynchronously
    begin
      select current_setting('app.settings.edge_function_url', true) into v_edge_function_url;
      select current_setting('app.settings.service_role_key', true) into v_service_role_key;

      if v_edge_function_url is not null and v_edge_function_url != '' then
        perform net.http_post(
          url := v_edge_function_url || '/send-push',
          headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || coalesce(v_service_role_key, '')
          ),
          body := jsonb_build_object(
            'record', jsonb_build_object(
              'id', v_notification_id,
              'user_id', v_recipient_record.user_id,
              'title', v_title,
              'body', NEW.content,
              'type', 'chat_message',
              'data', jsonb_build_object(
                'type', 'chat_message',
                'conversation_id', NEW.conversation_id,
                'message_id', NEW.id,
                'sender_id', NEW.sender_id,
                'chat_type', v_conv.chat_type,
                'request_id', v_conv.request_id,
                'sender_name', v_sender_name
              )
            )
          )
        );
      end if;
    exception
      when others then
        -- Fallback gracefully; Realtime delivery remains intact
        null;
    end;

  end loop;

  return NEW;
end;
$$ language plpgsql security definer;

-- 3. Attach trigger to public.chat_messages
drop trigger if exists trg_notify_chat_message on public.chat_messages;
create trigger trg_notify_chat_message
  after insert on public.chat_messages
  for each row
  execute function public.notify_chat_message();
