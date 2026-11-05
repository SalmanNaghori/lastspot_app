-- ==============================================================================
-- Migration: 20261105000001_exclude_chat_from_notifications_screen.sql
-- Purpose:   Exclude chat messages from general notifications inbox & unread badge.
--            Chat messages belong exclusively to chat conversations and are
--            not displayed on the general Notifications screen.
-- ==============================================================================

-- 1. Update unread notification count RPC to exclude chat messages
create or replace function public.get_unread_notification_count()
returns integer as $$
declare
  v_count integer;
begin
  select count(*)::integer
  into v_count
  from public.notifications
  where user_id = auth.uid()
    and is_read = false
    and type not in ('chat_message', 'chat', 'new_chat_message');

  return coalesce(v_count, 0);
end;
$$ language plpgsql security definer;

-- 2. Update mark all notifications read RPC to exclude chat messages
create or replace function public.mark_all_notifications_read()
returns void as $$
begin
  update public.notifications
  set is_read = true
  where user_id = auth.uid()
    and is_read = false
    and type not in ('chat_message', 'chat', 'new_chat_message');
end;
$$ language plpgsql security definer;

-- 3. Clean up existing chat_message rows from notifications table
-- (Chat history and messages remain safe and intact in the chat_messages table)
delete from public.notifications
where type in ('chat_message', 'chat', 'new_chat_message');

