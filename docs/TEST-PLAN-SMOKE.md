# Smoke test plan

This file is the QA team's concrete smoke and targeted validation matrix.

## Current gate status
- **Sprint 3 alpha return-loop gate: Ready**
- Reason: the three previously missing blockers now have attached evidence: 2-player `Security Alarm`, exact `insufficient_cash` denial proof, and phone-sized Sprint 3 shop/results UI proof after a minimal UI-only hotfix.

## Guardrail
- Do **not** treat structural smoke as gameplay proof.
- Use this plan to separate build checks, runtime regressions, persistence/shop checks, analytics checks, and still-required evidence.

## A. Structural / build smoke

### Required commands
1. `bash scripts/check.sh`
2. `bash scripts/build.sh`
3. `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`

### Current recorded result
- `check.sh` — Pass
- `build.sh` — Pass
- `smoke_runner.lua` — Pass
  - expected pass line: `SMOKE_OK: core folders and scripts are present`

### Acceptance
- Repo checks/build stay green
- Smoke harness confirms required folders/scripts/remotes/modules exist
- Any build warning is called out separately from runtime behavior

## B. Sprint 1 / Sprint 2 no-regression runtime baseline

### Required evidence source
- `project/docs/RUNTIME-EVIDENCE.md`

### Current recorded baseline
- Solo success-path quota/register/payout proof — recorded
- Solo failure payout proof — recorded
- Blackout runtime proof — recorded
- Mimic expire runtime proof — recorded
- Mimic trigger runtime proof — recorded
- 2-player mimic personal-only penalty proof — recorded
- Late-join exclusion proof — recorded
- Phone-sized HUD baseline proof — recorded

### Acceptance
- Do not reopen Sprint 3 as Ready if these regressions lose their evidence trail
- Recheck if any regression appears in new runtime proof or source diffs

## C. Sprint 3 focused runtime proof

### Required command
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint3_proof.lua`

### Current recorded result
- **Pass**

### Currently verified from the proof output
- onboarding analytics emitted
- shop opens in non-playing state
- insufficient-level denial works
- `insufficient_cash` denial works with exact locked copy and distinct deny reason
- purchase succeeds
- equip succeeds
- owned/equipped persistence survives reload
- saved `Cash` and `Level` survive reload
- `Security Alarm` success in solo
- `Security Alarm` fail in solo
- `Security Alarm` success in 2-player co-op
- `Security Alarm` fail in 2-player co-op
- readable co-op alarm prompt/copy confirmed: `Security Panel` / `Reset Alarm`
- duplicate follow-up does not double-resolve the alarm
- register stays locked during alarm and unlocks after reset/fail
- Sprint 3 preview/results cosmetic state is represented in the attached command-backed proof
- structured analytics/log output exists for the locked Sprint 3 return-loop paths exercised by the script

## D. Previously missing proof — now attached

### 1) Co-op `Security Alarm`
- Recorded pass now attached
- Acceptance met:
  - alarm became active with 2 eligible players present
  - one player resolved it successfully
  - duplicate/simultaneous follow-up interaction did not double-resolve it
  - fail path still applied one shared `12s` timer penalty
  - register unlock stayed deferred while alarm was active, then unlocked after resolve/fail

### 2) Shop completion proof
- Recorded pass now attached for:
  - `insufficient_cash` denial
  - Sprint 3 cosmetic representation on the required preview/results surfaces

### 3) Sprint 3 UI readability
- Recorded pass now attached for phone-sized readability on Sprint 3 shop/results surfaces
- Accepted proof type used here:
  - command-backed layout/readability probe that directly covered Sprint 3 shop/results UI after the UI-only hotfix
- Caveat:
  - this is not a human-observed screenshot/clip artifact

## E. Analytics / log proof expectations

### Currently proven in logs
- `profile_loaded`
- `onboarding_shown`
- `onboarding_completed`
- `shop_opened`
- `shop_purchase_denied`
- `shop_purchase_succeeded`
- `cosmetic_equipped`
- `security_alarm_seen`
- `security_alarm_reset`
- `security_alarm_failed`

### Still not shown by the focused Sprint 3 proof itself
- `shift_started`
- `first_task_completed`
- `results_shown`
- `shift_success`
- `shift_failure`

### Acceptance note
- Do not claim those broader funnel events from the focused Sprint 3 proof unless new evidence is attached.

## Exit condition for this file
Sprint 3 may remain **Ready** while all three stay attached to the evidence set:
1. 2-player `Security Alarm` runtime proof
2. final shop proof including `insufficient_cash`
3. player-visible Sprint 3 shop/results representation + phone-sized readability proof
