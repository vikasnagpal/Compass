-- ============================================================
-- Compass — Migration 005: per-user "catch-up" markers
--
-- Powers the Catch-up digest view (team-wide "what changed since
-- I was last here" + a forward agenda). Two timestamps per user:
--
--   • last_seen_at      — the "new vs. already-glanced" line.
--                         Advances when the user OPENS the digest.
--                         Activity newer than this gets a NEW accent.
--   • last_caught_up_at — the floor of the visible pile. Advances
--                         ONLY when the user clicks "Mark all caught
--                         up". Items stay visible (dimmed once seen)
--                         until then.
--
-- Stored on profiles so the markers follow a user across devices.
-- No RLS change needed: the existing profiles_update policy
-- (using auth.uid() = id) already lets a user update their own row.
--
-- Idempotent. Run ONCE in the Supabase SQL Editor.
-- ============================================================

alter table public.profiles
  add column if not exists last_seen_at      timestamptz,
  add column if not exists last_caught_up_at timestamptz;
