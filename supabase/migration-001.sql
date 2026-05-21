-- ============================================================
-- Compass — Migration 001
-- Run this ONCE in your Supabase SQL Editor, AFTER schema.sql
-- and seed.sql have already been applied.
--
-- Changes:
--   1. Drop the unused public.members table (we use profiles now)
--   2. Replace the profile-creation trigger with an upsert so that
--      display_name / avatar_url stay in sync when a user updates
--      their Google account, instead of being frozen at first signup.
-- ============================================================

-- ─── 1. Drop the unused members table ───────────────────────
drop policy if exists members_all on public.members;
drop table if exists public.members;

-- ─── 2. Profile trigger: upsert instead of no-op ────────────
-- Without this, the on conflict do nothing means a user changing
-- their Google display name will see Compass keep showing the old
-- one forever. With an upsert that respects non-null values, every
-- subsequent sign-in syncs their profile.
create or replace function public.handle_new_user()
returns trigger as $$
begin
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
$$ language plpgsql security definer;

-- The trigger itself doesn't need replacing — re-creating the function
-- under the same name is enough; the trigger keeps pointing at it.

-- ─── 3. Allow new history `edited` event type ───────────────
-- We now log description/owner/date edits to the Activity Trail.
alter table public.initiative_history
  drop constraint if exists initiative_history_type_check;
alter table public.initiative_history
  add constraint initiative_history_type_check
  check (type in ('created','status_change','comment','edited'));

-- ─── 4. Enable realtime replication on all relevant tables ───
-- This is what makes live multi-user sync work — Supabase streams
-- INSERT/UPDATE/DELETE events to subscribed clients.
alter publication supabase_realtime add table public.goals;
alter publication supabase_realtime add table public.key_results;
alter publication supabase_realtime add table public.initiatives;
alter publication supabase_realtime add table public.initiative_history;
alter publication supabase_realtime add table public.ideas;
alter publication supabase_realtime add table public.profiles;
