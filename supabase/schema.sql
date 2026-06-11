-- ============================================================
-- Compass — schema for Supabase
-- Run this ONCE in your project's SQL editor.
-- Creates tables, indexes, RLS policies, and the
-- auto-profile trigger for newly signed-up users.
-- ============================================================

-- ─── Tables ─────────────────────────────────────────────────

create table public.profiles (
  id                uuid primary key references auth.users on delete cascade,
  display_name      text,
  email             text,
  avatar_url        text,
  created_at        timestamptz default now(),
  -- Catch-up digest markers (migration-005). See that file for semantics.
  last_seen_at      timestamptz,
  last_caught_up_at timestamptz
);

create table public.members (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  created_at  timestamptz default now()
);

create table public.goals (
  id            uuid primary key default gen_random_uuid(),
  title         text not null,
  description   text default '',
  quarter       text not null default 'Q2 2026',
  position      integer not null default 0,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

create table public.key_results (
  id              uuid primary key default gen_random_uuid(),
  goal_id         uuid not null references public.goals on delete cascade,
  title           text not null,
  target_value    numeric,
  current_value   numeric default 0,
  unit            text default '',
  position        integer not null default 0,
  created_at      timestamptz default now(),
  updated_at      timestamptz default now()
);

create table public.initiatives (
  id              uuid primary key default gen_random_uuid(),
  key_result_id   uuid not null references public.key_results on delete cascade,
  title           text not null,
  description     text default '',
  status          text not null default 'not_started'
                  check (status in ('not_started','in_progress','on_track','at_risk','blocked','completed')),
  owner_name      text default '',
  due_date        date,
  position        integer not null default 0,
  created_at      timestamptz default now(),
  updated_at      timestamptz default now()
);

create table public.initiative_history (
  id              uuid primary key default gen_random_uuid(),
  initiative_id   uuid not null references public.initiatives on delete cascade,
  type            text not null check (type in ('created','status_change','comment')),
  event_date      date not null default current_date,
  note            text,
  text            text,
  from_status     text,
  to_status       text,
  author_id       uuid references public.profiles on delete set null,
  author_name     text,
  created_at      timestamptz default now()
);

create table public.ideas (
  id              uuid primary key default gen_random_uuid(),
  goal_id         uuid references public.goals on delete set null,
  key_result_id   uuid references public.key_results on delete set null,
  text            text not null,
  created_by      uuid references public.profiles on delete set null,
  created_at      timestamptz default now()
);

-- ─── Indexes ─────────────────────────────────────────────────

create index idx_kr_goal       on public.key_results (goal_id, position);
create index idx_init_kr       on public.initiatives (key_result_id, position);
create index idx_history_init  on public.initiative_history (initiative_id, created_at desc);
create index idx_ideas_goal    on public.ideas (goal_id);
create index idx_ideas_kr      on public.ideas (key_result_id);

-- ─── Triggers ───────────────────────────────────────────────

create or replace function public.update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger goals_updated_at before update on public.goals
  for each row execute function public.update_updated_at();
create trigger kr_updated_at before update on public.key_results
  for each row execute function public.update_updated_at();
create trigger init_updated_at before update on public.initiatives
  for each row execute function public.update_updated_at();

-- Auto-create profile on auth.user signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data->>'full_name',
      new.raw_user_meta_data->>'name',
      split_part(coalesce(new.email,''), '@', 1)
    ),
    new.raw_user_meta_data->>'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── Row Level Security ─────────────────────────────────────
--
-- This is a shared team workspace: any authenticated user can
-- read and write everything. Sign-ups can be restricted by
-- enabling email domain restrictions in Supabase Auth settings.

alter table public.profiles            enable row level security;
alter table public.members             enable row level security;
alter table public.goals               enable row level security;
alter table public.key_results         enable row level security;
alter table public.initiatives         enable row level security;
alter table public.initiative_history  enable row level security;
alter table public.ideas               enable row level security;

create policy profiles_select on public.profiles
  for select to authenticated using (true);
create policy profiles_insert on public.profiles
  for insert to authenticated with check (auth.uid() = id);
create policy profiles_update on public.profiles
  for update to authenticated using (auth.uid() = id);

create policy members_all on public.members
  for all to authenticated using (true) with check (true);
create policy goals_all on public.goals
  for all to authenticated using (true) with check (true);
create policy kr_all on public.key_results
  for all to authenticated using (true) with check (true);
create policy init_all on public.initiatives
  for all to authenticated using (true) with check (true);
create policy history_all on public.initiative_history
  for all to authenticated using (true) with check (true);
create policy ideas_all on public.ideas
  for all to authenticated using (true) with check (true);
