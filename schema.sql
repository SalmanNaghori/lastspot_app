-- Supabase Schema for LastSpot

-- ==========================================
-- 1. PROFILES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  full_name text,
  bio text,
  preferred_sports text[], -- e.g., ['Cricket', 'Football']
  skill_level text, -- e.g., 'Beginner', 'Intermediate', 'Advanced'
  rating numeric(3,1) default 0.0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- ==========================================
-- 2. APP SETTINGS (FORCE UPDATE & MAINTENANCE)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.app_settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.app_settings FOR SELECT USING (true);
-- To secure writes, implement an is_admin() function and policy:
-- CREATE POLICY "Allow admin write" ON public.app_settings FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Insert default rows
INSERT INTO public.app_settings (key, value) VALUES (
  'version_control',
  '{
    "android": {
      "latest_version": "1.0.0",
      "min_supported_version": "1.0.0",
      "store_url": "https://play.google.com/store/apps/details?id=com.lastspot.app",
      "blocked_versions": [],
      "version_messages": {
        "default": {
          "title": "New Version Available 🚀",
          "message": "A newer, faster version of the app is available.",
          "release_notes": ["Performance optimizations"]
        }
      }
    },
    "ios": {
      "latest_version": "1.0.0",
      "min_supported_version": "1.0.0",
      "store_url": "https://apps.apple.com/app/id123456789",
      "blocked_versions": [],
      "version_messages": {
        "default": {
          "title": "New Version Available 🚀",
          "message": "A newer, faster version of the app is available.",
          "release_notes": ["Performance optimizations"]
        }
      }
    }
  }'::jsonb
) ON CONFLICT (key) DO NOTHING;

INSERT INTO public.app_settings (key, value) VALUES (
  'maintenance_mode',
  '{
    "global_maintenance": false,
    "global_title": "Scheduled Server Upgrade",
    "global_message": "We are temporarily offline for routine infrastructure upgrades. Please check back shortly.",
    "estimated_end_time": null,
    "targeted_rules": []
  }'::jsonb
) ON CONFLICT (key) DO NOTHING;

-- ==========================================
-- 3. USER DEVICES (FINGERPRINTING & SESSIONS)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  device_id text not null,
  device_name text,
  platform text not null,
  os_version text,
  app_version text not null,
  build_number text,
  fcm_token text,
  ip_address text,
  is_active boolean default true,
  last_login_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint unique_user_device unique (user_id, device_id)
);

CREATE INDEX IF NOT EXISTS idx_user_devices_user_id ON public.user_devices(user_id);
CREATE INDEX IF NOT EXISTS idx_user_devices_device_id ON public.user_devices(device_id);

ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can upsert and view own devices" ON public.user_devices FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
-- CREATE POLICY "Admins can view all devices" ON public.user_devices FOR SELECT TO authenticated USING (public.is_admin());

-- Upsert RPC function
CREATE OR REPLACE FUNCTION public.record_user_device(
  p_device_id text,
  p_device_name text,
  p_platform text,
  p_os_version text,
  p_app_version text,
  p_build_number text,
  p_fcm_token text default null
)
RETURNS void AS $$ 
BEGIN   
  INSERT INTO public.user_devices (
    user_id, device_id, device_name, platform, os_version, app_version, build_number, fcm_token, last_login_at, is_active
  )   
  VALUES (
    auth.uid(), p_device_id, p_device_name, p_platform, p_os_version, p_app_version, p_build_number, p_fcm_token, now(), true
  )   
  ON CONFLICT (user_id, device_id) DO UPDATE   
  SET     
    device_name = excluded.device_name,     
    platform = excluded.platform,     
    os_version = excluded.os_version,     
    app_version = excluded.app_version,     
    build_number = excluded.build_number,     
    fcm_token = coalesce(excluded.fcm_token, public.user_devices.fcm_token),     
    last_login_at = now(),     
    is_active = true; 
END; 
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- 4. POSTS & JOIN REQUESTS
-- ==========================================
CREATE TABLE IF NOT EXISTS public.posts (
  id uuid primary key default gen_random_uuid(),
  host_id uuid references public.profiles(id) on delete cascade not null,
  category text not null,
  total_spots int not null,
  spots_needed int not null,
  scheduled_time timestamp with time zone not null,
  venue_name text not null,
  location_url text,
  notes text,
  status text default 'active',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Posts are viewable by everyone." ON public.posts FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert posts." ON public.posts FOR INSERT TO authenticated WITH CHECK (auth.uid() = host_id);
CREATE POLICY "Hosts can update their own posts." ON public.posts FOR UPDATE USING (auth.uid() = host_id);

CREATE TABLE IF NOT EXISTS public.join_requests (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.posts(id) on delete cascade not null,
  applicant_id uuid references public.profiles(id) on delete cascade not null,
  status text default 'pending',
  message text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint unique_post_applicant unique (post_id, applicant_id)
);

ALTER TABLE public.join_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Applicants can view their own requests." ON public.join_requests FOR SELECT USING (auth.uid() = applicant_id);
CREATE POLICY "Hosts can view requests for their posts." ON public.join_requests FOR SELECT USING (auth.uid() = (SELECT host_id FROM public.posts WHERE id = post_id));
