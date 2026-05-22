-- ============================================================
-- Compass — Update allowed sign-in domains
--
-- Adds @zo.xyz alongside @zostel.com as a valid login domain.
--
-- The actual gate is the BEFORE INSERT trigger
-- `restrict_signup_domain` on auth.users, which calls
-- `public.enforce_email_domain()`. This script re-defines that
-- function with an allow-list of multiple domains. The trigger
-- name and binding don't change, so re-running is safe and the
-- new behaviour takes effect on the very next sign-in attempt.
--
-- To allow another domain later, edit the `allowed_domains` array
-- below and re-run.
--
-- Run ONCE in the Supabase SQL Editor.
-- ============================================================

create or replace function public.enforce_email_domain()
returns trigger
language plpgsql
security definer
as $$
declare
  -- Edit this list to allow more domains in future.
  allowed_domains text[] := array['zostel.com', 'zo.xyz'];
  email_domain    text;
begin
  email_domain := lower(split_part(coalesce(new.email, ''), '@', 2));

  if email_domain = '' or not (email_domain = any (allowed_domains)) then
    raise exception 'Sign-up restricted: % is not an allowed domain', email_domain
      using errcode = 'P0001';
  end if;

  return new;
end;
$$;

-- The trigger restrict_signup_domain already points at this
-- function by name, so re-creating the function under the same
-- name is enough — the trigger picks up the new behaviour
-- immediately for the next sign-in attempt.
