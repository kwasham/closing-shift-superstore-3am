# Worker prompt — engineer

## Objective
Implement Sprint 2 for **Closing Shift: Superstore 3AM** as a clarity-and-feel pass: onboarding, task readability, HUD polish, end-of-round summary, and blackout / mimic presentation cues, without regressing Sprint 1 gameplay logic.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ReplicatedStorage/Shared/Types.lua`
- `project/src/ServerScriptService/Round/Config.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- `project/scripts/smoke_runner.lua`

## Primary files to edit
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ReplicatedStorage/Shared/Types.lua`
- `project/scripts/smoke_runner.lua`

## Allowed new files if useful
- `project/src/ReplicatedStorage/Shared/UIStrings.lua`
- `project/src/ReplicatedStorage/Shared/FeedbackConfig.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/Tutorial.client.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/Audio.client.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/ClientEffects.client.lua`
- `project/src/ServerScriptService/Round/PresentationService.lua`
- small helper modules under `project/src/ReplicatedStorage/Shared/`
- Rojo-managed sound / config files under `project/src/SoundService/`

## Do not edit unless required by an actual architecture decision
- `project/docs/GDD.md`
- `project/docs/SPRINT.md`

If you make an architectural choice that should be preserved, append a concise note to `project/docs/DECISIONS.md`.

## Constraints
- Server remains authoritative for round state, payout, event consequences, and lock / unlock logic.
- Keep Sprint 2 in polish scope. Do not add:
  - new event types
  - persistence
  - shop systems
  - progression systems
  - revive or NPC enemy systems
- Preserve the proven Sprint 1 gameplay consequences unless the design handoff explicitly calls for a tiny clarity-motivated change.
- Phone HUD readability is non-negotiable.
- If audio assets are not ready, support placeholder cues and document the gap clearly.
- If runtime verification is not possible, say so clearly instead of bluffing.

## Required implementation outcome
- First-session tutorial / onboarding exists and teaches the objective quickly.
- HUD / alert presentation is clearer on phone-sized screens.
- Active tasks are more readable.
- `Close Register` lock / unlock is clearly communicated.
- Blackout and mimic both have distinct presentation hooks or cues.
- End-of-round success / failure clearly explains payout.
- Late-join state remains correct and readable.
- Structural smoke still passes and Sprint 1 logic does not regress.

## Validation steps to run
Run what you can and report exact results:
```bash
cd project
stylua src scripts
selene src scripts
bash scripts/check.sh
bash scripts/build.sh
```
If the smoke path still works, run it and capture exact output.
If you can do a live Studio or local-server pass, report exact setup and evidence.

## Acceptance criteria
- Another engineer can read the repo and understand what is presentation-only versus server-authoritative.
- Sprint 1 logic is preserved.
- Commands run and results are documented.
- Any runtime-unverified area is called out explicitly.

## Return format
- Summary of implementation
- Changed files
- Commands run and their results
- Runtime validation notes or unverified areas
- Remaining risks / follow-ups for QA or production
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
