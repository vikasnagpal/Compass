-- ============================================================
-- Compass — diagnostic
--
-- Lists every non-internal trigger on auth.users and prints the
-- full body of the function each one calls. Read-only — no changes.
--
-- Use this when sign-in behaviour doesn't match what you'd expect
-- from public.handle_new_user(). If a *separate* restriction
-- trigger exists, it shows up here and we can fix it.
--
-- Paste the output back so we can see exactly which function is
-- enforcing the domain check.
-- ============================================================

select
  t.tgname                                  as trigger_name,
  case t.tgenabled when 'O' then 'enabled' when 'D' then 'disabled' else t.tgenabled::text end
                                            as trigger_state,
  case
    when t.tgtype & 2 = 2 then 'BEFORE'
    when t.tgtype & 64 = 64 then 'INSTEAD OF'
    else 'AFTER'
  end                                       as fires,
  case
    when t.tgtype & 4 = 4 then 'INSERT'
    when t.tgtype & 8 = 8 then 'DELETE'
    when t.tgtype & 16 = 16 then 'UPDATE'
    else '?'
  end                                       as event,
  n.nspname || '.' || p.proname             as function_name,
  pg_get_functiondef(p.oid)                 as function_body
from pg_trigger t
join pg_proc       p on p.oid = t.tgfoid
join pg_namespace  n on n.oid = p.pronamespace
where t.tgrelid = 'auth.users'::regclass
  and not t.tgisinternal
order by t.tgname;
