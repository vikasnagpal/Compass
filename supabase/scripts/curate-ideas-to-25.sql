-- ============================================================
-- Compass — Curate the Ideas wall down to 25
--
-- Replaces all captured ideas with a refined, deduped, simpler-
-- language set of 25. Distributed 8 / 9 / 8 across the three
-- goals.
--
-- Curation logic:
--   • Dropped ~20 ideas that duplicated active initiatives loaded
--     by load-workshop-plan.sql.
--   • Merged thematic duplicates (rewards currency variations →
--     one idea; alumni events + summit → one; etc.).
--   • Dropped vague slogans without concrete shape.
--   • Rewrote every survivor as one short, plain-English line.
--
-- ⚠ Destructive for captured ideas only. Goals, measures,
--    initiatives, profiles — untouched.
--
-- Run ONCE in the Supabase SQL Editor. Wrapped in a transaction.
-- ============================================================

begin;

do $$
declare
  g1_id uuid; g2_id uuid; g3_id uuid;
begin
  select id into g1_id from public.goals where position = 0 order by created_at limit 1;
  select id into g2_id from public.goals where position = 1 order by created_at limit 1;
  select id into g3_id from public.goals where position = 2 order by created_at limit 1;

  if g1_id is null or g2_id is null or g3_id is null then
    raise exception 'Could not find all 3 goals by position 0/1/2.';
  end if;

  -- Wipe the existing 67 captured ideas
  delete from public.ideas;

  -- ─── GOAL 1: Adoption (8 ideas) ────────────────────────────
  insert into public.ideas (goal_id, text, status) values
    (g1_id, 'Shared curator model — one curator covers 2–3 nearby properties in the same circuit.', 'captured'),
    (g1_id, 'Weekend-only curator option — lighter trial commitment for properties testing the program.', 'captured'),
    (g1_id, 'Seasonal curator rotation — different curators for monsoon vs winter to match each property''s energy.', 'captured'),
    (g1_id, '"Best Community Property" quarterly award — plus a Vibe Verified badge for properties hitting the bar.', 'captured'),
    (g1_id, 'AI-based curator-to-property matching to suggest the best fit each cohort.', 'captured'),
    (g1_id, 'PM Communication Kit — a ready-to-share pitch deck for new property managers.', 'captured'),
    (g1_id, 'Small Property Adoption Model — a lighter version of the program for tiny hostels.', 'captured'),
    (g1_id, 'Escalation & support system for friction between PMs and curators.', 'captured');

  -- ─── GOAL 2: Ecosystem quality (9 ideas) ───────────────────
  insert into public.ideas (goal_id, text, status) values
    (g2_id, 'Curator alumni network and annual summit — keep past curators connected as ambassadors.', 'captured'),
    (g2_id, 'Curator rewards currency — Zostel Credits, badges, complimentary room nights.', 'captured'),
    (g2_id, 'Weekly community rituals (Story Sunday, Music Monday) that curators run consistently.', 'captured'),
    (g2_id, 'Inter-hostel themed weeks running simultaneously across properties.', 'captured'),
    (g2_id, 'Daily WhatsApp content prompts for curators.', 'captured'),
    (g2_id, 'Curator Handbook + structured training program.', 'captured'),
    (g2_id, 'Content Operating System — templates, weekly targets, and low-effort frameworks.', 'captured'),
    (g2_id, 'Visibility Dashboard for curator and property performance.', 'captured'),
    (g2_id, 'Curator recruitment strategy refresh — sourcing channels and messaging.', 'captured');

  -- ─── GOAL 3: Brand positioning (8 ideas) ───────────────────
  insert into public.ideas (goal_id, text, status) values
    (g3_id, 'City-wise storytelling campaigns — each city''s character told through its hostels and people.', 'captured'),
    (g3_id, '"Featured Curator" monthly slot on Zostel''s main Instagram.', 'captured'),
    (g3_id, 'Travel creator collaborations — partner with creators for authentic on-property content.', 'captured'),
    (g3_id, 'Guest story collection process to surface real community moments.', 'captured'),
    (g3_id, '"Day in the Life" curator content series.', 'captured'),
    (g3_id, 'Property Storytelling Playbook — how curators capture and share their hostel''s story.', 'captured'),
    (g3_id, 'Long-stay creator residency / fellowship program for top creators.', 'captured'),
    (g3_id, 'Curator Creator Guidelines for on-brand content output.', 'captured');

end $$;

commit;
