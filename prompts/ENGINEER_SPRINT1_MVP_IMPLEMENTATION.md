# Worker prompt — engineer

## Objective
Implement the first playable MVP slice for **Closing Shift: Superstore 3AM** so a fresh server can run the closing-shift loop, expose six tasks, fire blackout + mimic, and show payout on the HUD.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/QA.md`
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ReplicatedStorage/Shared/Types.lua`
- `project/src/ServerScriptService/Round/Config.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`
- `project/src/ServerScriptService/Data/ProfileStore.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- `project/scripts/smoke_runner.lua`

## Primary files to edit
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ReplicatedStorage/Shared/Types.lua`
- `project/src/ServerScriptService/Round/Config.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`
- `project/src/ServerScriptService/Data/ProfileStore.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- `project/scripts/smoke_runner.lua`

## Allowed new files if useful
- `project/src/ServerScriptService/Round/TaskService.lua`
- `project/src/ServerScriptService/Round/EventService.lua`
- `project/src/ServerScriptService/Round/TaskRegistry.lua`
- `project/src/Workspace/TaskNodes.model.json`
- small helper modules under `project/src/ReplicatedStorage/Shared/`

## Do not edit unless required by an actual architecture decision
- `project/docs/GDD.md`
- `project/docs/SPRINT.md`

If you make an architectural choice that should be preserved, append a concise note to `project/docs/DECISIONS.md`.

## Constraints
- Keep rewards, progression state, and round authority on the server.
- Stay inside Sprint 1 scope; do not add revive, shop, persistence, or roaming enemy systems.
- Prefer a clean, readable decomposition over a single giant service.
- The build should not depend on hand-placed Studio-only objects for the **task markers**; use a Rojo-managed model/json file for MVP task nodes if possible.
- HUD must show:
  - current state
  - timer
  - objective progress
  - alert text
  - cash amount
- If you add remotes, name them descriptively and keep the contract obvious.
- If runtime verification is not possible, say so clearly instead of bluffing.

## Required implementation outcome
- Waiting / intermission / playing / ended lifecycle works.
- Six task nodes can be activated and completed.
- Progress updates to clients.
- Blackout temporarily disrupts task interaction and then recovers.
- Mimic marks at least one task as dangerous and applies the intended penalty.
- Completing tasks and/or winning the round results in visible cash increase.
- Smoke runner validates the required structure for the MVP slice.

## Validation steps to run
Run what you can and report exact results:
```bash
cd project
stylua src scripts
selene src scripts
```
If you can also validate the place build / smoke path, do so and report the exact command + output.

## Acceptance criteria
- Another engineer can read the repo and understand the round/task/event responsibilities.
- The HUD and server logic reflect the design handoff accurately.
- Commands run and results are documented.
- Any runtime-unverified area is called out explicitly.

## Return format
- Summary of implementation
- Changed files
- Commands run and their results
- Manual validation notes or unverified areas
- Remaining risks / follow-ups for QA or production
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
