create table if not exists public.spot_messages (
  id uuid primary key default gen_random_uuid(),
  spot_id uuid not null references public.requests(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid references public.profiles(id) on delete cascade,
  body text not null check (char_length(trim(body)) between 1 and 4000),
  created_at timestamptz not null default now()
);

create index if not exists spot_messages_spot_created_idx
  on public.spot_messages (spot_id, created_at desc);

create index if not exists spot_messages_direct_thread_idx
  on public.spot_messages (spot_id, sender_id, recipient_id, created_at desc)
  where recipient_id is not null;

alter table public.spot_messages enable row level security;

grant select, insert on public.spot_messages to authenticated;

drop policy if exists "spot members read spot messages" on public.spot_messages;
create policy "spot members read spot messages"
  on public.spot_messages
  for select
  to authenticated
  using (
    sender_id = auth.uid()
    or recipient_id = auth.uid()
    or (
      recipient_id is null
      and (
        exists (
          select 1
          from public.requests r
          where r.id = spot_messages.spot_id
            and r.user_id = auth.uid()
        )
        or exists (
          select 1
          from public.request_participants rp
          where rp.request_id = spot_messages.spot_id
            and rp.user_id = auth.uid()
        )
      )
    )
  );

drop policy if exists "spot members send messages" on public.spot_messages;
create policy "spot members send messages"
  on public.spot_messages
  for insert
  to authenticated
  with check (
    sender_id = auth.uid()
    and (
      (
        recipient_id is null
        and (
          exists (
            select 1
            from public.requests r
            where r.id = spot_messages.spot_id
              and r.user_id = auth.uid()
          )
          or exists (
            select 1
            from public.request_participants rp
            where rp.request_id = spot_messages.spot_id
              and rp.user_id = auth.uid()
          )
        )
      )
      or exists (
        select 1
        from public.requests r
        where r.id = spot_messages.spot_id
          and (
            (
              r.user_id = auth.uid()
              and exists (
                select 1
                from public.join_requests jr
                where jr.request_id = r.id
                  and jr.user_id = spot_messages.recipient_id
                  and jr.status in ('pending', 'accepted')
              )
            )
            or (
              r.user_id = spot_messages.recipient_id
              and exists (
                select 1
                from public.join_requests jr
                where jr.request_id = r.id
                  and jr.user_id = auth.uid()
                  and jr.status in ('pending', 'accepted')
              )
            )
          )
      )
    )
  );

do $$
begin
  alter publication supabase_realtime add table public.spot_messages;
exception
  when duplicate_object then null;
end;
$$;
