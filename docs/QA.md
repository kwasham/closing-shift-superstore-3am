# QA

## Sprint 2 clarity-and-feel gate verdict
- **Status:** **Ready**
- **Why:** Sprint 1 gameplay regression coverage remains strong, the narrow Sprint 2 clarity-validation evidence closes the phone-sized HUD and blackout/mimic co-op-presentation gaps, and the newly added human-observed **first-time-player / no-verbal-coaching pass** clears the final readiness blocker.
- **What this means:** Milestone 2 now has the required fresh-player evidence to ship this sprint gate. The remaining issue is narrower copy/readout confusion around money / `Banked` / payout explanation, but the observed player still understood the goal, tasks, and events and completed the basic loop without coaching.

## Evidence basis

### Re-run completed in this QA pass
- `cd project && bash scripts/check.sh` — **Pass**
- `cd project && bash scripts/build.sh` — **Pass**
- `cd project && run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` — **Pass**
  - `SMOKE_OK: core folders and scripts are present`
  - `SMOKE_OK: sprint 1 round loop structure is present`
- Non-blocking warning still present during build:
  - Rojo warning on `Remotes.model.json` top-level `Name`

### Previously captured runtime evidence still valid
From `project/docs/RUNTIME-EVIDENCE.md`, Sprint 1 already has headless Roblox-engine proof for:
- solo success payout math
- solo failure payout math
- `Close Register` gating and unlock behavior
- blackout timing, duration, and mid-hold behavior
- mimic expire path
- mimic trigger path
- exact shared `-8s` timer hit
- personal-only `-$12` mimic penalty in co-op
- leave-before-payout handling
- late-join exclusion behavior
- command-backed late-join proof with:
  - `LATE_JOIN_PROOF late_join_alert=Shift in progress. Wait for the next one.`
  - `LATE_JOIN_PROOF can_participate=false`
  - `LATE_JOIN_PROOF_OK`

### Sprint 2 implementation inspected in this QA pass
The following implementation is present in code and covered by build/smoke shape checks:
- `project/src/ReplicatedStorage/Shared/UIStrings.lua`
  - locked Sprint 2 tutorial copy
  - locked alert copy
  - alert priorities
- `project/src/StarterGui/HUD.client.lua`
  - compact top-left HUD with width clamp `260–360`
  - one alert slot
  - session-only tutorial flow
  - objective lines with register `locked/ready/closed`
  - late-join wait state derived from `activeUserIds`
  - compact round-end summary using player-local numbers
- `project/src/ServerScriptService/Round/ShiftService.lua`
  - structured `AlertRaised` payloads
  - round snapshots include `activeUserIds` and `roundResult`
- `project/src/ServerScriptService/Round/TaskService.lua`
  - server-authored `FeedbackState` attributes
  - locked/register-ready/blackout/mimic-lockout prompt states
- `project/src/StarterPlayer/StarterPlayerScripts/ClientEffects.client.lua`
  - node highlight states
  - blackout overlay
  - mimic/register/result flashes
- `project/src/StarterPlayer/StarterPlayerScripts/Audio.client.lua`
  - cue hooks with silent/fallback behavior when assets are missing

## Regression verified
These items are sufficiently verified and should be treated as still intact unless a later live run contradicts them.

- **Round lifecycle baseline is intact**
  - waiting → intermission → playing → ended remains the flow
  - intermission remains `15s`
  - round timer remains `540s`
- **Quota / register rules remain intact**
  - Sprint 1 quota bundles are unchanged
  - `Close Register` still unlocks only after all non-register tasks complete
- **Payout rules remain intact**
  - success = full banked pay + `$35`
  - failure = `floor(60% of banked pay)`
  - mimic penalty remains personal-only and clamped at `$0` minimum payout
- **Blackout rules remain intact**
  - once per round
  - `10s` duration
  - can finish an already-started hold
  - cannot begin a new interaction during blackout
- **Mimic rules remain intact**
  - once per round max
  - same timing window
  - same `-8s` team timer hit
  - same `-$12` personal penalty
  - same `8s` node lockout
- **Late-join roster rule remains intact**
  - active roster still snapshots at round start
  - excluded joiners cannot participate in the current round
  - excluded joiners do not earn current-round payout

## Clarity verified
These items now have enough narrow validation evidence to stay closed unless a later live player run contradicts them.

- **Locked tutorial copy is present** and mapped to the four intended steps.
- **HUD hierarchy is present** with the intended order: state, timer, saved cash, earnings, objectives, alert.
- **One-slot alert behavior is present** instead of a scrolling alert feed.
- **Late-join wait state is implemented** from replicated roster snapshots, not only from a one-shot alert.
- **Objectives formatting is compact** and keeps register state visible as `locked`, `ready`, or `closed`.
- **Round-end summary is compact** and uses player-local payout numbers.
- **Task feedback states are server-authored** and exposed for client presentation.
- **Client effects are wired** for blackout, mimic trigger, register unlock, local hold focus, and completion flashes.
- **Audio hooks are wired** with safe silent/fallback behavior when cue assets are absent.
- **Phone-sized HUD readability has runtime-backed proof** at `260px` panel width / `236px` inner width: active stack height `221px`, round-end stack height `209px`, no clipping/overlap because the HUD auto-sizes vertically, with only two tutorial lines wrapping to two lines at the minimum width target.
- **Blackout and mimic presentation have runtime-backed 2-player sanity proof**: blackout cue/alert remained distinct and understandable, blackout duration stayed `10.0s`, held-task finish remained allowed while fresh-task start stayed blocked, blackout recovery read clearly, mimic cue/alert remained distinct, mimic lockout presentation stayed clear, the shared timer still hit exactly `-8s`, and only the triggering player took the `-$12` penalty.

## What still needs verification
These items do not block Sprint 2 readiness based on the current evidence, but they still merit follow-up.

### Readiness blockers
- None from this Sprint 2 gate recheck.

### Still unverified or worth tightening after the gate
- real cue behavior with placeholder or final sound assets
- whether the highlighted task presentation is strong enough in the actual built store layout rather than only in code
- whether money / `Banked` / payout wording should be tightened now that the first no-coaching human observation showed repeated hesitation there

## Pass / fail matrix
| Area | Status | Evidence | Notes |
| --- | --- | --- | --- |
| Round lifecycle regression | **VERIFIED** | Headless runtime evidence + current build/smoke rerun | No Sprint 2 rule drift seen |
| Task completion / payout regression | **VERIFIED** | Headless runtime evidence | Sprint 1 reward math and register gate remain intact |
| Blackout regression | **VERIFIED** | Headless runtime evidence | Timing, duration, and mid-hold behavior already proven |
| Blackout presentation cue | **VERIFIED** | Runtime-backed co-op presentation proxy + code inspection | Alert/cue distinction, blocked-new-task behavior, held-task finish, recovery read, and `10.0s` duration all passed |
| Mimic regression | **VERIFIED** | Headless runtime evidence | Exact `-8s`, `-$12`, and lockout remain proven |
| Mimic presentation cue | **VERIFIED** | Runtime-backed co-op presentation proxy + code inspection | Trigger alert/cue distinction, lockout presentation, shared `-8s`, and personal-only `-$12` all passed |
| Tutorial / onboarding clarity | **VERIFIED FOR READINESS** | Code inspection + human-observed no-coaching pass | Fresh-player evidence now exists: player understood the goal, tasks, and events and completed the basic loop without verbal coaching; payout wording still showed hesitation but did not block loop completion |
| Final-task unlock readability | **VERIFIED** | Existing register unlock runtime proof + current narrow clarity validation | Register-ready state stays visible in the HUD/objective stack and remains wired through alert/state/effects |
| End-of-round summary clarity | **VERIFIED** | Runtime-backed phone-width HUD pass | Summary lines fit the `236px` inner width and the panel auto-sizes vertically |
| Late-join clarity | **VERIFIED, NOT HUMAN-CAPTURED** | Command-backed late-join proof + code inspection | Wait-state messaging is proven by command output, but still lacks a live screenshot/clip |
| Phone HUD readability | **VERIFIED** | Runtime-backed phone-width HUD pass | At `260px` panel width / `236px` inner width the HUD stack stayed readable with no clipping/overlap |
| Audio-cue presence / behavior | **IMPLEMENTED / NOT LIVE-VERIFIED** | Code inspection | Safe fallback exists; actual cue behavior still needs a live sanity check |

## Blockers
- None.

## Warnings / polish notes
- `Remotes.model.json` still emits a Rojo warning during build. Not a gate blocker, but worth cleaning.
- Audio fallback is intentionally silent when assets are missing. That is safe for gameplay, but it can hide missing content unless QA explicitly checks cue presence.
- The new no-coaching human observation cleared the sprint gate, but it also exposed a real copy/readout weakness: `Banked` and round-end payout language were still unclear without explanation.

## Short producer note
Sprint 2 is **ready**. Regression risk is low, the phone-sized HUD gap is closed, blackout/mimic co-op presentation has runtime-backed sanity evidence, and the final no-coaching first-time-player blocker is now closed by human-observed pass notes. The remaining follow-up is polish-level clarity around `Banked` / money / payout wording, not a ship blocker for this gate.
