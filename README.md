# Meeting Action Tracker

A single-page app for tracking the actions agreed in team meetings. Actions are grouped by owner, with a tick box for done, open and done counts, and overdue actions highlighted in red. Data is stored in Supabase and shared by everyone who opens the page.

## What is in this repo

| File | Purpose |
|---|---|
| `index.html` | The whole app: markup, styles and script in one file |
| `vercel.json` | Security headers (including a Content Security Policy that allows only Supabase and Google Fonts) and clean URLs |
| `supabase/schema.sql` | The `meeting_actions` table, its access rules and the sample data, for reference or a fresh project |

There is no build step and no dependencies.

## Deploy to Vercel

1. Sign in at vercel.com and choose **Add New → Project**.
2. Import the `LoonYeongTai/meet-tracker` repository.
3. Leave the settings as detected:
   - Framework Preset: **Other**
   - Build Command: leave empty
   - Output Directory: leave empty (the repo root is served)
   - Install Command: leave empty
4. Choose **Deploy**. No environment variables are needed.

Each push to `main` redeploys automatically.

## Supabase settings

The project URL and publishable key are set near the top of the script in `index.html`:

```js
var SUPABASE_URL = 'https://dhvdpkpuugrwrktbtdvn.supabase.co';
var SUPABASE_KEY = 'sb_publishable_...';
```

The publishable key is designed to be used in browsers. What it can do is controlled by the row-level security rules in `supabase/schema.sql`. These currently let anyone with the page read, add, tick and delete actions.

If you move to another Supabase project, update both values in `index.html` and the `connect-src` address in `vercel.json`, then run `supabase/schema.sql` in that project's SQL editor.

## How it works

- Loads all actions from the `meeting_actions` table through the Supabase REST API.
- Refreshes every 10 seconds and when you return to the tab, so changes from other people appear.
- Changes show on screen at once. If Supabase can't be reached, they are rolled back and a message explains what happened.
- The status badge at the top shows **Live** with the last update time, or **Offline · tap to retry**.

## Data guidance

Use first names or roles for owners. Do not enter NRIC numbers or personal contact details.

## Sign-in and user management

- Users sign in with a username and password. Behind the scenes the username maps to `<username>@meet-tracker.local` in Supabase Auth (`auth.users`).
- Starting users: `priya` (admin), `dan`, `marcus`. Each must choose a new password at first sign-in.
- Admins see **Manage users** to add users with an initial password, reset passwords and remove users. These run through the database functions `admin_create_user`, `admin_reset_password`, `admin_delete_user` and `admin_list_users`, which refuse anyone who is not an admin.
- The `profiles` table stores each user's username, admin flag and whether they must change their password.
