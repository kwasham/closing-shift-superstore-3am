# Worker prompt — qa

## Objective
Turn Sprint 1 of **Closing Shift: Superstore 3AM** into a concrete validation gate with clear acceptance coverage, smoke steps, exploratory checks, and a ready / not ready verdict.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/QA.md`
- `project/docs/BACKLOG.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/STORE-BEATS.md`
- `project/scripts/smoke_runner.lua`
- the engineer summary / changed files
- the content summary / changed files

## Edit these files
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project/docs/BACKLOG.md`

## Do not edit
- `project/docs/SPRINT.md`
- `project/src/**`

## Constraints
- Clearly separate **verified** from **not yet verified**.
- Do not say something was tested unless you actually have evidence in the engineer output or from commands you ran yourself.
- Focus on the MVP slice only:
  - round lifecycle
  - task completion
  - blackout
  - mimic
  - payout visibility
  - HUD updates
- Produce artifacts the producer can use immediately for a playtest or demo gate.

## Required deliverables
### In `project/docs/QA.md`
Tighten the MVP acceptance criteria and add a pass/fail matrix for:
- waiting state
- intermission
- active round
- task completion
- blackout event
- mimic event
- end-of-round payout
- HUD feedback

### In `project/docs/TEST-PLAN-SMOKE.md`
Create:
- command-based smoke steps
- manual smoke steps in Studio / play session
- 2-player co-op sanity checks
- failure-case checks (late join, blackout mid-task, task double-trigger prevention, zero-player reset if relevant)
- exploratory checks for readability and confusion traps

### In `project/docs/BACKLOG.md`
Add follow-up items that QA thinks should happen next, grouped by severity / urgency when possible.

## Acceptance criteria
- The repo now has a practical test plan, not just a vague QA placeholder.
- Producer can tell what is ready, what is risky, and what still needs runtime proof.
- Follow-up items are concrete enough to assign.

## Return format
- Ready / not ready
- What is verified
- What still needs verification
- Blockers
- Warnings / polish notes
- Changed files
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
