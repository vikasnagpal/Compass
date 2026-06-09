-- ============================================================
-- Compass — Split the rolled-up dashboards initiative into 5
--
-- The original Destination Program load placed all five Phase-1
-- dashboards (DB-1 to DB-5) under ONE initiative
-- ("Build the 5 Phase-1 dashboards") on the measure
-- "Dashboards live with real data (DB-1 to DB-5)".
--
-- Each dashboard is its own build — different data sources,
-- owners, and timelines — so they deserve their own initiative
-- and their own progress. This script:
--   1. Finds that measure (by title).
--   2. Deletes the single rolled-up initiative under it.
--   3. Inserts 5 separate initiatives, one per dashboard.
--
-- ⚠ Destructive only for the one rolled-up initiative on that
--    measure. If you've already manually split or renamed it,
--    re-running is a no-op for the delete and will still insert
--    the 5 — so run ONCE.
--
-- Run ONCE in the Supabase SQL Editor. Wrapped in a transaction.
-- ============================================================

begin;

do $$
declare
  m_id uuid;
begin
  -- Locate the dashboards measure by its title.
  select id into m_id
    from public.key_results
   where title = 'Dashboards live with real data (DB-1 to DB-5)'
   order by created_at
   limit 1;

  if m_id is null then
    raise exception 'Could not find the "Dashboards live with real data (DB-1 to DB-5)" measure. Has the Destination Program been loaded?';
  end if;

  -- Remove the single rolled-up initiative (cascades its history).
  delete from public.initiatives
   where key_result_id = m_id
     and title = 'Build the 5 Phase-1 dashboards';

  -- Insert the five dashboards as their own initiatives.
  insert into public.initiatives (key_result_id, title, description, position) values
    (m_id, 'DB-1 — Coverage dashboard',
     'Live view of destinations live, active hosts, Meta-connected handles, and each host''s timeline. Answers "can we support more locations?"', 0),
    (m_id, 'DB-2 — Content & publishing dashboard',
     'Planned vs published vs missed, plus cadence hit rate per handle. The operational heartbeat of the content engine.', 1),
    (m_id, 'DB-3 — Host health dashboard',
     'Time-to-active, retention, graduation stage, and early risk identification per host. Surfaces who needs support before they churn.', 2),
    (m_id, 'DB-4 — Growth & engagement dashboard',
     'Followers, reach per post, and engagement rate per handle (baseline at 2 weeks). Tracks whether the audience is actually growing.', 3),
    (m_id, 'DB-5 — Rewards & ecosystem dashboard',
     'Milestones hit, rewards owed, and collaboration initiatives per destination. Keeps the recognition engine honest and on time.', 4);

end $$;

commit;
