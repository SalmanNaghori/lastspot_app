-- ============================================================================
-- Migration: Enable Supabase Realtime for Profiles and Join Requests
-- ============================================================================
-- Resolves RealtimeSubscribeException:
-- "Unable to subscribe to changes with given parameters.
-- Please check Realtime is enabled for the given connect parameters: table: profiles"

DO $$
BEGIN
  -- Add public.profiles to supabase_realtime publication if not already added
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
      AND schemaname = 'public' 
      AND tablename = 'profiles'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
  END IF;

  -- Add public.join_requests to supabase_realtime publication if not already added
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
      AND schemaname = 'public' 
      AND tablename = 'join_requests'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.join_requests;
  END IF;
END $$;

