-- ==============================================================================
-- Migration: 20261105000002_fix_profiles_update_permissions.sql
-- Purpose:   Grant UPDATE and INSERT permissions on public.profiles to authenticated
--            users and configure RLS so users can update their own profile.
-- ==============================================================================

-- 1. Grant table privileges to authenticated role
GRANT SELECT, INSERT, UPDATE ON TABLE public.profiles TO authenticated;

-- 2. Ensure Row Level Security (RLS) is enabled
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 3. Policy: Allow users to view profiles
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can view all profiles" ON public.profiles;
CREATE POLICY "Users can view all profiles"
ON public.profiles
FOR SELECT
TO authenticated
USING (true);

-- 4. Policy: Allow users to insert their own profile
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 5. Policy: Allow users to update their own profile
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

