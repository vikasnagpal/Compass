-- ============================================================
-- Compass — Update allowed sign-in domains
--
-- Adds @zo.xyz alongside @zostel.com as a valid login domain.
--
-- Re-defines public.handle_new_user() (the trigger that fires on
-- every new auth.users row) so it:
--   1. Rejects any email whose domain isn't in the allow-list
--      → Supabase wraps this as "Database error saving new user",
--        which the client maps to a friendly error message.
--   2. Otherwise upserts a profile row (same behaviour as
--      migration-001 — display name and avatar stay in sync on
--      every sign-in, instead of being frozen at first signup).
--
-- To allow another domain later, edit the `allowed_domains` array
-- below and re-run. Idempotent — safe to run as many times as
-- you like.
--
-- Run ONCE in the Supabase SQL Editor.
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
declare
  -- Edit this list to allow more domains in future.
  allowed_domains text[] := array['zostel.com', 'zo.xyz'];
  email_domain    text;
begin
  -- Pull the part after the @ in the new user's email.
  email_domain := lower(split_part(coalesce(new.email, ''), '@', 2));

  if email_domain = '' or not (email_domain = any (allowed_domains)) then
    raise exception 'Sign-up restricted: % is not an allowed domain', email_domain
      using errcode = 'P0001';
  end if;

  -- Domain ok — create or refresh the profile row.
  insert into public.profiles (id, email, display_name, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data->>'full_name',
      new.raw_user_meta_data->>'name',
      split_part(coalesce(new.email,''), '@', 1)
    ),
    new.raw_user_meta_data->>'avatar_url'
  )
  on conflict (id) do update set
    email        = coalesce(excluded.email,        public.profiles.email),
    display_name = coalesce(excluded.display_name, public.profiles.display_name),
    avatar_url   = coalesce(excluded.avatar_url,   public.profiles.avatar_url);

  return new;
end;
$$;

-- The trigger itself (on_auth_user_created) already points at this
-- function by name, so re-creating the function under the same name
-- is enough — the trigger picks up the new behaviour immediately.
