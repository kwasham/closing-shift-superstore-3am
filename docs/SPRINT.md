# Sprint

## Sprint 7 — Full-store art rollout + store presence

## Sprint goal
Ship the widened store art/readability/public-surface proof pack for **Closing Shift: Superstore 3AM** without expanding gameplay scope.

## Scope locked for this sprint
In scope:
- full-store visual rollout across remaining player-visible spaces
- signage / wayfinding pass
- performance-budget guardrails
- store-presence assets: icon, thumbnails, update/social shots
- live proof / capture needed to clear Sprint 7 QA

Out of scope:
- new gameplay systems
- new events or event mechanics
- economy changes
- progression creep
- map expansion beyond the already playable / visible store
- speculative implementation unrelated to the proof blocker

## Current truth
- **Sprint 7 is active.**
- **Implementation is in.**
- **QA status is Not Ready.**
- The remaining blocker is **narrow proof / recapture work**, not broad engineering scope.

## File-ownership rule for this sprint
To reduce merge conflicts:
- `main` owns `project/docs/SPRINT.md`
- `design` owns design-level decisions and handoff direction
- `engineer` owns runtime/source implementation already landed for Sprint 7
- `content` owns capture/public-surface framing inputs and shot-pack support docs
- `qa` owns `project/docs/QA.md` and QA follow-ups in `project/docs/BACKLOG.md`

## What is already done
### Design lock
- Sprint 7 visual direction, rollout tiers, performance guardrails, and honest store-presence direction are locked in docs.

### Content / support work landed
- Sprint 7 content pack and shot-log planning exist.
- `project/docs/proof/sprint7/` is the active proof folder.

### Engineering implementation landed
- Full-store rollout/runtime support is in.
- Command-backed verification was previously established as green for:
  - `bash scripts/check.sh`
  - `bash scripts/build.sh`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint7_art_rollout_probe.lua`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/round_bootstrap_proof.lua`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint7_two_player_sanity.lua`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint6_visual_probe.lua`

## Current QA state
### Verdict
- **Not Ready**

### What QA has already accepted as established
- build / structure sanity
- rollout/runtime support
- 1-player / 2-player sanity coverage used for the Sprint 7 implementation pass

### True blocker
QA is still blocked on the **honesty and uniqueness of the Sprint 7 proof pack**.
This is now a capture-quality problem, not a broad implementation problem.

## Remaining blocker to clear Sprint 7
The recapture pass still needs a proof pack that honestly covers the widened store.

### Required recapture / proof items
- one distinct post-pass `after` frame each for:
  - lobby / entrance
  - main aisle coverage
  - checkout / queue
  - freezer / cooler path
  - stockroom corner
- one true continuity frame showing adjacent zones reading as one store
- one distinct live-build public asset set for:
  - icon
  - `Store at 3AM` thumbnail
  - `Blackout` thumbnail
  - `Mimic tension` thumbnail
  - update / social shot
- matching crop-review exports for that distinct public asset set
- one widened-store round-end summary readability capture
- one phone-sized widened-store active-shift readability capture
- at least one additional live normal-shift widened-store zone frame beyond the current aisle proof

## In progress now
- narrow Sprint 7 recapture pass only
- replacing weak or reused proof angles with distinct zone-honest framing
- collecting the remaining readability evidence QA asked for

## Explicitly not the next step
- no new feature work
- no scope expansion
- no blind implementation pass
- no reopening Sprint 7 design lock unless QA finds a real honesty blocker in the live build

## Risks / operating notes
- Roblox Studio capture work must stay **serial**; overlapping interactive capture attempts can hang/fail on this host.
- Capture success depends on honest live-build framing; repeated crops of the same front-store view will fail QA even if files exist.
- `project/docs/SPRINT.md` was previously stale; `main` should keep this file aligned with the active Sprint 7 proof/QA state.

## Definition of done for this sprint
Sprint 7 is done when:
- the recaptured proof pack in `project/docs/proof/sprint7/` honestly covers the named zones and public surfaces
- readability evidence is attached for active shift, blackout, mimic, round-end, and phone-sized review where required
- QA reruns on evidence only and flips Sprint 7 to **Ready**
- docs reflect the real result and next action

## Next producer action
Finish the narrow Sprint 7 recapture/proof pass, update the evidence files, and rerun QA on the recaptured evidence only.
