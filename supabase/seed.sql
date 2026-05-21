-- ============================================================
-- Compass — one-time seed for Supabase
-- Run this AFTER schema.sql, exactly ONCE in your SQL editor.
-- Populates members, 3 goals, 9 measures, 33 initiatives,
-- the history trail for each, and 31 captured ideas.
-- ============================================================

do $$
declare
  g1 uuid; g2 uuid; g3 uuid;
  g1_m1 uuid; g1_m2 uuid; g1_m3 uuid;
  g2_m1 uuid; g2_m2 uuid; g2_m3 uuid;
  g3_m1 uuid; g3_m2 uuid; g3_m3 uuid;
  i uuid;
begin
  -- ── Members ───────────────────────────────────────────────
  insert into members (name) values
    ('Anaya'), ('Bhavya G'), ('Harpreet Singh'),
    ('Kartikey Seth'), ('Muskan'), ('Swapnil Srivastava'), ('Vikas Nagpal');

  -- ============================================================
  -- GOAL 1 — Adoption
  -- ============================================================
  insert into goals (title, description, quarter, position) values
    ('Increase adoption of the Vibe Curator Program across all Zostel properties',
     'Get property managers to say "We want this." Build clarity, trust, and clear business value so the Vibe Curator Program becomes the default at every Zostel property.',
     'Q2 2026', 0)
  returning id into g1;

  -- ── G1 / M1: active participation ─────────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g1, 'Increase active participation from pilot properties to majority network adoption', 75, 28, '%', 0)
  returning id into g1_m1;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m1, 'Property Manager Communication Kit',
     'A ready-to-share package that explains the program in 10 minutes — what it is, what it''ll cost, what it returns. Designed so a manager can decide on the first call.',
     'in_progress', 'Harpreet Singh', '2026-06-15', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-05', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-22', 'not_started', 'in_progress', 'First draft shared with Manali and Goa managers for feedback.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m1, 'Property Onboarding Process',
     'A standardised path from ''never run a curator program'' to ''first curator on-site'' in under 4 weeks, with clear handoffs between Programs, Operations and the property team.',
     'not_started', 'Swapnil Srivastava', '2026-07-15', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-10', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m1, 'Case Studies from Successful Properties',
     'Short write-ups and videos from properties already running the program — the wins, the rough patches, and what the manager would do differently next time.',
     'not_started', 'Anaya', '2026-06-30', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m1, 'ROI & Success Metrics Dashboard',
     'A live dashboard property managers can actually open — bookings, ratings, content output, repeat guests. Makes the program''s value a number, not a vibe.',
     'not_started', 'Vikas Nagpal', '2026-07-15', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m1, 'Small Property Adoption Model',
     'A lighter version of the program for smaller hostels (under 30 beds) — fewer hours, simpler reporting, same vibe. Removes ''we''re too small'' as a reason to say no.',
     'not_started', 'Kartikey Seth', '2026-07-30', 4)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  -- ── G1 / M2: PM satisfaction & trust ──────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g1, 'Improve property manager satisfaction and trust in the program', 65, 32, 'NPS', 1)
  returning id into g1_m2;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m2, 'Shared Alignment Session Before Curator Arrival',
     'A structured 30-minute call between property manager and curator before the curator arrives — goals, boundaries, working style, schedules, comms preferences. Replaces ''we''ll figure it out'' with ''we already did''.',
     'in_progress', 'Harpreet Singh', '2026-06-15', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-08', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-28', 'not_started', 'in_progress', 'Drafting the structured intro-call agenda template — covers goals, boundaries, working style, schedules and comms.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m2, 'Property Manager ↔ Curator Collaboration Framework',
     'Defines how the two roles work together day-to-day — weekly rituals, shared dashboards, who decides what. So collaboration isn''t left to chemistry alone.',
     'not_started', 'Swapnil Srivastava', '2026-07-15', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m2, 'Escalation & Support System',
     'A clear, low-friction path for managers and curators to flag problems — who they talk to, how fast they''ll hear back, what gets resolved at each level. Cuts ''I didn''t know who to call'' from the equation.',
     'not_started', 'Harpreet Singh', '2026-07-31', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m2, 'Property Manager Playbook',
     'A short, opinionated guide for managers running the program — what to expect, what good looks like, when to nudge. Treats the manager as a program operator, not a bystander.',
     'not_started', 'Anaya', '2026-06-30', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  -- ── G1 / M3: role-misuse, boundaries ──────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g1, 'Reduce operational misuse and role-boundary conflicts', 90, 55, '% incident-free', 2)
  returning id into g1_m3;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m3, 'Program SOPs & Role Clarity Framework',
     'The source of truth on who-does-what across curators, property managers and central teams. Removes the grey zones that cause friction in week two.',
     'in_progress', 'Swapnil Srivastava', '2026-06-30', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-08', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-30', 'not_started', 'in_progress', 'Drafting RACI matrix for curator vs property manager responsibilities.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m3, 'Curator Responsibility Matrix',
     'A one-pager mapping every curator activity — content, community moments, guest interactions, reporting — to a clear owner. So nobody wonders ''wait, was that mine?''',
     'not_started', 'Swapnil Srivastava', '2026-07-15', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g1_m3, 'Standardized Participation Guidelines',
     'Baseline expectations for any property running the program — minimum curator hours, content cadence, community events. So a guest''s experience doesn''t depend on which hostel they walked into.',
     'not_started', 'Harpreet Singh', '2026-07-31', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  -- ============================================================
  -- GOAL 2 — Quality & Content
  -- ============================================================
  insert into goals (title, description, quarter, position) values
    ('Build a scalable, high-quality Vibe Curator ecosystem that consistently delivers strong guest experiences and content output',
     'Every guest at a Vibe-curated property should walk away saying "This experience was amazing." Consistent curator quality, retention, engagement, and content output across the network.',
     'Q2 2026', 1)
  returning id into g2;

  -- ── G2 / M1: curator quality, retention ───────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g2, 'Improve curator quality, retention, and completion rates', 85, 62, '% completion', 0)
  returning id into g2_m1;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m1, 'Curator Recruitment Strategy',
     'A coordinated approach to finding curators — tier-2/3 city creators, niche travel communities, college networks. Targets people who show up for the community, not just the Instagram.',
     'on_track', 'Bhavya G', '2026-06-30', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-05', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-25', 'not_started', 'on_track', 'Targeting creators in tier-2/3 cities and niche travel community pages — first outreach batch live.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m1, 'Selection & Evaluation Framework',
     'A consistent way to assess applicants beyond ''do they make nice content?'' — community instincts, on-property fit, reliability under low supervision.',
     'in_progress', 'Bhavya G', '2026-06-15', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-05', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m1, 'Curator Handbook & Training',
     'The crash course every new curator goes through before stepping on a property — the role, the standards, the rituals, the boundaries, and what earns repeat bookings.',
     'in_progress', 'Anaya', '2026-06-30', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-08', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m1, 'Recognition & Incentive System',
     'Visible appreciation built into the program — monthly recognition, room credits, feature spots. So curators feel seen for the work, not just paid for it.',
     'not_started', 'Bhavya G', '2026-07-31', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-18', 'Initiative created');

  -- ── G2 / M2: guest engagement ─────────────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g2, 'Improve guest engagement and social experience across properties', 4.6, 4.1, 'rating', 1)
  returning id into g2_m2;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m2, 'Activity Playbook Library',
     'A growing library of community-building activities — morning circles, local-food nights, music jams — each with what-you''ll-need, how-to-run-it and lessons from past runs.',
     'in_progress', 'Anaya', '2026-06-30', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-08', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m2, 'Curator Community System',
     'Infrastructure for curators to know and learn from each other — WhatsApp groups, regional pods, shared resources. A solo curator at a remote hostel never feels solo.',
     'not_started', 'Bhavya G', '2026-07-30', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m2, 'Weekly Showcase / Idea Sharing Calls',
     'A standing 45-minute weekly call where curators bring their best content, one win and one stumble. Builds momentum, surfaces ideas, reduces the central team''s load.',
     'on_track', 'Anaya', '2026-05-31', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-05-02', 'not_started', 'on_track', 'Weekly calls running every Friday — getting ~80% attendance from active curators.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m2, 'Content Buddy System',
     'Curator-to-curator pairing for creative feedback. Two curators paired for a month — they bounce ideas, review each other''s posts, and pick each other up on slow weeks.',
     'not_started', 'Bhavya G', '2026-07-30', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  -- ── G2 / M3: content consistency ──────────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g2, 'Improve curator content consistency and reduce manual follow-up dependency', 85, 45, '% on weekly cadence', 2)
  returning id into g2_m3;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Content Operating System',
     'The umbrella system that turns ''making content'' from a guessing game into a weekly rhythm. Includes targets, templates, formats and a low-effort fallback for hard weeks.',
     'in_progress', 'Anaya', '2026-06-30', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-05-02', 'not_started', 'in_progress', 'Locked weekly targets and started building the templates library.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Weekly measurable targets',
     'A concrete weekly output target — X reels, X videos, X posts, X guest interactions. So curators know what ''doing the job well'' looks like by Friday afternoon.',
     'on_track', 'Anaya', '2026-05-31', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-18', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-25', 'not_started', 'on_track', 'Defined: X reels, X videos, X posts, X guest interactions per week.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Weekly content templates',
     'Four ready-to-shoot weekly formats — Hostel Vibe, Guest Story, Activity Reel, Local Recommendation. Removes the ''what should I post?'' decision every week.',
     'in_progress', 'Anaya', '2026-06-15', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-20', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-05-05', 'not_started', 'in_progress', '4 weekly formats drafted: Hostel Vibe, Guest Story, Activity Reel, Local Recommendation.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Low-effort content framework',
     'Five formats designed for low-energy days — POV trends, room tour, sunset timelapse, café moments, guest reactions. 10 minutes of shooting, still on-brand.',
     'not_started', 'Anaya', '2026-07-15', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-22', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Plug & Play Creator Toolkit',
     'A shared library of trending audio, hooks, captions, reel structures and editable templates. Cuts the ''staring at a blank screen'' part of curator work.',
     'not_started', 'Muskan', '2026-07-15', 4)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-22', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Visibility Dashboard',
     'A real-time view of curator content output and engagement — who''s posting, who''s silent, who''s breaking out. Shifts central-team energy from chasing reports to supporting where it matters.',
     'not_started', 'Vikas Nagpal', '2026-08-15', 5)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-25', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g2_m3, 'Curator Onboarding Redesign',
     'A reimagined first week for curators — why content matters, what success looks like, real examples of past wins. Sets a higher floor for everyone who joins after.',
     'not_started', 'Anaya', '2026-07-31', 6)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-25', 'Initiative created');

  -- ============================================================
  -- GOAL 3 — Brand & Community Movement
  -- ============================================================
  insert into goals (title, description, quarter, position) values
    ('Position the Vibe Curator Program as a recognizable hospitality-community movement that strengthens the Zostel brand',
     'Make the market say "I want to be part of this." Build aspiration, applications, and storytelling around the curator program — and through it, around Zostel itself.',
     'Q2 2026', 2)
  returning id into g3;

  -- ── G3 / M1: visibility, engagement ───────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g3, 'Increase visibility and engagement around the "Zostel vibe"', 6, 3.2, '% engagement', 0)
  returning id into g3_m1;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m1, 'Instagram Content Strategy',
     'A clear creative direction for Zostel''s Instagram around the curator program — pillars, posting cadence, who-creates-what. Moves the channel from ''curator content lives here too'' to ''this is where curator culture is built''.',
     'in_progress', 'Muskan', '2026-06-30', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-05', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m1, 'LinkedIn Thought Leadership Strategy',
     'A LinkedIn-native voice that positions Zostel — and the curator program specifically — as a real hospitality movement. Less ''we got an award'', more ''here''s how we think about community-led travel''.',
     'not_started', 'Muskan', '2026-07-31', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m1, 'Community-Led Campaigns',
     'Campaigns where the community is the creative — guest-submitted stories, curator-led series, property-driven themes. The kind of momentum a brand team alone can''t generate.',
     'not_started', 'Bhavya G', '2026-08-15', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m1, 'Guest Story Collection Process',
     'A simple, repeatable way to capture the moments that already happen at Zostel — unexpected friendships, impromptu jam sessions, long bus rides. Turns WhatsApp anecdotes into shareable content.',
     'in_progress', 'Anaya', '2026-06-30', 3)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  -- ── G3 / M2: storytelling ─────────────────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g3, 'Generate consistent destination and property-level storytelling', 50, 18, '% featured monthly', 1)
  returning id into g3_m2;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m2, '"Day in the Life" Content Series',
     'Short-form video series with a real curator at the centre — what their day looks like, what they''re proud of, what surprised them this week. Doubles as a recruitment magnet.',
     'on_track', 'Anaya', '2026-07-15', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-10', 'Initiative created');
  insert into initiative_history (initiative_id, type, event_date, from_status, to_status, note) values (i, 'status_change', '2026-04-28', 'not_started', 'on_track', 'First three episodes filmed across Kasol, Coorg and Spiti.');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m2, 'Property Storytelling Playbook',
     'A field guide for capturing each property''s character — what makes Kasol different from Coorg, beyond the view. Gives content teams a clear angle for every property feature.',
     'not_started', 'Anaya', '2026-07-15', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-12', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m2, 'Curator Creator Guidelines',
     'The visual and tonal rules of the road for curator content — what fits the brand, what doesn''t, where to take creative liberties. Keeps the network of voices consistent without flattening them.',
     'not_started', 'Muskan', '2026-06-30', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  -- ── G3 / M3: inbound applications ─────────────────────────
  insert into key_results (goal_id, title, target_value, current_value, unit, position) values
    (g3, 'Increase inbound curator applications and brand aspiration', 1200, 420, 'applications/qtr', 2)
  returning id into g3_m3;

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m3, 'Partnership & Collaboration Strategy',
     'A coordinated plan for partnering with creators, travel media and cultural orgs who already speak to Zostel''s audience. Reach without scaling the in-house team 10x.',
     'not_started', 'Muskan', '2026-08-15', 0)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-18', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m3, 'Curator Brand Positioning Framework',
     'The strategic story behind ''why this program'' — what it stands for, who it''s for, what it gives back. Anchors every piece of curator communication in one consistent narrative.',
     'not_started', 'Muskan', '2026-06-30', 1)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-15', 'Initiative created');

  insert into initiatives (key_result_id, title, description, status, owner_name, due_date, position) values
    (g3_m3, 'Creator-focused recruitment storytelling',
     'Recruitment content that speaks to creators in their language — what they''ll learn, who they''ll meet, where it''ll take them. Pulls in applicants who already share the program''s values.',
     'not_started', 'Bhavya G', '2026-07-15', 2)
  returning id into i;
  insert into initiative_history (initiative_id, type, event_date, note) values (i, 'created', '2026-04-20', 'Initiative created');

  -- ============================================================
  -- IDEAS — 31 captured ideas across all 9 measures
  -- ============================================================

  -- G1 / M1
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g1, g1_m1, 'Shared curator model for nearby properties — one curator covers 2–3 adjacent hostels in the same circuit.', '2026-05-04'),
    (g1, g1_m1, 'Weekend-only curator deployment — lighter commitment for properties testing the program.', '2026-05-06'),
    (g1, g1_m1, 'Seasonal curator rotation — different curators for monsoon vs winter to match each property''s energy.', '2026-05-08');

  -- G1 / M2
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g1, g1_m2, 'Include property managers in curator selection — share shortlist and let them pick the best fit. Makes the manager a co-owner of program success.', '2026-05-10'),
    (g1, g1_m2, 'Property manager recognition program — visible appreciation for managers championing the Vibe Curator Program.', '2026-05-12'),
    (g1, g1_m2, '"Best Community Property" awards — quarterly recognition for properties delivering the strongest vibe.', '2026-05-14'),
    (g1, g1_m2, 'Run a structured intro call between property manager and curator BEFORE the curator arrives — align on goals, boundaries, working style, schedules and communication preferences. Cuts surprise and friction in week one.', '2026-05-08');

  -- G1 / M3
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g1, g1_m3, 'Property vibe certification system — properties earn a "Vibe Verified" badge after meeting community-experience criteria.', '2026-05-15'),
    (g1, g1_m3, 'AI-based curator-property matching — algorithm to suggest the best curator fit for each property''s profile.', '2026-05-17');

  -- G2 / M1
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g2, g2_m1, 'Curator leveling system — explicit progression (Rookie → Pro → Master) with unlockable perks at each stage.', '2026-05-05'),
    (g2, g2_m1, 'Curator alumni network events — keep past curators connected and use them as program ambassadors.', '2026-05-08'),
    (g2, g2_m1, 'Curator badges / collectibles — physical pins or digital collectibles earned through milestones.', '2026-05-11'),
    (g2, g2_m1, 'Make Zostel Credits / XP points / complimentary room nights the core curator currency. Feels Zostel-native, transferable across properties, and fuels travel for the people who build our community.', '2026-05-16');

  -- G2 / M2
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g2, g2_m2, 'Hostel community rituals — weekly recurring moments (Story Sunday, Music Mondays) that curators run consistently.', '2026-05-09'),
    (g2, g2_m2, 'Inter-hostel community events — coordinated nights or themed weeks happening simultaneously across properties.', '2026-05-12'),
    (g2, g2_m2, 'National curator summit — annual gathering where curators across India meet, swap ideas, and celebrate.', '2026-05-15');

  -- G2 / M3
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g2, g2_m3, '"Vibe Curator Superhero" video series — slightly overacted scenarios showing exactly what a great curator looks like on the ground. Doubles as a recruitment and onboarding asset.', '2026-05-12'),
    (g2, g2_m3, 'XP / gamification system — earn points for content output, engagement, and consistency.', '2026-05-13'),
    (g2, g2_m3, 'Automated content reminders — WhatsApp-based nudges with the day''s content prompt.', '2026-05-15'),
    (g2, g2_m3, 'Internal curator leaderboard — public dashboard showing who''s putting out the strongest content this week.', '2026-05-17'),
    (g2, g2_m3, 'Weekly curator showcase calls — curators present their best content and share ideas with peers. Builds momentum, surfaces what works, and reduces dependency on the central content team.', '2026-05-15');

  -- G3 / M1
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g3, g3_m1, 'Community documentary series — long-form video pieces capturing real Zostel community stories.', '2026-05-06'),
    (g3, g3_m1, 'City-wise vibe storytelling campaigns — each city''s unique character told through its properties and curators.', '2026-05-09'),
    (g3, g3_m1, '"Travel with Zostel" creator collaborations — partner with travel creators for authentic on-property content.', '2026-05-12'),
    (g3, g3_m1, 'Featured Curator slot on Zostel''s main Instagram every month — top-performing curator gets the spotlight. Both a reward for them and a recruitment magnet for the next batch.', '2026-05-14');

  -- G3 / M2
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g3, g3_m2, 'Property manager influencer series — feature managers as the human face of each property.', '2026-05-11'),
    (g3, g3_m2, 'Destination ambassador program — locals who represent the spirit of each Zostel city.', '2026-05-14');

  -- G3 / M3
  insert into ideas (goal_id, key_result_id, text, created_at) values
    (g3, g3_m3, 'Zostel Creator Academy — a structured learning program for aspiring travel creators.', '2026-05-13'),
    (g3, g3_m3, 'Curator residency program — multi-month embedded stays for top creators across properties.', '2026-05-15'),
    (g3, g3_m3, 'Travel creator fellowship — paid fellowship for emerging creators to live the Zostel life and create.', '2026-05-17');

end $$;
