# Sprint

## Sprint 1 — First playable MVP slice

## Sprint goal
Ship a cold-server playable internal build where a player can enter intermission, start a closing shift, complete supermarket tasks, experience blackout + mimic events, receive payout, and see the result in the HUD.

## Scope locked for this sprint
- waiting → intermission → playing → ended round lifecycle
- 6 MVP task types with readable interaction text
- task progress and objective counting
- blackout event
- mimic / false-task event
- payout into `Cash` leaderstat
- HUD showing state, timer, objectives, cash, and alerts
- smoke-path validation for core folders/scripts

## Explicitly out of scope
- persistence / DataStore save
- revive loop
- roaming manager NPC
- cosmetic shop UI
- stamina system
- extra maps or store types
- seasonal / live-ops content

## File-ownership rule for this sprint
To reduce merge conflicts:
- `main` owns `project/docs/SPRINT.md`
- `design` owns `project/docs/HANDOFF-ENGINEERING.md` and design-level decisions
- `engineer` owns `project/src/**` and `project/scripts/smoke_runner.lua`
- `content` owns `project/docs/ART-DIRECTION.md`, `project/docs/HANDOFF-CONTENT.md`, and `project/docs/STORE-BEATS.md`
- `qa` owns `project/docs/QA.md` and QA follow-ups in `project/docs/BACKLOG.md`

## Suggested execution order
1. `design` finalizes task/event/payout spec.
2. `engineer` implements the round/task/event/HUD slice.
3. `content` defines the first store beats and player-facing copy.
4. `qa` hardens acceptance criteria and smoke/manual test coverage.
5. `main` integrates status and decides whether Milestone 1 is on track.

## Acceptance criteria for sprint completion
- A fresh server can reach the intermission state with one player present.
- A round can start and expose six readable objectives.
- At least one task can be completed and progress updates correctly.
- Blackout can fire and recover without soft-locking the round.
- Mimic can mark a task as dangerous and apply its consequence.
- End-of-round payout reaches the player-visible cash display.
- Smoke runner validates the required files/modules/instances for the MVP slice.
- Docs reflect what was actually built and what still needs follow-up.

## Current status
### Ready for delegation
- engineer implementation pass using `project/prompts/ENGINEER_SPRINT5_SOFT_LAUNCH_IMPLEMENTATION.md` after design lands
- content pass using `project/prompts/CONTENT_SPRINT5_COPY_BADGES_AND_SHARE.md` after design lands
- follow-up cleanup for remaining non-blocking release-surface/doc contradictions

### In progress
- Sprint 5 is active as **Soft Launch Retention and Distribution**
- awaiting Sprint 5 design handoff from `project/prompts/DESIGN_SPRINT5_SOFT_LAUNCH_SPEC.md`

### Done
- OpenClaw multi-agent pipeline scaffolded
- Rojo/Rokit project scaffolded
- starter round loop and HUD placeholders committed
- Sprint 1 is **Ready**
- Sprint 2 is **Ready**
- Sprint 3 is **Ready**
- Sprint 4 is **Ready**

## Risks
- Sprint 5 must stay scoped to soft launch retention/distribution and not expand into large new systems
- workers may collide if they all edit `SPRINT.md`; keep ownership with `main`
- the release-surface wording contradiction in `project/docs/GDD.md` remains a non-blocking follow-up unless the Sprint 5 design chooses to resolve it directly

## Next producer action
Complete Sprint 5 design step 1, then dispatch engineering and content from the locked Sprint 5 design contract.
