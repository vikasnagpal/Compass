-- ============================================================
-- Compass — Add Goal 4: Content Operations Engine
--
-- Adds a fourth goal alongside the three workshop goals,
-- with 6 measures, 22 initiatives, and 17 ideas — all the
-- raw content from the brief, lightly reorganised:
--
--   • VC onboarding/offboarding moved from M1 (locations
--     ready) to M6 (time to onboard) — it's the same work,
--     and M6 is where it directly moves the needle.
--   • Bullet sub-lists in the brief collapsed into one-line
--     initiative descriptions so each row is one owner, one
--     done-state (per the framework principle).
--   • Ideas linked to the specific measure they belong under,
--     so they surface correctly in the measure filter.
--   • M5 reward ideas (leveling, XP, badges, merch, awards,
--     travel benefits) consolidated into 2 ideas — same
--     thematic cluster, no need for 6 rows.
--
-- ⚠ Non-destructive. Existing goals 1–3, their measures,
--    initiatives, and ideas are not touched.
--
-- Re-running this script will create DUPLICATE entries.
-- Run ONCE in the Supabase SQL Editor. Wrapped in a
-- transaction so a partial failure rolls back cleanly.
-- ============================================================

begin;

do $$
declare
  g_id  uuid;
  m_id  uuid;
  m1_id uuid; m2_id uuid; m3_id uuid;
  m4_id uuid; m5_id uuid; m6_id uuid;
  next_pos integer;
begin
  -- 1. Pick the next free position (one past the current max)
  select coalesce(max(position), -1) + 1 into next_pos from public.goals;

  -- 2. Create the goal
  insert into public.goals (title, description, quarter, position)
       values (
         'Build a Content Operations Engine to scale content across all locations',
         'Create scalable systems that enable consistent content creation, submission, publishing, account management, and curator motivation across all Zostel location handles — even with frequent curator and intern turnover. If the six measures under this goal improve quarter over quarter, the content engine is getting stronger regardless of who joins or leaves the team.',
         'Q2 2026',
         next_pos
       )
    returning id into g_id;

  -- ─── M4.1 — % Locations Operationally Ready ────────────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, '% of locations operationally ready', 100, 0, '%', 0)
    returning id into m1_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m1_id, 'Handle & Meta setup system',
     'Create or claim remaining handles, connect every handle to Meta Business Suite, and standardize the account structure.', 0),
    (m1_id, 'Location registry',
     'Master database: location, handle, assigned curator, property manager, access status, start and end dates.', 1),
    (m1_id, 'Handle ownership & access SOP',
     'Access provisioning, access removal, ownership transfer, and security guidelines.', 2);

  -- ─── M4.2 — Content Submission Compliance % ────────────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, 'Content submission compliance %', 100, 0, '%', 1)
    returning id into m2_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m2_id, 'Weekly content submission framework',
     'Define the weekly deliverables every curator owes: reels, stories, photos, guest stories.', 0),
    (m2_id, 'Content submission SOP',
     'What to submit, when to submit, where to submit, and naming conventions.', 1),
    (m2_id, 'Submission dashboard',
     'Track submitted, pending, late, and missing across all curators in one view.', 2),
    (m2_id, 'Weekly curator scorecards',
     'Each curator sees their targets, completion, and missed deliverables every week.', 3);

  -- ─── M4.3 — Planned vs Published Posts % ───────────────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, 'Planned vs published posts %', 100, 0, '%', 2)
    returning id into m3_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m3_id, 'Content publishing system',
     'Standardize the path from submission → review → scheduling → publishing.', 0),
    (m3_id, 'Publishing calendar',
     'Central planning system covering all location handles.', 1),
    (m3_id, 'Weekly publishing tracker',
     'At-a-glance location status: green / yellow / red against the week''s plan.', 2),
    (m3_id, 'Content asset management system',
     'Repository structure, asset tagging, and content storage standards so nothing is lost.', 3);

  -- ─── M4.4 — % Curators Creating Without Follow-Up ──────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, '% curators creating content without follow-up', 100, 0, '%', 3)
    returning id into m4_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m4_id, 'Curator accountability system',
     'Behavioural layer: weekly scorecards, performance visibility, and compliance tracking that does not need a human chaser.', 0),
    (m4_id, 'Creator toolkit',
     'Reel templates, caption bank, hooks library, and trending-audio references — the raw materials curators need.', 1),
    (m4_id, 'Low-effort content framework',
     'Ready-made formats curators can ship on a slow day: POV trends, room tours, guest reactions, sunset clips, day-in-the-life.', 2);

  -- ─── M4.5 — Curator Participation Rate % ───────────────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, 'Curator participation rate %', 100, 0, '%', 4)
    returning id into m5_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m5_id, 'Recognition & rewards system',
     'Monthly categories — Storyteller of the Month, Community Builder, Content Creator of the Month.', 0),
    (m5_id, 'Curator showcase program',
     'Monthly showcase of the best content, best activities, and best stories from across the network.', 1),
    (m5_id, 'Featured creator program',
     'Top creators featured on Zostel''s main handles, internal channels, and recruitment content.', 2),
    (m5_id, 'Curator feedback system',
     'Pulse surveys, feedback loops, and monthly check-ins to keep the program tuned to curators'' reality.', 3);

  -- ─── M4.6 — Avg Time to Onboard a New Curator ──────────────
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (g_id, 'Average time to onboard a new curator', 0, 0, 'days', 5)
    returning id into m6_id;
  insert into public.initiatives (key_result_id, title, description, position) values
    (m6_id, 'VC onboarding & offboarding system',
     'Welcome kit, onboarding checklist, offboarding checklist, and a clean access handover process.', 0),
    (m6_id, 'Onboarding automation project',
     'Reduce manual setup effort across handles, access, and tooling so new curators are productive sooner.', 1),
    (m6_id, 'VC welcome kit',
     'Content expectations, SOPs, examples, and FAQs in one place for every new curator.', 2),
    (m6_id, 'Training resource hub',
     'Central repository of guides, videos, templates, and examples curators can self-serve from.', 3);

  -- ─── Ideas — linked to the measure they belong under ───────
  insert into public.ideas (goal_id, key_result_id, text, status) values
    -- M4.1
    (g_id, m1_id, 'Automated access provisioning for new handles.',                              'captured'),
    (g_id, m1_id, 'Single-click onboarding workflow that sets up access + tools in one go.',     'captured'),
    -- M4.2
    (g_id, m2_id, 'WhatsApp bot for content submissions.',                                       'captured'),
    (g_id, m2_id, 'AI-based content categorization on submitted assets.',                        'captured'),
    (g_id, m2_id, 'Auto-generated weekly submission reports for leadership.',                    'captured'),
    -- M4.3
    (g_id, m3_id, 'Fully automated publishing for approved content.',                            'captured'),
    (g_id, m3_id, 'AI-assisted scheduling that picks optimal post times per handle.',            'captured'),
    (g_id, m3_id, 'Content recommendation engine that suggests next posts from the asset library.', 'captured'),
    -- M4.4
    (g_id, m4_id, 'Peer accountability groups — curators check on each other weekly.',           'captured'),
    (g_id, m4_id, 'Curator buddy system — pair new curators with experienced ones.',             'captured'),
    (g_id, m4_id, 'Curator challenges — short themed sprints to spark consistent output.',       'captured'),
    -- M4.5
    (g_id, m5_id, 'Curator leveling system with XP points and digital badges.',                  'captured'),
    (g_id, m5_id, 'Physical rewards — merchandise, annual awards, and travel benefits for top curators.', 'captured'),
    -- M4.6
    (g_id, m6_id, 'Self-serve onboarding portal — curators set themselves up end to end.',       'captured'),
    (g_id, m6_id, 'Learning management system for structured curator training.',                 'captured'),
    (g_id, m6_id, 'Certification pathway — formal "Vibe Curator Certified" milestone.',          'captured');

end $$;

commit;
