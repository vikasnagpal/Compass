-- ============================================================
-- Compass — Migration 002
-- Run this ONCE in your Supabase SQL Editor, AFTER migration-001.
--
-- Changes:
--   1. Goal ownership (accountability)
--   2. Goal lifecycle (active / closed) + score + reflection
--   3. Idea lifecycle states + link to promoted initiative
-- ============================================================

-- ─── 1. Goal ownership ──────────────────────────────────────
alter table public.goals
  add column if not exists owner_id   uuid references public.profiles on delete set null,
  add column if not exists owner_name text default '';

-- ─── 2. Goal lifecycle (close-out workflow) ─────────────────
alter table public.goals
  add column if not exists status     text not null default 'active',
  add column if not exists closed_at  timestamptz,
  add column if not exists score      numeric,
  add column if not exists reflection text default '';

-- Constrain status to known values
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'goals_status_check'
  ) then
    alter table public.goals
      add constraint goals_status_check check (status in ('active','closed'));
  end if;
end $$;

-- Helpful index for filtering active vs closed
create index if not exists idx_goals_status on public.goals (status, position);

-- ─── 3. Idea lifecycle ──────────────────────────────────────
alter table public.ideas
  add column if not exists status                 text not null default 'captured',
  add column if not exists status_note            text default '',
  add column if not exists promoted_initiative_id uuid references public.initiatives on delete set null;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'ideas_status_check'
  ) then
    alter table public.ideas
      add constraint ideas_status_check check (status in ('captured','parked','rejected','promoted'));
  end if;
end $$;

-- Helpful indexes
create index if not exists idx_ideas_status on public.ideas (status);
