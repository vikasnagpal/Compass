-- ============================================================
-- Compass — Move FW-2 back under Goal A's frameworks measure
--
-- The original load relocated FW-2 (Host onboarding framework)
-- to Goal B, under "Average onboarding time per host". That left
-- Goal A's measure "Frameworks documented & adopted (FW-1 to FW-7)"
-- with target 7 but only 6 initiatives under it — it could never
-- read more than 6/7.
--
-- This moves FW-2 back under that frameworks measure so all seven
-- frameworks live together and the target of 7 is honest. Goal B's
-- "Average onboarding time per host" measure remains as a watched
-- metric with no initiative (Compass supports measures without
-- initiatives — that's the intended state here).
--
-- Also re-sequences the seven frameworks into canonical
-- FW-1 … FW-7 order.
--
-- Idempotent: safe to re-run. Wrapped in a transaction.
-- Run ONCE in the Supabase SQL Editor.
-- ============================================================

begin;

do $$
declare
  fw_measure_id uuid;
begin
  -- Goal A's frameworks measure (unique title).
  select id into fw_measure_id
    from public.key_results
   where title = 'Frameworks documented & adopted (FW-1 to FW-7)'
   order by created_at
   limit 1;

  if fw_measure_id is null then
    raise exception 'Could not find the "Frameworks documented & adopted (FW-1 to FW-7)" measure.';
  end if;

  -- Reattach FW-2 to the frameworks measure.
  update public.initiatives
     set key_result_id = fw_measure_id
   where title = 'FW-2 — Host onboarding framework';

  -- Re-sequence all seven frameworks into FW-1 … FW-7 order.
  update public.initiatives set position = 0 where key_result_id = fw_measure_id and title like 'FW-1 —%';
  update public.initiatives set position = 1 where key_result_id = fw_measure_id and title like 'FW-2 —%';
  update public.initiatives set position = 2 where key_result_id = fw_measure_id and title like 'FW-3 —%';
  update public.initiatives set position = 3 where key_result_id = fw_measure_id and title like 'FW-4 —%';
  update public.initiatives set position = 4 where key_result_id = fw_measure_id and title like 'FW-5 —%';
  update public.initiatives set position = 5 where key_result_id = fw_measure_id and title like 'FW-6 —%';
  update public.initiatives set position = 6 where key_result_id = fw_measure_id and title like 'FW-7 —%';

end $$;

commit;
