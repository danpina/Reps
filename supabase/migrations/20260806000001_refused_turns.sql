-- A third kind of AI request: one the model declined to answer.
--
-- Refusals go in the same ledger as the calls that succeeded, because from a
-- billing point of view they are the same thing — the request was made and
-- paid for. Counting them separately is what lets a run of them pause the
-- rehearsal without touching the ordinary turn allowance.

alter table public.ai_requests
  drop constraint ai_requests_kind_check;

alter table public.ai_requests
  add constraint ai_requests_kind_check
  check (kind in ('partner_turn', 'feedback', 'refused_turn'));
