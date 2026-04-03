# QA

## Sprint 1 MVP gate verdict
- **Status:** **Ready**
- **Why:** the previous final blocker was the missing post-hotfix late-join wait-state proof. The newest command-backed rerun now provides that narrow evidence: `LATE_JOIN_PROOF can_participate=false`, `LATE_JOIN_PROOF late_join_alert=Shift in progress. Wait for the next one.`, and `LATE_JOIN_PROOF_OK` are recorded in `project/docs/RUNTIME-EVIDENCE.md`.
- **What changed:** this is no longer just code-path reasoning. The latest rerun proves the excluded late joiner stays out of active-round participation and receives the correct wait-for-next-shift messaging after the HUD hotfix.

## Evidence basis

### Verified command/build evidence
- `bash scripts/check.sh` — **Pass**
- `bash scripts/build.sh` — **Pass**
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` — **Pass**

### Verified runtime evidence from `project/docs/RUNTIME-EVIDENCE.md`
The following remain sufficiently proven for this narrow recheck.

#### Proven
- **Core Sprint 1 gameplay matrix**
  - Solo success/failure payout math
  - `Close Register` gating / unlock behavior
  - blackout timing and mid-hold behavior
  - mimic expire/trigger behavior
  - exact shared `-8s` timer hit
  - personal-only `-$12` mimic penalty in co-op
  - leave-before-payout award behavior
- **Late-join server-side exclusion rule**
  - Active-round roster snapshot already existed server-side
  - Late joiners were already blocked from active-round task credit/payout server-side
- **Late-join client hotfix intent / code path**
  - `HUD.client.lua` now tracks `payload.activeUserIds`
  - excluded joiners in `Playing` / `Ended` should initialize into a stable wait-for-next-shift HUD state
  - active-round alert spam is suppressed for excluded joiners so the wait message remains pinned and readable

#### No longer blocking
- **Late-join post-hotfix proof**
  - We now have a command-backed rerun after the HUD fix
  - The rerun confirms the excluded joiner cannot participate and receives the correct wait-state alert text

## Verified vs unverified distinction
- **Verified enough:** the command/build/smoke evidence, the headless Roblox-engine gameplay matrix, and the new late-join proof together clear the Sprint 1 gate.
- **Still optional:** a human-observed screenshot or clip of the late-join HUD would improve presentation strength, but it is no longer a release blocker.

## Remaining blocker
- None.

## Shortest exact next action
- Optional polish only: capture a human-observed late-join screenshot/clip for presentation/demo evidence if the team wants a stronger player-facing artifact.

## Pass / fail snapshot
| Area | Status | Notes |
| --- | --- | --- |
| Checks/build/smoke | VERIFIED | Pass |
| Solo success/failure gameplay rules | VERIFIED | Engine-backed runtime proof |
| Blackout behavior | VERIFIED | Engine-backed runtime proof |
| Mimic expire/trigger behavior | VERIFIED | Engine-backed runtime proof |
| Exact `-8s` timer hit | VERIFIED | Engine-backed runtime proof |
| Personal-only mimic penalty in co-op | VERIFIED | Engine-backed runtime proof |
| Leave-before-payout award path | VERIFIED | Engine-backed runtime proof |
| Late-join server exclusion | VERIFIED | Engine-backed runtime proof |
| Late-join HUD wait-state code-path fix | VERIFIED IN CODE | Root cause + narrow fix documented |
| Real late-join HUD/state rerun after fix | VERIFIED | Command-backed proof captured with correct wait alert and exclusion behavior |

## Final verdict
- **Ready**
- **Reason:** the last narrow blocker is cleared by the newest late-join proof. We now have direct post-hotfix evidence that a late joiner is excluded from participation and gets the correct `Shift in progress. Wait for the next one.` wait-state messaging.
