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
- Sprint 5 / post-launch planning
- follow-up cleanup for remaining non-blocking release-surface/doc contradictions
- broader release operations follow-up outside the Sprint 4 gate

### In progress
- no Sprint 4 blockers

### Done
- OpenClaw multi-agent pipeline scaffolded
- Rojo/Rokit project scaffolded
- starter round loop and HUD placeholders committed
- Sprint 1 is **Ready**
- Sprint 2 is **Ready**
- Sprint 3 is **Ready**
- Sprint 4 design handoff completed for launch-facing wording cleanup, first-10-minute friction rules, truthful publish-surface contract, launch watchlist hardening, and low-risk `Remotes.model.json` cleanup boundaries
- Sprint 4 engineering pass completed for `Shift Cash` / `Saved Cash` wording rollout, late-join support copy clarification, phone-width HUD/results hardening, safe `Remotes.model.json` warning cleanup, and smoke coverage update for launch-facing UI surfaces
- Sprint 4 content pass completed for release-facing art/content guidance, launch-surface wording alignment, store-page brief, and release notes for the current build
- Sprint 4 runtime/client evidence pass appended to `project/docs/RUNTIME-EVIDENCE.md` and fixed the missing `ProfileChanged` / `ShopAction` remotes for `Sprint3UI`
- Sprint 4 final client-visible screenshot evidence was accepted by QA and Sprint 4 is now **Ready**

## Risks
- workers may collide if they all edit `SPRINT.md`; keep ownership with `main`
- a release-surface contradiction remains in `project/docs/GDD.md` (`upgrades and cosmetics`) versus the locked cosmetics/progression-only release framing
- non-blocking release polish and operations follow-up remain, but no Sprint 4 gate blocker remains

## Next producer action
Start Sprint 5 / post-launch planning from a Ready Sprint 4 baseline and keep the remaining wording/doc contradiction as non-blocking follow-up work.
