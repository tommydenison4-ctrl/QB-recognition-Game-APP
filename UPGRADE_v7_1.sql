-- ULM QB Conflict Defender v7.1
-- RUN ONCE in Supabase SQL Editor.

-- ---------------------------------------------------------
-- STORED / LIVE QUESTION LIBRARY
-- Existing plays stay LIVE so nothing disappears on upgrade.
-- ---------------------------------------------------------
alter table public.qb_questions
  add column if not exists library_status text default 'live';

update public.qb_questions
set library_status='live'
where library_status is null;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname='qb_questions_library_status_check'
  ) then
    alter table public.qb_questions
      add constraint qb_questions_library_status_check
      check (library_status in ('live','stored'));
  end if;
end $$;

create index if not exists qb_questions_library_status_idx
  on public.qb_questions(library_status);

create index if not exists qb_questions_opponent_idx
  on public.qb_questions(opponent);

-- Coaches can edit names, teams, defender tags, status and library state.
alter table public.qb_questions enable row level security;

drop policy if exists "Authenticated coaches update QB questions"
on public.qb_questions;

create policy "Authenticated coaches update QB questions"
on public.qb_questions
for update
to authenticated
using (true)
with check (true);

-- Keep permanent question deletion working.
drop policy if exists "Authenticated coaches delete QB questions"
on public.qb_questions;

create policy "Authenticated coaches delete QB questions"
on public.qb_questions
for delete
to authenticated
using (true);

drop policy if exists "Authenticated coaches delete QB conflict images"
on storage.objects;

create policy "Authenticated coaches delete QB conflict images"
on storage.objects
for delete
to authenticated
using (bucket_id='qb-conflict-images');

-- New answer window: 1.5 seconds full value + 6.0 decay = 7.5.
alter table public.qb_conflict_results
  drop constraint if exists qb_conflict_results_response_time_check;

alter table public.qb_conflict_results
  add constraint qb_conflict_results_response_time_check
  check (response_time >= 0 and response_time <= 7.5);

-- Keep Reset All Scores button working.
drop policy if exists "Authenticated coaches delete conflict results"
on public.qb_conflict_results;

create policy "Authenticated coaches delete conflict results"
on public.qb_conflict_results
for delete
to authenticated
using (true);
