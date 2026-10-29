-- Meeting Action Tracker: table and access rules.
-- Already applied to project dhvdpkpuugrwrktbtdvn on 29 Oct 2026.
-- Keep this file for reference or to set up a new Supabase project (run it in the SQL editor).

create table public.meeting_actions (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(btrim(title)) between 1 and 200),
  owner text not null check (char_length(btrim(owner)) between 1 and 40),
  due_date date not null,
  done boolean not null default false,
  done_at timestamptz,
  is_sample boolean not null default false,
  created_at timestamptz not null default now()
);

create index meeting_actions_owner_idx on public.meeting_actions (lower(owner));
create index meeting_actions_due_idx on public.meeting_actions (due_date);

alter table public.meeting_actions enable row level security;

-- Open team access: anyone holding the publishable key can use the tracker.
create policy "meeting_actions_select" on public.meeting_actions
  for select to anon, authenticated using (true);
create policy "meeting_actions_insert" on public.meeting_actions
  for insert to anon, authenticated with check (true);
create policy "meeting_actions_update" on public.meeting_actions
  for update to anon, authenticated using (true) with check (true);
create policy "meeting_actions_delete" on public.meeting_actions
  for delete to anon, authenticated using (true);

-- Optional sample data (shown with a "Clear samples" button in the app)
insert into public.meeting_actions (title, owner, due_date, done, done_at, is_sample) values
  ('Send updated rostering template to outlet managers', 'Aisha', '2026-10-25', false, null, true),
  ('Confirm festive window display plan with all outlets', 'Aisha', '2026-10-30', false, null, true),
  ('Review stock count variance at Tampines outlet', 'Daniel', '2026-10-28', false, null, true),
  ('Book promoter briefing for the 11.11 sale', 'Daniel', '2026-11-04', false, null, true),
  ('Share Q3 shrinkage figures with finance', 'Mei Ling', '2026-10-29', false, null, true),
  ('Update opening hours on outlet signage', 'Mei Ling', '2026-10-26', true, now(), true),
  ('Collect cashier feedback on the new receipt layout', 'Raj', '2026-11-08', false, null, true);

-- Sign-in and user management (profiles table, admin functions, created_by column)
-- were added on 29 Oct 2026 by the Supabase migration "add_user_management".
-- See Database → Migrations in the Supabase dashboard for the full SQL.
