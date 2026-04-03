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
- Sprint 2 planning
- Milestone 2 polish-pass scoping
- follow-up cleanup for non-blocking warnings like the Rojo `Remotes.model.json` warning

### In progress
- no Sprint 1 blockers

### Done
- OpenClaw multi-agent pipeline scaffolded
- Rojo/Rokit project scaffolded
- starter round loop and HUD placeholders committed
- design handoff completed with locked task quotas, task values, blackout/mimic behavior, payout math, and solo-fair anti-frustration rules
- engineering implementation landed for the Sprint 1 round loop, quota tracking, gated `Close Register`, blackout/mimic events, banked payout flow, generated MVP task nodes, HUD updates, and smoke script coverage
- content handoff completed for art direction, store beats, onboarding/signage/task copy, and blackout/mimic messaging
- `bash scripts/check.sh` passed
- `bash scripts/build.sh` passed
- smoke harness hotfix landed and `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` now passes with required smoke output
- headless Roblox-engine runtime proof now covers solo success/failure, register gating, blackout behavior, mimic expire/trigger behavior, exact `-8s` timer loss, personal-only `-$12` mimic penalty in co-op, and leave-before-payout behavior
- Sev 2 phone HUD clipping issue found during runtime validation, hotfixed in `project/src/StarterGui/HUD.client.lua`, and rerun evidence recorded
- late-join HUD wait-state hotfix landed and narrow proof confirmed excluded mid-round joiners cannot participate, cannot add banked pay, and receive `Shift in progress. Wait for the next one.`
- QA cleared the final blocker and Sprint 1 is now **Ready**

## Risks
- task node contracts can drift if task ids / prompts are not documented in one place
- Studio-only map changes may diverge from Rojo-managed task markers
- workers may collide if they all edit `SPRINT.md`; keep ownership with `main`
- non-blocking cleanup remains for tooling / presentation follow-ups, but no Sprint 1 gate blocker remains

## Next producer action
Record the final Sprint 1 proof summary in `project/docs/DECISIONS.md`, keep any minor follow-ups in backlog, and start Sprint 2 / Milestone 2 planning from a Ready baseline.
