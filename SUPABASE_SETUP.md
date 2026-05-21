# Compass — Supabase Setup Guide

This is a one-time setup to turn Compass from a local-only single-user app into a real shared team workspace with Google sign-in.

After you finish steps **1–6**, send me the **Project URL** + **anon (public) key** from step 6 — I'll wire them into the app in a follow-up commit.

Roughly **30 minutes**, all UI-clickable. You'll need a Google Cloud account (free) and a Supabase account (free tier is more than enough).

---

## 1. Create the Supabase project

1. Go to **https://supabase.com** → **Sign in** (use your Google account if you'd like).
2. Click **New Project**.
3. Settings:
   - **Name:** `compass`
   - **Database password:** generate a strong one and **save it in your password manager** — you won't need it again, but losing it is painful.
   - **Region:** pick the one closest to your team (e.g. *South Asia (Mumbai)*).
   - **Pricing plan:** Free.
4. Click **Create new project**. It takes ~2 minutes to provision.

---

## 2. Create the database schema

1. In the Supabase dashboard, left sidebar → **SQL Editor**.
2. Click **New query**.
3. Open `supabase/schema.sql` from this repo, **copy its entire contents**, paste into the editor.
4. Click **Run** (or press Cmd/Ctrl + Enter). Expect "Success. No rows returned."

This creates 7 tables, indexes, the auto-profile trigger, and the row-level-security policies.

---

## 3. Seed the workspace with the current data

1. Same **SQL Editor** → **New query**.
2. Open `supabase/seed.sql`, copy its contents, paste, click **Run**.
3. **Run it exactly once.** Running twice will duplicate every row.

After this, **Table Editor → goals** should show 3 rows, **key_results** should show 9, **initiatives** should show 33, **ideas** should show 31, and **members** should show 7.

---

## 4. Set up Google OAuth (Google Cloud side)

This is the longest step — about 10 minutes of clicking through Google Cloud Console.

1. Go to **https://console.cloud.google.com/** and sign in.
2. Top bar → click the project dropdown → **New Project**. Name it `Compass` (or whatever). Create.
3. Make sure that project is selected in the top bar.
4. Left menu → **APIs & Services** → **OAuth consent screen**.
   - **User Type:** External → Create.
   - **App name:** Compass
   - **User support email:** your email
   - **Developer contact email:** your email
   - Click **Save and Continue** through the next screens (Scopes, Test Users) — you can leave them blank for now.
5. Left menu → **APIs & Services** → **Credentials**.
   - Click **+ Create Credentials** → **OAuth client ID**.
   - **Application type:** Web application
   - **Name:** Compass Web Client
   - **Authorized JavaScript origins:** add the following URLs (one per line):
     - `https://vikasnagpal.github.io`
     - `http://localhost:5173` *(for local development)*
   - **Authorized redirect URIs:** add **one** URL — Supabase will give it to you in the next step. For now, leave this blank and we'll come back.
   - Click **Create**.
   - **Copy the Client ID and Client Secret** — you'll need them in step 5.

---

## 5. Configure Google OAuth in Supabase

1. In your Supabase project → **Authentication** (left sidebar) → **Providers**.
2. Find **Google** in the list, toggle **Enabled**.
3. Paste the **Client ID** and **Client Secret** from Google Cloud.
4. Above those fields, Supabase shows a **Callback URL** like:
   `https://<your-project-id>.supabase.co/auth/v1/callback`
   **Copy this URL.**
5. Click **Save**.

Now go back to Google Cloud Console → **APIs & Services** → **Credentials** → click your OAuth client → under **Authorized redirect URIs**, paste the Supabase callback URL you just copied → **Save**.

---

## 6. Configure auth redirect URLs

Back in Supabase → **Authentication** → **URL Configuration**:

- **Site URL:** `https://vikasnagpal.github.io/Compass/`
- **Redirect URLs (additional):**
  - `https://vikasnagpal.github.io/Compass/**`
  - `http://localhost:5173/**`

Click **Save**.

---

## 7. (Optional) Restrict sign-ups to your team's domain

If you want only `@zostel.com` (or whatever) emails to sign in:

- **Authentication** → **Sign In / Up** → look for **Email Domain Restrictions** (or under **Providers → Google**, depending on Supabase version).
- Add your domain.

Otherwise anyone with a Google account who knows the URL can sign in. For an internal team app, restricting is a good idea.

---

## 8. Grab the credentials and send them to me

Supabase → **Project Settings** (gear icon, bottom left) → **API**.

Copy two values:

1. **Project URL** — looks like `https://abcdefghijkl.supabase.co`
2. **anon / public key** — a long JWT starting with `eyJhbGci...`

Both are safe to commit publicly (the anon key is meant for client-side use; RLS policies protect the data).

Paste both back in chat. I'll plug them into `index.html` and ship the auth + data-layer refactor.

---

## 9. Apply migrations (existing projects)

If you set Compass up before features like goal ownership, quarter close-out, or
the idea lifecycle were added, run the migrations below **in order** in the SQL
Editor. They are idempotent — running twice is safe.

1. `supabase/migration-001.sql` — fixes profile-creation trigger, enables
   realtime replication, and drops the unused members table.
2. `supabase/migration-002.sql` — adds goal owner / lifecycle (active/closed +
   score + reflection) and idea lifecycle states (captured / parked / rejected
   / promoted), plus the link from a promoted idea back to its initiative.

Open each file in the repo, copy the contents into a new SQL Editor query, and
hit **Run**.

---

## What's coming next (after you send the credentials)

I'll:

- Add the Supabase JS client via CDN
- Add a sign-in screen (single "Continue with Google" button) that gates the app
- Replace the localStorage data layer with Supabase queries (with optimistic updates so the UI stays snappy)
- Add a user menu in the top-right showing your avatar + a sign-out option
- Set the author of every comment and status change to the logged-in user, so the Activity Trail shows who said what

---

## Troubleshooting

- **`schema.sql` errors on "create table public.profiles":** the profiles table already exists. Drop and re-create, or skip that block.
- **Seed runs twice and you have duplicates:** open Table Editor → `goals` → delete all rows. Cascading FKs will clean out KRs, initiatives, history, and ideas. Then re-run `seed.sql`. Members are duplicated independently — clean those manually.
- **Google OAuth "redirect URI mismatch" on sign-in:** the URLs in step 4 (Google Cloud) and step 6 (Supabase URL Configuration) need to match exactly. Trailing slashes matter.
- **"row-level security policy" errors:** you're hitting the API as an anonymous user. After the JS refactor, every request will be authenticated.
