# QA

## Sprint 3 alpha return-loop gate — 2026-04-03

### Verdict
- **Ready**

### Concise summary
- Structural/build proof is green: `bash scripts/check.sh`, `bash scripts/build.sh`, and `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` all passed.
- Command-backed Sprint 3 proof now covers the previously missing blockers: 2-player `Security Alarm`, exact `insufficient_cash` denial behavior, and Sprint 3 shop/results phone-sized UI proof after a minimal UI-only hotfix.
- Sprint 1 / Sprint 2 critical no-regression evidence remains documented in `project/docs/RUNTIME-EVIDENCE.md` for blackout, mimic, `Close Register`, late join, payout, and HUD baseline.
- Sprint 3 can flip to **Ready** on this narrow recheck because the three blocker gaps called out earlier now have attached evidence in `project/docs/RUNTIME-EVIDENCE.md`.

## What is verified

### 1) Structural / build proof
- `bash scripts/check.sh` — **Pass**
  - `0 errors`, `0 warnings`, `0 parse errors`
- `bash scripts/build.sh` — **Pass**
  - build succeeded; only remaining warning is the known Rojo `Remotes.model.json` top-level `Name` warning
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` — **Pass**
  - output: `SMOKE_OK: core folders and scripts are present`

### 2) Runtime gameplay proof
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint3_proof.lua` — **Pass**
- Verified in the focused Sprint 3 runtime proof:
  - `Security Alarm` **success** path in solo
  - `Security Alarm` **fail** path in solo
  - `Security Alarm` **success** path in 2-player co-op
  - `Security Alarm` **fail** path in 2-player co-op
  - readable active prompt/copy confirmed: `Security Panel` / `Reset Alarm`
  - both eligible players saw the alarm in co-op
  - one player resolved it for the team
  - duplicate follow-up did not double-resolve it
  - register stays locked during active alarm
  - register unlock is restored after successful reset
  - fail path applies one shared `-12s` timer penalty and register unlock stays deferred until resolve/fail
- Verified no-regression baseline from `project/docs/RUNTIME-EVIDENCE.md`:
  - blackout runtime pass exists
  - mimic expire runtime pass exists
  - mimic trigger runtime pass exists
  - `Close Register` lock/unlock runtime pass exists
  - late-join exclusion runtime pass exists
  - 2-player mimic personal-only penalty runtime pass exists

### 3) Persistence / shop proof
- Verified in the focused Sprint 3 proof:
  - shop opens in a non-playing state
  - level-lock denial works
  - `insufficient_cash` denial works with the exact locked copy: `Not enough Cash. Finish another shift.`
  - `insufficient_cash` uses the distinct denial reason and does not mutate ownership/equipped/cash state on failure
  - purchase succeeds
  - equip succeeds after ownership
  - owned cosmetic persists after reload/rejoin
  - equipped cosmetic persists after reload/rejoin
  - saved `Cash` persists after purchase/reload (`cash=120` in proof)
  - saved `Level` persists after reload (`level=3` in proof)
  - Sprint 3 preview/results proof shows equipped cosmetic state represented on the relevant surface in the attached command-backed evidence

### 4) Analytics / log proof
- Structured local log evidence exists for these exact Sprint 3 paths:
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
- Event names match the locked snake_case contract in `project/docs/KPI-CANDIDATES-S3.md` / `project/docs/HANDOFF-ENGINEERING.md`.
- Local structured logs are acceptable alpha proof here; no external dashboard confirmation is claimed.

## What is still unverified
- **Broader Sprint 3 funnel analytics proof**
  - this focused pass still did not itself show `shift_started`, `first_task_completed`, `results_shown`, `shift_success`, or `shift_failure`
  - do not claim those runtime analytics paths from this focused proof alone

## Blockers
- None in this narrow Sprint 3 recheck.

## Non-blocking issues
- Rojo build warning remains on `project/src/ReplicatedStorage/Remotes.model.json` because of the top-level `Name` field.
- Current Sprint 3 evidence is command-backed/headless proof, not a live human-observed co-op or mobile UI session.
- The phone-size Sprint 3 UI closeout is based on command-backed post-hotfix layout validation rather than a screenshot/clip artifact.
- External analytics dashboard confirmation is still not part of this proof set; acceptance here relies on structured local logs.

## QA recommendation
- Flip the Sprint 3 alpha return-loop gate to **Ready**.
- The prior three blocker gaps are now closed by attached evidence.
- Keep the remaining notes above as non-blocking follow-up / presentation-strengthening items only.
