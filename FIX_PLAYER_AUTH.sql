-- Functions only: no credential, statistics, policy, or table changes.
-- Compare with live pg_get_functiondef output before applying.
begin;
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

  delete from public.qb_player_sessions as expired where expired.expires_at<=now();

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
  update public.qb_player_sessions as active_session
  set last_seen_at=now()
  where active_session.session_token=p_token and active_session.expires_at>now();

  return query
  select a.profile_id,a.display_name,a.must_change,s.expires_at
  from public.qb_player_sessions s
  join public.qb_player_access a on a.profile_id=s.profile_id
  where s.session_token=p_token
    and s.expires_at>now()
    and a.enabled=true;
end;
$$;


commit;
