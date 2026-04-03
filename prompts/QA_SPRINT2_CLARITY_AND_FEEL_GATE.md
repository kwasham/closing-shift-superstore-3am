# Worker prompt — qa

## Objective
Turn Sprint 2 of **Closing Shift: Superstore 3AM** into a concrete clarity-and-feel gate while also protecting the proven Sprint 1 gameplay baseline.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/QA.md`
- `project/docs/BACKLOG.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/STORE-BEATS.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
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
- Clearly separate **regression verified**, **clarity verified**, and **not yet verified**.
- Do not say something was tested unless you have evidence.
- Cover both:
  - Sprint 1 no-regression checks
  - Sprint 2 clarity / feel improvements
- Phone-sized HUD proof is required for readiness.
- A first-time-player or no-coaching pass matters more than a purely structural pass.

## Required deliverables
### In `project/docs/QA.md`
Tighten the gate with a pass / fail matrix for:
- round lifecycle regression
- task completion regression
- blackout regression + presentation cue
- mimic regression + presentation cue
- tutorial / onboarding clarity
- final-task unlock readability
- end-of-round summary clarity
- late-join clarity
- phone HUD readability
- audio-cue presence / behavior

### In `project/docs/TEST-PLAN-SMOKE.md`
Create:
- command-based smoke steps
- live 1-player clarity pass
- live 2-player co-op sanity pass
- phone-sized HUD pass
- first-time-player / no-verbal-coaching checks
- regression checks for payout, blackout, mimic, and late join

### In `project/docs/BACKLOG.md`
Add follow-up items grouped by:
- severity
- readiness blocker
- polish later

## Acceptance criteria
- The repo has a real Milestone 2 gate, not a vague polish wish list.
- Producer can tell whether the experience is clearer to a brand-new player.
- Ready / not-ready depends on evidence, not optimism.

## Return format
- Ready / not ready
- What is regression-verified
- What is clarity-verified
- What still needs verification
- Blockers
- Warnings / polish notes
- Changed files
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
