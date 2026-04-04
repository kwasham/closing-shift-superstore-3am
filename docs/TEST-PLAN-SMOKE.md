# Smoke test plan

This file is the QA team's concrete smoke and focused proof matrix for the current ready baseline plus Sprint 5 soft-launch validation.

## Current status
- Sprint 1–4 baseline: Ready and documented in `project/docs/RUNTIME-EVIDENCE.md`
- Sprint 5 soft-launch gate: Not Ready until the three launch badge `assetId` values stop being `0`

## 1) Structural / build smoke

### A. Repo checks
- Command:
  - `bash scripts/check.sh`
- Required pass condition:
  - output stays:
    - `0 errors`
    - `0 warnings`
    - `0 parse errors`

### B. Build
- Command:
  - `bash scripts/build.sh`
- Required pass condition:
  - build completes and produces `ClosingShift.rbxlx`

### C. Structural Roblox smoke
- Command:
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
- Required pass condition:
  - output includes:
    - `SMOKE_OK: core folders and scripts are present`
    - `SMOKE_OK: fallback arena bootstrap is present`
- Coverage intent:
  - confirms required shared modules, remotes, round/data services, UI scripts, and fallback arena bootstrap are still present after Sprint 5 changes

## 2) Focused Sprint 5 proof

### A. Locked proof command
- Command:
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint5_proof.lua`
- Required pass condition:
  - output ends with `S5_PROOF_OK`

### B. Required proof lines
The proof output must continue to cover all of these:
- Daily bonus awarded path
  - `S5_PROOF daily_bonus_award ...`
- Daily bonus skipped path on the same UTC day
  - `S5_PROOF daily_bonus_skip_same_day ...`
- Launch badge path
  - `S5_PROOF launch_badges ...`
- Share CTA shown + pressed path
  - `S5_PROOF share_cta ...`
- Share CTA fallback path
  - `S5_PROOF share_cta_fallback ...`
- Persistence snapshot
  - `S5_PROOF persistence ...`
- Store/profile sync snapshot
  - `S5_PROOF store_sync ...`
- Analytics/log snapshot
  - `S5_PROOF analytics ...`

### C. What this focused proof is expected to preserve
- `Daily First Shift Bonus` awards `+$25 Saved Cash`
- same-day repeat rounds skip the bonus
- UTC reset keys remain `YYYY-MM-DD`
- launch badges unlock in the locked Sprint 5 criteria family
- share CTA telemetry still records shown / pressed / fallback
- persisted cash/xp/profile sync stay coherent after Sprint 5 awards
- analytics stays on the existing `[analytics] <event_name> <json>` path

## 3) No-regression watchpoints from the Sprint 1–4 ready baseline
- Do not let Sprint 5 rebalance or drift:
  - base payout math
  - timeout multiplier
  - task rewards
  - XP thresholds
  - shop cash sync
  - late-join exclusion rules
- Keep `project/docs/RUNTIME-EVIDENCE.md` as the baseline reference for prior ready coverage
- Treat a new smoke/build/proof failure as a regression until proven otherwise

## 4) Still manual / still unverified after the current proof pass
- Human-observed Sprint 5 results-surface proof for:
  - `Daily First Shift Bonus: +$25 Saved Cash`
  - `Badge unlocked: <BadgeName>`
  - success/failure invite helper copy
  - fallback helper copy
- Supported-platform native invite/share prompt behavior in a real client
- Live badge-award behavior using real Roblox badge asset IDs

## 5) Release blocker rules for this sprint
Fail the Sprint 5 soft-launch gate if any of the following are true:
- any required structural/build smoke command fails
- `scripts/sprint5_proof.lua` stops emitting one of the required proof families above
- `S5_PROOF_OK` is missing
- any Sprint 5 launch badge still has `assetId = 0`

## 6) Recommended follow-up after the blocker is cleared
- Capture one honest client-visible Sprint 5 results evidence set
- Review post-launch telemetry for:
  - daily bonus claim rate
  - launch badge award failures
  - share CTA fallback rate
