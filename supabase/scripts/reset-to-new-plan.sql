-- ============================================================
-- Compass — one-shot data script
--
-- Replace the existing goals / measures / initiatives with the
-- structure planned in the post-it screenshot:
--   • 3 goals
--   • 6 measures
--   • 9 initiatives
--
-- ⚠ Destructive: wipes every goal (cascading to measures,
--   initiatives, and initiative_history) and clears the Ideas
--   wall too, so the team starts the quarter on a true blank
--   page. Profiles and member sign-ins are untouched.
--
-- Run ONCE in the Supabase SQL Editor. Wrapped in a transaction,
-- so a single error rolls everything back.
--
-- Quarter: Q2 2026 (current). Targets are set only where they
-- were called out on the postit ("Target 80%"); the rest are
-- null so owners can fill them in via the UI.
-- ============================================================

begin;

-- 1. Wipe the existing slate ─────────────────────────────────
delete from public.goals;   -- cascades to key_results, initiatives, history
delete from public.ideas;   -- start the Ideas wall fresh

-- 2. Insert the new plan as one chained CTE ─────────────────
--    Each block captures the row id so the next block can
--    reference it without having to know the UUID in advance.

with
  -- ─── Goals ──────────────────────────────────────────────
  g1 as (
    insert into public.goals (title, description, quarter, position)
    values (
      'Increase adoption/coverage of the Vibe Curator Program across all Zostel properties',
      'Get property managers to say "We want this." Build clarity, trust, and clear business value so the Vibe Curator Program becomes the default at every Zostel property.',
      'Q2 2026', 0
    ) returning id
  ),
  g2 as (
    insert into public.goals (title, description, quarter, position)
    values (
      'Build a scalable, high-quality Vibe Curator ecosystem that consistently delivers strong guest experiences and content output',
      'Every guest at a Vibe-curated property should walk away saying "This experience was amazing." Consistent curator quality, retention, engagement, and content output across the network.',
      'Q2 2026', 1
    ) returning id
  ),
  g3 as (
    insert into public.goals (title, description, quarter, position)
    values (
      'Create a strong brand positioning of Zostel through Vibe Curator Program',
      '',
      'Q2 2026', 2
    ) returning id
  ),

  -- ─── Measures (key_results) ─────────────────────────────
  -- Goal 1 measures
  m1_1 as (
    insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
    select id, 'Increase active participation in the VC program across Zostel properties', 80, 0, '%', 0 from g1
    returning id
  ),
  m1_2 as (
    insert into public.key_results (goal_id, title, current_value, unit, position)
    select id, 'Reduce the time it takes from VC application to selection', 0, '', 1 from g1
    returning id
  ),
  m1_3 as (
    insert into public.key_results (goal_id, title, current_value, unit, position)
    select id, 'Ensure the VC pipeline is strong enough to cater to the next 6 months of demand', 0, '', 2 from g1
    returning id
  ),
  -- Goal 2 measures
  m2_1 as (
    insert into public.key_results (goal_id, title, current_value, unit, position)
    select id, 'Increase VC tenure completion rate', 0, '', 0 from g2
    returning id
  ),
  m2_2 as (
    insert into public.key_results (goal_id, title, current_value, unit, position)
    select id, 'Increase the activity completion rate across properties to drive guest engagement and social interaction', 0, '', 1 from g2
    returning id
  ),
  -- Goal 3 measures
  m3_1 as (
    insert into public.key_results (goal_id, title, current_value, unit, position)
    select id, 'Increase destination handle followers and engagement rate', 0, '', 0 from g3
    returning id
  ),

  -- ─── Initiatives ────────────────────────────────────────
  -- Under m1_1 (active participation)
  i1_1_1 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Design a PM and VC introduction / alignment call',
      'Get them started right and improve working rapport between property managers and curators from day one.',
      0 from m1_1
    returning id
  ),
  i1_1_2 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Create case studies from successful properties',
      'Concrete, story-led proof that the VC program works. Share with property managers who are still on the fence.',
      1 from m1_1
    returning id
  ),
  i1_1_3 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Property Manager and Curator collaboration framework',
      'Defines how the two roles work together day to day — weekly rituals, handoffs, decision boundaries.',
      2 from m1_1
    returning id
  ),
  -- Under m1_2 (reduce time to selection)
  i1_2_1 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Define a better screening questionnaire',
      'Identifies candidates fit for the role without human intervention — gets the right shortlist to the team faster.',
      0 from m1_2
    returning id
  ),
  -- Under m2_1 (tenure completion)
  i2_1_1 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Define the selection and evaluation framework',
      'A consistent way to assess applicants beyond "do they make nice content?" — community instincts, on-property fit, reliability under low supervision.',
      0 from m2_1
    returning id
  ),
  i2_1_2 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Recognition & incentive system',
      'Curators who stay and ship great work should feel seen and rewarded. Define the recognition rituals and the incentive structure.',
      1 from m2_1
    returning id
  ),
  -- Under m2_2 (activity completion)
  i2_2_1 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Activity Playbook library',
      'A library of repeatable, property-friendly guest activities curators can pull from — reduces blank-page anxiety, raises the floor on engagement.',
      0 from m2_2
    returning id
  ),
  i2_2_2 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Weekly showcase and idea-sharing session',
      'A standing slot for curators to share what worked, what flopped, and steal each other''s good ideas across properties.',
      1 from m2_2
    returning id
  ),
  -- Under m3_1 (destination handles)
  i3_1_1 as (
    insert into public.initiatives (key_result_id, title, description, position)
    select id,
      'Define and hire the community intern role',
      'Stipend-based, performance-linked role. Owns destination-handle growth, posting cadence, and engagement loops across properties.',
      0 from m3_1
    returning id
  )

select 'inserted' as result;

commit;
