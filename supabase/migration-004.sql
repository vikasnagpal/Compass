-- ============================================================
-- Compass — Migration 004: measure history (sparkline data)
--
-- Adds a measure_history table mirroring initiative_history, plus a
-- AFTER UPDATE trigger that snapshots current_value / target_value
-- every time a measure changes. The app reads this in chronological
-- order to render a small sparkline on each measure card — turns
-- "are we at 60%" into "are we trending toward the target?"
--
-- Idempotent: re-running is safe. Uses `if not exists` everywhere
-- and replaces the trigger function with `or replace`.
--
-- Run ONCE in the Supabase SQL Editor.
-- ============================================================

begin;

-- ─── 1. The history table ─────────────────────────────────
create table if not exists public.measure_history (
  id              uuid primary key default gen_random_uuid(),
  key_result_id   uuid not null references public.key_results on delete cascade,
  current_value   numeric,
  target_value    numeric,
  unit            text,
  -- author_* match initiative_history shape so the export bundle stays
  -- consistent and we can attribute changes later if useful.
  author_id       uuid references public.profiles on delete set null,
  author_name     text,
  created_at      timestamptz default now()
);

create index if not exists idx_measure_history_kr
  on public.measure_history (key_result_id, created_at desc);

-- ─── 2. RLS — shared team workspace pattern ───────────────
alter table public.measure_history enable row level security;

do $$ begin
  if not exists (
    select 1 from pg_policies
     where schemaname='public' and tablename='measure_history' and policyname='measure_history_all'
  ) then
    create policy measure_history_all on public.measure_history
      for all to authenticated using (true) with check (true);
  end if;
end $$;

-- ─── 3. Snapshot trigger ──────────────────────────────────
-- Append a row whenever current_value or target_value changes. We snapshot
-- NEW values (post-change) so the latest row always reflects current state.
create or replace function public.log_measure_snapshot()
returns trigger
language plpgsql
as $$
begin
  if (new.current_value is distinct from old.current_value)
     or (new.target_value is distinct from old.target_value)
  then
    insert into public.measure_history
      (key_result_id, current_value, target_value, unit)
    values
      (new.id, new.current_value, new.target_value, new.unit);
  end if;
  return new;
end;
$$;

drop trigger if exists measure_snapshot on public.key_results;
create trigger measure_snapshot
  after update on public.key_results
  for each row execute function public.log_measure_snapshot();

-- ─── 4. Seed a baseline snapshot for existing measures ────
-- Without this, sparklines start as a single point once someone edits.
-- Seeding gives every existing measure a starting tick so the sparkline
-- always has a reference value.
insert into public.measure_history (key_result_id, current_value, target_value, unit)
select id, current_value, target_value, unit
  from public.key_results
 where not exists (
   select 1 from public.measure_history h where h.key_result_id = key_results.id
 );

commit;
