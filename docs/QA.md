# QA

## Sprint 5 soft-launch gate — 2026-04-04
- status: Ready
- scope checked:
  - final narrow Sprint 5 blocker recheck for launch badge asset IDs only
  - confirmation against the focused proof rerun already recorded in `project/docs/RUNTIME-EVIDENCE.md`

### Source truth recheck
- Verified current `project/src/ReplicatedStorage/Shared/Constants.lua` now uses real Roblox badge asset IDs:
  - `first_shift.assetId = 2926838285493434`
  - `shift_cleared.assetId = 1012078972936691`
  - `three_am_regular.assetId = 3195093201982269`
- Confirmed the current source snapshot no longer uses `assetId = 0` for any of the three Sprint 5 launch badges.

### Focused proof evidence
- `bash scripts/check.sh` — Pass
- `bash scripts/build.sh` — Pass
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint5_proof.lua` — Pass
- Verified from the successful rerun output:
  - `S5_PROOF daily_bonus_award base=165 bonus=25 total=190 reset=2026-04-04`
  - `S5_PROOF daily_bonus_skip_same_day base=165 bonus=0 total=165 skip_reason=already_claimed_today`
  - `S5_PROOF launch_badges first_shift=true shift_cleared=true three_am_regular=true awards=9501:first_shift,9501:shift_cleared,9501:three_am_regular`
  - `S5_PROOF share_cta shown=true pressed=true variant=failure invite_supported=true`
  - `S5_PROOF share_cta_fallback shown=true reason=platform_unsupported`
  - `S5_PROOF persistence daily_reset=2026-04-06 badge_count=3 shifts_played=4 shifts_cleared=2 cash=421 xp=100`
  - `S5_PROOF store_sync ok=true cash=421 level=4`
  - `S5_PROOF analytics daily_awarded=true daily_skipped=true badge_awarded=true share_shown=true share_pressed=true share_fallback=true ...`
  - `S5_PROOF_OK`
  - `EXIT_CODE=0`

### Blockers
- None from this narrow Sprint 5 recheck.
- The previously-blocking badge asset-ID issue is cleared by current source truth plus the green focused proof rerun.

### Non-blocking follow-up
- Add a publish-safety check that fails fast if any Sprint 5 badge `assetId` is ever set back to `0`.
- Optional confidence add only: capture one fresh live-client Sprint 5 evidence set for release notes / producer confidence.

### Verdict rationale
- The only locked Sprint 5 blocker in this narrow pass was placeholder launch badge asset IDs.
- Current source truth shows real badge asset IDs for all three launch badges.
- The focused Roblox proof rerun is green and explicitly shows all three badge award paths succeeding.
- Based on this blocker-only recheck, the Sprint 5 gate can now flip to **Ready**.

## Bug report template
- Area:
- Build / commit:
- Setup:
- Steps:
- Expected:
- Actual:
- Severity:
- Notes:
