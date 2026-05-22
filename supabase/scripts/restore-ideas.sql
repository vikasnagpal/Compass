-- ============================================================
-- Compass — Restore captured ideas after the reset wipe
--
-- The earlier reset-to-new-plan.sql script also cleared the Ideas
-- wall, which wasn't the intent. This script rebuilds the wall by:
--   1. Re-inserting the 30 original captured ideas from seed.sql.
--   2. Re-inserting the 37 initiatives that were moved to ideas
--      in the prior step (initiatives-to-ideas.sql) — also as
--      'captured' ideas.
--
-- Each idea is linked to the corresponding NEW goal (by position),
-- so they appear under the right goal filter on the Ideas wall.
-- key_result_id is left null because the new measure structure
-- doesn't 1:1 map the old one — promote / re-link via the UI when
-- planning the next iteration.
--
-- Run ONCE in the Supabase SQL Editor, AFTER reset-to-new-plan.sql.
-- Wrapped in a transaction; rolls back on any error.
--
-- Note: this restores the SEEDED ideas only. Any captured ideas
-- you may have added manually after the seed are not recoverable
-- from the repo and would need to be re-typed if you remember them.
-- ============================================================

begin;

do $$
declare
  g1_id uuid;
  g2_id uuid;
  g3_id uuid;
begin
  -- Map new goals back to the seed's g1/g2/g3 by position
  select id into g1_id from public.goals where position = 0 order by created_at limit 1;
  select id into g2_id from public.goals where position = 1 order by created_at limit 1;
  select id into g3_id from public.goals where position = 2 order by created_at limit 1;

  if g1_id is null or g2_id is null or g3_id is null then
    raise exception 'Could not find all 3 goals by position 0/1/2. Run reset-to-new-plan.sql first.';
  end if;

  -- Seed ideas (30)
  insert into public.ideas (goal_id, text, status) values
    (g1_id, 'Shared curator model for nearby properties — one curator covers 2–3 adjacent hostels in the same circuit.', 'captured'),
    (g1_id, 'Weekend-only curator deployment — lighter commitment for properties testing the program.', 'captured'),
    (g1_id, 'Seasonal curator rotation — different curators for monsoon vs winter to match each property''s energy.', 'captured'),
    (g1_id, 'Include property managers in curator selection — share shortlist and let them pick the best fit. Makes the manager a co-owner of program success.', 'captured'),
    (g1_id, 'Property manager recognition program — visible appreciation for managers championing the Vibe Curator Program.', 'captured'),
    (g1_id, '"Best Community Property" awards — quarterly recognition for properties delivering the strongest vibe.', 'captured'),
    (g1_id, 'Run a structured intro call between property manager and curator BEFORE the curator arrives — align on goals, boundaries, working style, schedules and communication preferences. Cuts surprise and friction in week one.', 'captured'),
    (g1_id, 'Property vibe certification system — properties earn a "Vibe Verified" badge after meeting community-experience criteria.', 'captured'),
    (g1_id, 'AI-based curator-property matching — algorithm to suggest the best curator fit for each property''s profile.', 'captured');

  insert into public.ideas (goal_id, text, status) values
    (g2_id, 'Curator leveling system — explicit progression (Rookie → Pro → Master) with unlockable perks at each stage.', 'captured'),
    (g2_id, 'Curator alumni network events — keep past curators connected and use them as program ambassadors.', 'captured'),
    (g2_id, 'Curator badges / collectibles — physical pins or digital collectibles earned through milestones.', 'captured'),
    (g2_id, 'Make Zostel Credits / XP points / complimentary room nights the core curator currency. Feels Zostel-native, transferable across properties, and fuels travel for the people who build our community.', 'captured'),
    (g2_id, 'Hostel community rituals — weekly recurring moments (Story Sunday, Music Mondays) that curators run consistently.', 'captured'),
    (g2_id, 'Inter-hostel community events — coordinated nights or themed weeks happening simultaneously across properties.', 'captured'),
    (g2_id, 'National curator summit — annual gathering where curators across India meet, swap ideas, and celebrate.', 'captured'),
    (g2_id, '"Vibe Curator Superhero" video series — slightly overacted scenarios showing exactly what a great curator looks like on the ground. Doubles as a recruitment and onboarding asset.', 'captured'),
    (g2_id, 'XP / gamification system — earn points for content output, engagement, and consistency.', 'captured'),
    (g2_id, 'Automated content reminders — WhatsApp-based nudges with the day''s content prompt.', 'captured'),
    (g2_id, 'Internal curator leaderboard — public dashboard showing who''s putting out the strongest content this week.', 'captured'),
    (g2_id, 'Weekly curator showcase calls — curators present their best content and share ideas with peers. Builds momentum, surfaces what works, and reduces dependency on the central content team.', 'captured');

  insert into public.ideas (goal_id, text, status) values
    (g3_id, 'Community documentary series — long-form video pieces capturing real Zostel community stories.', 'captured'),
    (g3_id, 'City-wise vibe storytelling campaigns — each city''s unique character told through its properties and curators.', 'captured'),
    (g3_id, '"Travel with Zostel" creator collaborations — partner with travel creators for authentic on-property content.', 'captured'),
    (g3_id, 'Featured Curator slot on Zostel''s main Instagram every month — top-performing curator gets the spotlight. Both a reward for them and a recruitment magnet for the next batch.', 'captured'),
    (g3_id, 'Property manager influencer series — feature managers as the human face of each property.', 'captured'),
    (g3_id, 'Destination ambassador program — locals who represent the spirit of each Zostel city.', 'captured'),
    (g3_id, 'Zostel Creator Academy — a structured learning program for aspiring travel creators.', 'captured'),
    (g3_id, 'Curator residency program — multi-month embedded stays for top creators across properties.', 'captured'),
    (g3_id, 'Travel creator fellowship — paid fellowship for emerging creators to live the Zostel life and create.', 'captured');

  -- Former initiatives moved to ideas (37)
  insert into public.ideas (goal_id, text, status) values
    (g1_id, 'Property Manager Communication Kit', 'captured'),
    (g1_id, 'Property Onboarding Process', 'captured'),
    (g1_id, 'Case Studies from Successful Properties', 'captured'),
    (g1_id, 'ROI & Success Metrics Dashboard', 'captured'),
    (g1_id, 'Small Property Adoption Model', 'captured'),
    (g1_id, 'Shared Alignment Session Before Curator Arrival', 'captured'),
    (g1_id, 'Property Manager ↔ Curator Collaboration Framework', 'captured'),
    (g1_id, 'Escalation & Support System', 'captured'),
    (g1_id, 'Property Manager Playbook', 'captured'),
    (g1_id, 'Program SOPs & Role Clarity Framework', 'captured'),
    (g1_id, 'Curator Responsibility Matrix', 'captured'),
    (g1_id, 'Standardized Participation Guidelines', 'captured');

  insert into public.ideas (goal_id, text, status) values
    (g2_id, 'Curator Recruitment Strategy', 'captured'),
    (g2_id, 'Selection & Evaluation Framework', 'captured'),
    (g2_id, 'Curator Handbook & Training', 'captured'),
    (g2_id, 'Recognition & Incentive System', 'captured'),
    (g2_id, 'Activity Playbook Library', 'captured'),
    (g2_id, 'Curator Community System', 'captured'),
    (g2_id, 'Weekly Showcase / Idea Sharing Calls', 'captured'),
    (g2_id, 'Content Buddy System', 'captured'),
    (g2_id, 'Content Operating System', 'captured'),
    (g2_id, 'Weekly measurable targets', 'captured'),
    (g2_id, 'Weekly content templates', 'captured'),
    (g2_id, 'Low-effort content framework', 'captured'),
    (g2_id, 'Plug & Play Creator Toolkit', 'captured'),
    (g2_id, 'Visibility Dashboard', 'captured'),
    (g2_id, 'Curator Onboarding Redesign', 'captured');

  insert into public.ideas (goal_id, text, status) values
    (g3_id, 'Instagram Content Strategy', 'captured'),
    (g3_id, 'LinkedIn Thought Leadership Strategy', 'captured'),
    (g3_id, 'Community-Led Campaigns', 'captured'),
    (g3_id, 'Guest Story Collection Process', 'captured'),
    (g3_id, '"Day in the Life" Content Series', 'captured'),
    (g3_id, 'Property Storytelling Playbook', 'captured'),
    (g3_id, 'Curator Creator Guidelines', 'captured'),
    (g3_id, 'Partnership & Collaboration Strategy', 'captured'),
    (g3_id, 'Curator Brand Positioning Framework', 'captured'),
    (g3_id, 'Creator-focused recruitment storytelling', 'captured');

end $$;

commit;

