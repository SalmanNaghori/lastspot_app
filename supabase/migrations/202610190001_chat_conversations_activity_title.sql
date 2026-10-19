-- ==============================================================================
-- Migration: 202610190001_chat_conversations_activity_title.sql
-- Purpose:   Extend get_my_chat_conversations RPC to ensure activity_title
--            (requests.title) and category_slug are returned for all conversations
--            (both direct and group), preserving separate activity contexts.
--
-- Safety:    Idempotent function replacement (CREATE OR REPLACE).
--            Preserves RLS, membership authorization, and all existing column outputs.
-- ==============================================================================

create or replace function public.get_my_chat_conversations()
returns table (
  conversation_id uuid,
  request_id uuid,
  activity_title text,
  chat_type text,
  other_user_id uuid,
  other_user_name text,
  other_user_avatar_url text,
  category_id uuid,
  category_slug text,
  group_avatar_url text,
  last_message text,
  last_message_at timestamptz,
  unread_count bigint
) language plpgsql security definer set search_path = public as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    return;
  end if;

  return query
  with my_conversations as (
    select cm.conversation_id, cm.last_read_at
    from public.chat_members cm
    where cm.user_id = v_user_id
  ),
  latest_messages as (
    select distinct on (m.conversation_id)
      m.conversation_id,
      m.content as last_message,
      m.created_at as last_message_at
    from public.chat_messages m
    inner join my_conversations mc on mc.conversation_id = m.conversation_id
    where m.deleted_at is null
    order by m.conversation_id, m.created_at desc
  ),
  unread_counts as (
    select
      m.conversation_id,
      count(*)::bigint as count
    from public.chat_messages m
    inner join my_conversations mc on mc.conversation_id = m.conversation_id
    where m.deleted_at is null
      and m.sender_id != v_user_id
      and (mc.last_read_at is null or m.created_at > mc.last_read_at)
    group by m.conversation_id
  ),
  other_members as (
    select distinct on (cm.conversation_id)
      cm.conversation_id,
      cm.user_id as other_user_id,
      p.full_name as other_user_name,
      p.avatar_url as other_user_avatar_url
    from public.chat_members cm
    inner join my_conversations mc on mc.conversation_id = cm.conversation_id
    left join public.profiles p on p.id = cm.user_id
    where cm.user_id != v_user_id
    order by cm.conversation_id
  )
  select
    c.id as conversation_id,
    c.request_id as request_id,
    r.title as activity_title,
    c.chat_type as chat_type,
    om.other_user_id as other_user_id,
    om.other_user_name as other_user_name,
    om.other_user_avatar_url as other_user_avatar_url,
    r.category_id as category_id,
    cat.slug as category_slug,
    null::text as group_avatar_url,
    lm.last_message as last_message,
    lm.last_message_at as last_message_at,
    coalesce(uc.count, 0)::bigint as unread_count
  from public.chat_conversations c
  inner join my_conversations mc on mc.conversation_id = c.id
  left join public.requests r on r.id = c.request_id
  left join public.categories cat on cat.id = r.category_id
  left join latest_messages lm on lm.conversation_id = c.id
  left join unread_counts uc on uc.conversation_id = c.id
  left join other_members om on om.conversation_id = c.id and c.chat_type = 'direct'
  order by coalesce(lm.last_message_at, c.created_at) desc;
end;
$$;

-- Grant execution to authenticated users
grant execute on function public.get_my_chat_conversations() to authenticated;
