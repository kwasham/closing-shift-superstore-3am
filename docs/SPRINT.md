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
- Sprint 4 / Milestone 4 planning
- follow-up cleanup for non-blocking warnings like the Rojo `Remotes.model.json` warning
- broader analytics/dashboard follow-up beyond the accepted local structured-log proof

### In progress
- no Sprint 3 blockers

### Done
- OpenClaw multi-agent pipeline scaffolded
- Rojo/Rokit project scaffolded
- starter round loop and HUD placeholders committed
- Sprint 1 is **Ready**
- Sprint 2 is **Ready**
- Sprint 3 design handoff completed for `Security Alarm`, persistent XP/Level profile schema, a 2-slot / 6-item cosmetic shop with persistent purchase+equip state, and the exact Sprint 3 analytics event contract
- Sprint 3 engineering pass completed for Security Alarm, persistent profile expansion, shop purchase/equip flow, minimal Sprint 3 lobby/results UI, analytics/log plumbing, and Sprint 3 smoke/runtime harness updates
- Sprint 3 content pass completed for Security Alarm presentation, progression/shop copy, and the locked 6-item catalog with QA-visible 2D presentation notes
- Sprint 3 QA gate is **Ready** after structural/build proof, Security Alarm runtime proof, persistence/shop proof, and Sprint 3 analytics/log proof closed the remaining evidence gaps

## Risks
- workers may collide if they all edit `SPRINT.md`; keep ownership with `main`
- non-blocking build warning remains on `Remotes.model.json`
- structured local analytics proof is accepted for Sprint 3, but broader dashboard/production telemetry validation is still a future follow-up

## Next producer action
Start Sprint 4 / Milestone 4 planning from a Ready Sprint 3 baseline.
