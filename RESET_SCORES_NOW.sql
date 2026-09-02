-- OPTIONAL ONE-TIME SCORE RESET
-- Run this only when you want every QB/staff score back to zero.
delete from public.qb_conflict_results;

do $$
begin
  if to_regclass('public.qb_profile_results') is not null then
    execute 'delete from public.qb_profile_results';
  end if;
end $$;
