-- ============================================================
-- Compass — Migration 003
-- Run this ONCE in your Supabase SQL Editor, AFTER migration-002.
--
-- Change:
--   Add 'on_hold' as a valid initiative status. This is for work
--   that was started and then deliberately paused — distinct from
--   'not_started' (never touched) and 'blocked' (involuntarily
--   stuck waiting on something/someone).
-- ============================================================

alter table public.initiatives
  drop constraint if exists initiatives_status_check;

alter table public.initiatives
  add constraint initiatives_status_check
  check (status in (
    'not_started',
    'in_progress',
    'on_track',
    'at_risk',
    'blocked',
    'on_hold',
    'completed'
  ));
