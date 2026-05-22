-- ============================================================
-- Compass — one-shot data script
--
-- Move every existing initiative onto the Ideas wall as a fresh
-- "captured" idea, then wipe the initiatives table so the team
-- can start the quarter clean.
--
-- What happens:
--   1. For each initiative, an idea is inserted with:
--        - text          = initiative title
--        - goal_id       = the initiative's goal (via its measure)
--        - key_result_id = the initiative's measure
--        - status        = 'captured'   (default)
--   2. Every initiative is deleted. Cascading FKs also clear:
--        - initiative_history (all comments and status changes)
--   3. Goals, measures, ideas, profiles — all untouched.
--
-- ⚠ Destructive: initiative comments and status history are gone
--   after this. Owners and due dates are NOT preserved — the
--   ideas table doesn't have those columns. If you want them back
--   later, re-promote each idea and re-enter them.
--
-- Run ONCE in the Supabase SQL Editor.
-- ============================================================

begin;

-- 1. Copy each initiative onto the Ideas wall, linked to its
--    goal + measure so they show up in the right place when
--    planning rolls around.
insert into public.ideas (text, goal_id, key_result_id, status)
select
  i.title,
  kr.goal_id,
  i.key_result_id,
  'captured'
from public.initiatives i
join public.key_results kr on kr.id = i.key_result_id;

-- Sanity check — should match the count of rows you had in
-- the initiatives table before this script ran. Uncomment to log:
-- select count(*) as ideas_inserted from public.ideas;

-- 2. Wipe initiatives (and their history via cascade)
delete from public.initiatives;

commit;
