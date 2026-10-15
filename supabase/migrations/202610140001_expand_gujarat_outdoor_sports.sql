-- ==============================================================================
-- Migration: 202610140001_expand_gujarat_outdoor_sports.sql
-- Purpose:   Expand LastSpot category catalog with traditional Gujarat games
--            and popular outdoor sports with consistent display orders.
--
-- Safety:    Idempotent UPSERT on unique `slug`. Does NOT drop or alter existing
--            foreign keys or IDs. Preserves non-sport categories (Ride Sharing,
--            Events, Other).
--
-- NOTE:      Review with team prior to execution on production Supabase.
-- ==============================================================================

-- Ensure slug has unique constraint if not already present
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'categories_slug_key'
      and conrelid = 'public.categories'::regclass
  ) then
    alter table public.categories add constraint categories_slug_key unique (slug);
  end if;
end $$;

-- Upsert categories
insert into public.categories (
  name,
  slug,
  icon,
  description,
  is_active,
  display_order
)
values
  -- Traditional Gujarat Games (Top Priority in Gujarat Region)
  ('Kabaddi', 'kabaddi', 'sports_kabaddi', 'Traditional team tag game played on clay court', true, 1),
  ('Kho-Kho', 'kho-kho', 'directions_run', 'High-energy traditional tag game with central chasing line', true, 2),
  ('Gilli-Danda', 'gilli-danda', 'sports', 'Ancient Indian sport played with a wooden danda and gilli peg', true, 3),
  ('Satoliya / Lagori', 'satoliya', 'filter_hdr', 'Classic 7-stone knockdown and reconstruction team game', true, 4),
  ('Kite Flying', 'kite-flying', 'air', 'Gujarat Patang festival and competitive rooftop kite flying', true, 5),

  -- Popular Team Outdoor Sports
  ('Cricket', 'cricket', 'sports_cricket', 'Bat and ball outdoor team match', true, 6),
  ('Football', 'football', 'sports_soccer', 'Association football match on turf or ground', true, 7),
  ('Volleyball', 'volleyball', 'sports_volleyball', 'Court or beach volleyball rally', true, 8),
  ('Basketball', 'basketball', 'sports_basketball', 'Full-court or half-court basketball game', true, 9),
  ('Hockey', 'hockey', 'sports_hockey', 'Field hockey played on turf or outdoor field', true, 10),
  ('Ultimate Frisbee', 'ultimate-frisbee', 'album', 'Non-contact flying disc team sport', true, 11),
  ('Tug of War', 'tug-of-war', 'group_work', 'Strength and teamwork outdoor rope-pulling contest', true, 12),

  -- Popular Racket Sports
  ('Badminton', 'badminton', 'sports_tennis', 'Fast-paced singles or doubles shuttlecock match', true, 13),
  ('Tennis', 'tennis', 'sports_tennis', 'Lawn tennis singles or doubles rally', true, 14),
  ('Table Tennis', 'table-tennis', 'sports_tennis', 'Indoor or outdoor ping-pong match', true, 15),
  ('Pickleball', 'pickleball', 'sports_tennis', 'Fast-growing paddle and wiffle ball court game', true, 16),

  -- Fitness, Adventure & Individual Outdoor Sports
  ('Cycling', 'cycling', 'directions_bike', 'Road cycling, morning peloton, or trail rides', true, 17),
  ('Running', 'running', 'directions_run', 'Morning runs, marathons, or track sprints', true, 18),
  ('Skating', 'skating', 'ice_skating', 'Inline roller skating and street cruising', true, 19),
  ('Swimming', 'swimming', 'pool', 'Lap swimming, open water, or pool sessions', true, 20),
  ('Hiking / Trekking', 'hiking', 'hiking', 'Hill climbs, nature trails, and trekking expeditions', true, 21),
  ('Outdoor Yoga', 'outdoor-yoga', 'self_improvement', 'Morning sunrise yoga, pranayama, and meditation in the park', true, 22),

  -- Preserved Non-Sport Community Categories
  ('Ride Sharing', 'ride_sharing', 'directions_car', 'Carpooling and ride-sharing for activities and matches', true, 23),
  ('Events', 'events', 'celebration', 'Sports tournaments, fitness workshops, and social meetups', true, 24),
  ('Other', 'other', 'sports', 'Other casual recreational games and activities', true, 25)

on conflict (slug) do update set
  name = excluded.name,
  icon = excluded.icon,
  description = excluded.description,
  is_active = excluded.is_active,
  display_order = excluded.display_order;
