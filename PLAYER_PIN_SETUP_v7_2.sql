-- ULM QB Conflict Defender v7.2 PLAYER PIN ACCESS
-- Run ONCE in Supabase SQL Editor before deploying v7.2.

create extension if not exists pgcrypto;

-- =========================================================
-- PLAYER CREDENTIALS
-- No direct client read policies are created for this table.
-- =========================================================
create table if not exists public.qb_player_access (
  profile_id text primary key,
  display_name text not null,
  pin_hash text not null,
  must_change boolean not null default true,
  enabled boolean not null default true,
  updated_at timestamptz not null default now()
);

alter table public.qb_player_access enable row level security;

-- Initial six-digit PINs = jersey number repeated.
insert into public.qb_player_access(profile_id,display_name,pin_hash,must_change,enabled)
values
  ('landon-graves','Landon Graves',crypt('999999',gen_salt('bf')),true,true),
  ('aidan-armenta','Aidan Armenta',crypt('101010',gen_salt('bf')),true,true),
  ('austin-carlisle','Austin Carlisle',crypt('121212',gen_salt('bf')),true,true),
  ('bryson-kimbrough','Bryson Kimbrough',crypt('141414',gen_salt('bf')),true,true),
  ('ty-purdy','Ty Purdy',crypt('161616',gen_salt('bf')),true,true)
on conflict (profile_id) do nothing;

-- =========================================================
-- REMEMBERED DEVICE SESSIONS
-- Random bearer tokens are only exposed by the login RPC.
-- =========================================================
create table if not exists public.qb_player_sessions (
  session_token text primary key,
  profile_id text not null references public.qb_player_access(profile_id) on delete cascade,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null default (now()+interval '30 days'),
  last_seen_at timestamptz not null default now()
);

create index if not exists qb_player_sessions_profile_idx
  on public.qb_player_sessions(profile_id);

create index if not exists qb_player_sessions_expires_idx
  on public.qb_player_sessions(expires_at);

alter table public.qb_player_sessions enable row level security;

-- =========================================================
-- LOGIN
-- =========================================================
create or replace function public.qb_player_login(p_profile_id text,p_pin text)
returns table(
  session_token text,
  profile_id text,
  display_name text,
  must_change boolean,
  expires_at timestamptz
)
language plpgsql
security definer
set search_path=public,extensions
as $$
declare
  a public.qb_player_access%rowtype;
  t text;
  exp timestamptz;
begin
  if p_pin !~ '^[0-9]{6}$' then return; end if;

  select * into a
  from public.qb_player_access
  where qb_player_access.profile_id=p_profile_id
    and enabled=true;

  if not found then return; end if;
  if crypt(p_pin,a.pin_hash)<>a.pin_hash then return; end if;

  delete from public.qb_player_sessions where expires_at<=now();

  t:=encode(gen_random_bytes(32),'hex');
  exp:=now()+interval '30 days';

  insert into public.qb_player_sessions(session_token,profile_id,expires_at)
  values(t,a.profile_id,exp);

  return query select t,a.profile_id,a.display_name,a.must_change,exp;
end;
$$;

-- =========================================================
-- VALIDATE REMEMBERED SESSION
-- =========================================================
create or replace function public.qb_validate_player_session(p_token text)
returns table(
  profile_id text,
  display_name text,
  must_change boolean,
  expires_at timestamptz
)
language plpgsql
security definer
set search_path=public,extensions
as $$
begin
  update public.qb_player_sessions
  set last_seen_at=now()
  where session_token=p_token and expires_at>now();

  return query
  select a.profile_id,a.display_name,a.must_change,s.expires_at
  from public.qb_player_sessions s
  join public.qb_player_access a on a.profile_id=s.profile_id
  where s.session_token=p_token
    and s.expires_at>now()
    and a.enabled=true;
end;
$$;

-- =========================================================
-- REQUIRED FIRST-LOGIN PIN CHANGE
-- Current device remains signed in; all other sessions for
-- that QB are revoked and must use the new PIN.
-- =========================================================
create or replace function public.qb_change_player_pin(p_token text,p_new_pin text)
returns boolean
language plpgsql
security definer
set search_path=public,extensions
as $$
declare
  pid text;
  old_hash text;
begin
  if p_new_pin !~ '^[0-9]{6}$' then
    raise exception 'PIN must contain exactly 6 digits';
  end if;

  select s.profile_id into pid
  from public.qb_player_sessions s
  where s.session_token=p_token and s.expires_at>now();

  if pid is null then return false; end if;

  select pin_hash into old_hash
  from public.qb_player_access
  where profile_id=pid and enabled=true;

  if crypt(p_new_pin,old_hash)=old_hash then
    raise exception 'New PIN must be different from the current PIN';
  end if;

  update public.qb_player_access
  set pin_hash=crypt(p_new_pin,gen_salt('bf')),
      must_change=false,
      updated_at=now()
  where profile_id=pid;

  delete from public.qb_player_sessions
  where profile_id=pid and session_token<>p_token;

  return true;
end;
$$;

create or replace function public.qb_player_logout(p_token text)
returns boolean
language plpgsql
security definer
set search_path=public,extensions
as $$
begin
  delete from public.qb_player_sessions where session_token=p_token;
  return true;
end;
$$;

-- =========================================================
-- SECURE PLAYER RESULT WRITE
-- profile_id is derived SERVER-SIDE from the session token.
-- The browser never chooses which QB receives the result.
-- =========================================================
create or replace function public.qb_save_player_result(
  p_token text,
  p_question_id text,
  p_mode text,
  p_correct_count integer,
  p_response_time numeric,
  p_points integer,
  p_room_code text default null,
  p_game_score integer default null
)
returns boolean
language plpgsql
security definer
set search_path=public,extensions
as $$
declare
  pid text;
begin
  select s.profile_id into pid
  from public.qb_player_sessions s
  join public.qb_player_access a on a.profile_id=s.profile_id
  where s.session_token=p_token
    and s.expires_at>now()
    and a.enabled=true
    and a.must_change=false;

  if pid is null then return false; end if;
  if p_mode not in ('practice','live') then return false; end if;
  if p_correct_count<0 or p_correct_count>2 then return false; end if;
  if p_response_time<0 or p_response_time>7.5 then return false; end if;
  if p_points<0 or p_points>1000 then return false; end if;

  insert into public.qb_conflict_results(
    qb_profile_id,question_id,mode,correct_count,response_time,points,room_code,game_score,played_at
  ) values(
    pid,p_question_id,p_mode,p_correct_count,p_response_time,p_points,p_room_code,p_game_score,now()
  );

  update public.qb_player_sessions
  set last_seen_at=now()
  where session_token=p_token;

  return true;
end;
$$;

-- =========================================================
-- CLOSE THE OLD ANONYMOUS INSERT PATH
-- Players must use qb_save_player_result().
-- Signed-in coaches can still save staff/demo results.
-- =========================================================
drop policy if exists "QB devices insert conflict results"
on public.qb_conflict_results;

drop policy if exists "Authenticated coaches insert conflict results"
on public.qb_conflict_results;

create policy "Authenticated coaches insert conflict results"
on public.qb_conflict_results
for insert
to authenticated
with check (true);

grant execute on function public.qb_player_login(text,text) to anon,authenticated;
grant execute on function public.qb_validate_player_session(text) to anon,authenticated;
grant execute on function public.qb_change_player_pin(text,text) to anon,authenticated;
grant execute on function public.qb_player_logout(text) to anon,authenticated;
grant execute on function public.qb_save_player_result(text,text,text,integer,numeric,integer,text,integer) to anon,authenticated;

-- =========================================================
-- OPTIONAL COACH RESET EXAMPLES
-- If a QB forgets his PIN, run the matching update manually:
--
-- UPDATE qb_player_access SET
--   pin_hash=crypt('999999',gen_salt('bf')),must_change=true
-- WHERE profile_id='landon-graves';
--
-- Then:
-- DELETE FROM qb_player_sessions WHERE profile_id='landon-graves';
-- =========================================================
