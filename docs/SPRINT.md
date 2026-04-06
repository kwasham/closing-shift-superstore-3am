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
- **Sprint 7 is complete.**
- **Implementation is in.**
- **QA status is Ready.**
- The Sprint 7 full-store art gate is cleared.

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
- **Ready**

### What QA accepted
- build / structure sanity
- rollout/runtime support
- 1-player / 2-player sanity coverage used for the Sprint 7 implementation pass
- recovered Tier A before / after pack
- continuity proof
- honest public asset pack + crop review
- widened-store readability pack including round-end and phone-sized proof

### Cleared notes
- The earlier evidence blocker is resolved.
- Known Studio host/plugin instability and some viewport chrome did not invalidate the final attached proof.

## What landed in the final proof pass
- distinct Tier A `after` frames for lobby / entrance, main aisle, checkout / queue, freezer / cooler path, and stockroom corner
- continuity proof showing widened front-store adjacency
- distinct public asset exports for icon, `Store at 3AM`, `Blackout`, `Mimic tension`, plus update/social framing
- crop-review exports for that asset set
- widened-store round-end summary readability capture
- phone-sized widened-store active-shift readability capture
- additional widened-store normal-shift live checkout proof

## In progress now
- no blocking Sprint 7 work

## Explicitly not the next step
- no emergency rework on Sprint 7 scope
- no new implementation tied to the cleared art gate

## Risks / operating notes
- Roblox Studio capture work still needs to stay **serial** on this host; overlapping interactive capture attempts can hang/fail.
- External-device spot-checks and cleaner marketing captures remain optional follow-up, not Sprint 7 blockers.
- `project/docs/SPRINT.md` should stay aligned with the cleared Sprint 7 state.

## Definition of done for this sprint
Sprint 7 is done when:
- the proof pack in `project/docs/proof/sprint7/` honestly covers the named zones and public surfaces
- readability evidence is attached for active shift, blackout, mimic, round-end, and phone-sized review where required
- QA clears Sprint 7 to **Ready**
- docs reflect the real result and next action

## Next producer action
Close out Sprint 7 documentation cleanly and treat any remaining device spot-checks or cleaner marketing recaptures as optional follow-up, not blockers.
