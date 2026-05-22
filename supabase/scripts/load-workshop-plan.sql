-- ============================================================
-- Compass — Load the post-workshop plan
--
-- Updates the 3 existing goals in place (preserving their UUIDs
-- so the 67 captured ideas you just restored stay linked to the
-- right goal), then rebuilds measures and initiatives to match
-- the workshop's final structure:
--
--   • 13 measures across 3 goals (active + monitor)
--   • 21 initiatives, placed under the measure they actually move
--   • "Monitor" measures (1.4-1.7, 2.4, 2.5) are loaded with no
--     initiatives — they're watched metrics. The UI will show
--     "No initiatives yet" which is the correct state.
--
-- Priority and status are NOT new fields (per the brief). They're
-- preserved implicitly via measure ordering: position 0 = highest
-- priority within the goal; later positions trend toward monitor.
--
-- ⚠ Destructive for measures/initiatives only. Goals stay (just
--    re-titled). Ideas are untouched — they retain goal_id but
--    lose key_result_id (set-null cascade), since the new measure
--    structure doesn't 1:1 map to the old one.
--
-- Run ONCE in the Supabase SQL Editor. Wrapped in a transaction.
-- ============================================================

begin;

do $$
declare
  g1_id uuid; g2_id uuid; g3_id uuid;
  m_id  uuid;  -- reused for each new measure
begin
  -- 1. Look up the existing goals by position (set 0/1/2 by reset-to-new-plan.sql)
  select id into g1_id from public.goals where position = 0 order by created_at limit 1;
  select id into g2_id from public.goals where position = 1 order by created_at limit 1;
  select id into g3_id from public.goals where position = 2 order by created_at limit 1;

  if g1_id is null or g2_id is null or g3_id is null then
    raise exception 'Could not find all 3 goals (positions 0/1/2). Run reset-to-new-plan.sql first.';
  end if;

  -- 2. Update goal titles + descriptions in place (preserves UUIDs → preserves ideas links)
  update public.goals
     set title       = 'Increase adoption of the Vibe Curator Program across all Zostel properties',
         description = 'Get property managers to say "We want this." Build clarity, trust, and clear business value so the Vibe Curator Program becomes the default at every Zostel property.'
   where id = g1_id;

  update public.goals
     set title       = 'Build a scalable, high-quality Vibe Curator ecosystem',
         description = 'Every guest at a Vibe-curated property should walk away saying "This experience was amazing." Consistent curator quality, retention, engagement, and content output across the network.'
   where id = g2_id;

  update public.goals
     set title       = 'Build Zostel''s brand positioning through the Vibe Curator Program',
         description = 'Make the Vibe Curator Program a public face of the Zostel brand — destination handle growth, recognisable curator storytelling, ambassadors and content series that travel with the audience.'
   where id = g3_id;

  -- 3. Wipe measures (cascades initiatives + history; ideas lose key_result_id but keep goal_id)
  delete from public.key_results;

  -- ─── GOAL 1: Adoption ──────────────────────────────────────
  -- M1.1 — % properties with active VC participation (Active · Highest)
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g1_id, '% of properties with active VC participation', 100, 0, '%', 0)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'PM and VC introduction / alignment call',           0),
    (m_id, 'PM-Curator collaboration framework',                1),
    (m_id, 'Case studies from successful properties',           2),
    (m_id, 'New property onboarding process',                   3),
    (m_id, 'Include PM in curator selection process',           4),
    (m_id, 'PM recognition program',                            5);

  -- M1.2 — Time from VC application to selection (Active · High)
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (g1_id, 'Time from VC application to selection', 0, 'days', 1)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'Better screening questionnaire (reduce human intervention)', 0),
    (m_id, 'Improved Group Discussion framework',                        1);

  -- M1.3 — VC pipeline coverage (Active · High — no initiatives yet)
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g1_id, 'VC pipeline coverage (months of qualified demand)', 6, 0, 'months', 2);

  -- M1.4-1.7 — Monitor metrics (no initiatives by design)
  insert into public.key_results (goal_id, title, current_value, unit, position) values
    (g1_id, 'Application → Group Discussion time',     0, 'days', 3),
    (g1_id, 'Group Discussion → Offer letter time',    0, 'days', 4),
    (g1_id, 'Offer letter → Onboarding time',          0, 'days', 5),
    (g1_id, 'Funnel drop-off rate at each stage',      0, '%',    6);

  -- ─── GOAL 2: Ecosystem quality ─────────────────────────────
  -- M2.1 — Activity completion rate (Active · High)
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (g2_id, 'Activity completion rate across properties', 0, '%', 0)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'Activity Playbook library',                 0),
    (m_id, 'Weekly showcase and idea-sharing sessions', 1);

  -- M2.2 — VC tenure completion rate (Active · High)
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (g2_id, 'VC tenure completion rate', 0, '%', 1)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'Selection and evaluation framework',                  0),
    (m_id, 'Recognition & incentive system',                      1),
    (m_id, 'Curator leveling system (Rookie → Pro → Master)',     2),
    (m_id, 'Internal curator leaderboard',                        3);

  -- M2.3 — VC internship experience score (Active · Medium)
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (g2_id, 'VC internship experience score', 0, '', 2)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'Redesigned VC internship journey', 0);

  -- M2.4-2.5 — Monitor metrics
  insert into public.key_results (goal_id, title, current_value, unit, position) values
    (g2_id, 'VC mid-tenure satisfaction pulse',           0, '', 3),
    (g2_id, 'Activity output per curator per week',       0, '', 4);

  -- ─── GOAL 3: Brand positioning ─────────────────────────────
  -- M3.1 — Destination handle followers + engagement (Active · High)
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (g3_id, 'Destination handle followers + engagement rate', 0, '', 0)
    returning id into m_id;
  insert into public.initiatives (key_result_id, title, position) values
    (m_id, 'Vibe Curator Superhero series',     0),
    (m_id, 'Community documentary series',      1),
    (m_id, 'Property Manager series',           2),
    (m_id, 'Community intern role',             3),
    (m_id, 'Destination ambassador program',    4),
    (m_id, 'Zostel Creator Academy',            5);

end $$;

commit;
