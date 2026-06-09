-- ============================================================
-- Compass — Load the Destination Host Program (Q3 2026)
--
-- Two-part script:
--
--   1. Archive every currently-active goal — status flipped to
--      'closed', closed_at stamped to now(). Initiatives, ideas,
--      and history under those goals stay attached (visible in
--      the Archive view; not deleted).
--
--   2. Insert three new Q3 2026 goals for Phase 1 of the
--      Destination Host Program, with 11 measures, 18
--      initiatives, and 8 ideas total. Owners left blank by
--      design — the program team will assign once kicked off.
--
-- Maps the destination-program.html brief to Compass per the
-- review note:
--   • Each of the brief's "Goal 01/02/03" becomes a top-level
--     Compass goal (clear outcome each, easy to operationalise).
--   • The 5 DBs are surfaced as measures, not as five separate
--     initiatives — there's one consolidated "build the
--     dashboards" initiative under Goal A.
--   • Cross-cutting frameworks placed at their primary home:
--     FW-2 (host onboarding) under Goal B, FW-4 (reward &
--     milestone) under Goal A, the rest under Goal A.
--   • Phase 2/3 targets (25–30 handles, 100% coverage, host-led
--     flywheel) live as ideas, not measures — they're not Q3
--     2026 work.
--
-- ⚠ Mildly destructive: existing active goals are CLOSED, not
--    deleted. Nothing is removed. To unwind, re-open the closed
--    goals via the UI and delete the three new ones.
--
-- Run ONCE in the Supabase SQL Editor. Wrapped in a transaction.
-- ============================================================

begin;

-- ─── 1. Archive existing active goals ────────────────────────
update public.goals
   set status     = 'closed',
       closed_at  = now()
 where status = 'active';

-- ─── 2. Load the Destination Host Program ────────────────────
do $$
declare
  gA_id uuid; gB_id uuid; gC_id uuid;
  m_id  uuid;
  mA1 uuid; mA2 uuid; mA3 uuid;
  mB1 uuid; mB2 uuid; mB3 uuid; mB4 uuid;
  mC1 uuid; mC2 uuid; mC3 uuid; mC4 uuid;
  next_pos integer;
begin
  -- Append new goals after any archived ones to keep ordering tidy.
  select coalesce(max(position), -1) + 1 into next_pos from public.goals;

  -- ═══ GOAL A — Operating spine ═══════════════════════════════
  insert into public.goals (title, description, quarter, position, status)
       values (
         'Stand up the Destination Program operating spine',
         'Build the systems, frameworks, and dashboards that will power 100 destination handles — prove them on 10 in Phase 1 (Days 1–60). When the spine is in place, every other goal becomes faster and cheaper to run.',
         'Q3 2026',
         next_pos,
         'active'
       )
    returning id into gA_id;
  next_pos := next_pos + 1;

  -- Measures
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gA_id, 'Phase-1 systems live (Sys-1 to Sys-4)', 4, 0, 'systems', 0)
    returning id into mA1;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gA_id, 'Frameworks documented & adopted (FW-1 to FW-7)', 7, 0, 'frameworks', 1)
    returning id into mA2;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gA_id, 'Dashboards live with real data (DB-1 to DB-5)', 5, 0, 'dashboards', 2)
    returning id into mA3;

  -- Initiatives — systems (under mA1)
  insert into public.initiatives (key_result_id, title, description, position) values
    (mA1, 'Sys-1 — Single source of truth tracker',
     'One row per destination: handle, host, properties, login, dates, status, Meta status, host graduation stage.', 0),
    (mA1, 'Sys-2 — Content asset management system',
     'Tool selected, tagging schema defined, library populated with the first raw batch.', 1),
    (mA1, 'Sys-3 — Content calendar & scheduler',
     'Scheduling tool live; all 10 handles'' weekly slots planned ahead.', 2),
    (mA1, 'Sys-4 — Content intake flow',
     'Structured intake from hosts → content management tool, so nothing is lost in DMs and folders.', 3);

  -- Initiatives — frameworks (under mA2) — FW-2 lives under Goal B
  insert into public.initiatives (key_result_id, title, description, position) values
    (mA2, 'FW-1 — Content category & format library v1',
     'Three to four formats (Destination Diaries, Hidden Gems, Local Legends, Collaborators) — each a template + example + cadence.', 0),
    (mA2, 'FW-3 — Content pipeline SOP',
     'Idea → Capture → Create → Review → Publish, with handoffs and SLAs at every step.', 1),
    (mA2, 'FW-4 — Reward, recognition & milestone framework',
     'Perks (free nights, Zo credits, exposure, cash) tied to milestone triggers (views, followers, streaks); verification and payment owned end-to-end.', 2),
    (mA2, 'FW-5 — Creator development playbook',
     'The "what''s in it for the host" engine — how Zostel helps them grow their own audience.', 3),
    (mA2, 'FW-6 — Host offboarding & handover SOP',
     'Document the handover so the destination handle survives a host leaving.', 4),
    (mA2, 'FW-7 — Host sourcing framework',
     'Intake channels, outreach cadence, message templates, and selection scorecard.', 5);

  -- Initiative — dashboards (under mA3) — one rolled-up build
  insert into public.initiatives (key_result_id, title, description, position) values
    (mA3, 'Build the 5 Phase-1 dashboards',
     'DB-1 Coverage · DB-2 Content & publishing · DB-3 Host health · DB-4 Growth & engagement · DB-5 Rewards & ecosystem. One source per dashboard, refreshed weekly.', 0);

  -- ═══ GOAL B — Recruit, onboard & activate 10 hosts ══════════
  insert into public.goals (title, description, quarter, position, status)
       values (
         'Recruit, onboard & activate 10 Destination Hosts',
         'Phase 1 requires 10 hosts signed, each onboarded in under 48 hours, all capturing by Day 60. Destination Hosts are long-term local creators with their own audience-growth motivation — deliberately not the Vibe Curator short-stay model.',
         'Q3 2026',
         next_pos,
         'active'
       )
    returning id into gB_id;
  next_pos := next_pos + 1;

  -- Measures
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gB_id, 'Hosts signed', 10, 0, 'hosts', 0)
    returning id into mB1;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gB_id, 'Average onboarding time per host', 48, 0, 'hours', 1)
    returning id into mB2;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gB_id, 'Hosts actively capturing by Day 60', 10, 0, 'hosts', 2)
    returning id into mB3;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gB_id, 'Hosts retained through Phase 1', 10, 0, 'hosts', 3)
    returning id into mB4;

  -- Initiatives
  insert into public.initiatives (key_result_id, title, description, position) values
    (mB1, 'HT-1 — Define host profile & selection framework',
     'Written profile prioritising existing local creators with intrinsic audience-growth motivation; selection scorecard.', 0),
    (mB1, 'HT-2 — Source & sign 10 hosts',
     'Map sourcing channels, run outreach, and close 10 hosts across the 10 pilot destinations.', 1);
  insert into public.initiatives (key_result_id, title, description, position) values
    (mB2, 'FW-2 — Host onboarding framework',
     'Onboarding kit that gets a host active in under 48 hours: brief, do''s/don''ts, capture guide, tool access. Used by HT-3.', 0);
  insert into public.initiatives (key_result_id, title, description, position) values
    (mB3, 'HT-3 — Onboard & activate all 10 hosts',
     'Run every host through FW-2 and Sys-4; each capturing and feeding intake by Day 60.', 0);

  -- ═══ GOAL C — 10 handles live and posting on cadence ════════
  insert into public.goals (title, description, quarter, position, status)
       values (
         'Get 10 Destination handles live and posting on cadence',
         '10 handles created, claimed, connected to Meta Business Suite, and publishing on cadence — first HQ-produced, with hosts approving their own destination''s posts. Phase 1 exits when cadence sustains ≥80% for 3+ weeks without HQ chasing.',
         'Q3 2026',
         next_pos,
         'active'
       )
    returning id into gC_id;

  -- Measures
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gC_id, 'Handles live & connected to Meta Business Suite', 10, 0, 'handles', 0)
    returning id into mC1;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gC_id, 'Posting cadence hit rate (no chasing)', 80, 0, '%', 1)
    returning id into mC2;
  insert into public.key_results (goal_id, title, current_value, unit, position)
       values (gC_id, 'Average followers per handle (baseline at week 2)', 0, 'followers', 2)
    returning id into mC3;
  insert into public.key_results (goal_id, title, target_value, current_value, unit, position)
       values (gC_id, 'Local collaborations seeded (≥1 per destination)', 10, 0, 'collabs', 3)
    returning id into mC4;

  -- Initiatives
  insert into public.initiatives (key_result_id, title, description, position) values
    (mC1, 'Run-1 — Launch 10 destination handles',
     '10 handles created or claimed, connected to Meta Business Suite, account structure standardised.', 0);
  insert into public.initiatives (key_result_id, title, description, position) values
    (mC2, 'Run-2 — Produce & publish content on cadence',
     'Posts produced from raw captures + FW-1 templates, scheduled via Sys-3, posted to all 10 handles on the agreed cadence.', 0);
  insert into public.initiatives (key_result_id, title, description, position) values
    (mC4, 'Run-3 — Seed first local collaborations',
     'At least one local collaboration initiated per destination (artist, local legend, event, community group).', 0);

  -- ═══ IDEAS — phase 2/3 and creative explorations ════════════
  insert into public.ideas (goal_id, key_result_id, text, status) values
    -- Goal A
    (gA_id, null,  'Add LinkedIn/X production for standout hosts (Phase 3 expansion).',                                 'captured'),
    -- Goal B
    (gB_id, mB4,   'Host Buddy pairing — graduated hosts mentor newcomers as they onboard.',                            'captured'),
    (gB_id, null,  'Annual host summit / celebration — bring all destination hosts together once a year.',              'captured'),
    -- Goal C
    (gC_id, null,  'Pokhara micro-ecosystem playbook — document what''s already emerging organically and replicate it.', 'captured'),
    (gC_id, mC2,   'AI-assisted destination tagging on content capture to speed up the intake step.',                    'captured'),
    -- Program-level (unlinked) — Phase 2/3 macros
    (null,  null,  'Phase 2: scale to 25–30 destination handles, mostly host-led by Day 150.',                          'captured'),
    (null,  null,  'Phase 3: reach 100% destination coverage with a self-sustaining flywheel.',                         'captured'),
    (null,  null,  'Reposition Zostel as "the destination storytelling brand for India" once the network is live.',     'captured');

end $$;

commit;
