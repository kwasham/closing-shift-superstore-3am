# Main agent — Sprint 2 sequence

## Goal
Move **Closing Shift: Superstore 3AM** from a proven Sprint 1 internal playable to a cleaner alpha-feeling slice with better onboarding, readability, HUD polish, and presentation cues.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/BACKLOG.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project-template/docs/SPRINT2-PLAN.md` or your copied Sprint 2 plan
- `project/prompts/README_SPRINT2.md`

## Producer rules for this sprint
- Protect the proven Sprint 1 gameplay baseline.
- `main` owns `project/docs/SPRINT.md`.
- Design settles the tutorial / feedback / audio contract before engineering starts implementation.
- Content may run alongside engineering only after design lands and only inside content-owned docs.
- QA must separate **regression verified**, **clarity verified**, and **still unverified**.
- Do not call Sprint 2 ready unless the evidence includes live phone-sized HUD proof and a first-time-player clarity pass.

## Dispatch order
### 1) Send the design worker
Use `project/prompts/DESIGN_SPRINT2_CLARITY_AND_FEEL_SPEC.md`.

Required output before moving on:
- updated `project/docs/GDD.md` if needed
- updated `project/docs/DECISIONS.md`
- updated `project/docs/HANDOFF-ENGINEERING.md`
- locked tutorial / feedback / audio cue rules

### 2) Send the engineer worker
Use `project/prompts/ENGINEER_SPRINT2_CLARITY_AND_FEEL_IMPLEMENTATION.md`.

Pass along:
- the design worker summary
- the final `project/docs/HANDOFF-ENGINEERING.md`
- any new decision entries in `project/docs/DECISIONS.md`

Required output before moving on:
- code changes under `project/src/**`
- updated `project/scripts/smoke_runner.lua` if needed
- commands run and exact results
- runtime evidence or explicit unverified areas

### 3) Send the content worker
Use `project/prompts/CONTENT_SPRINT2_LAYOUT_AUDIO_AND_COPY.md`.

Pass along:
- the design worker summary
- the current `project/docs/GDD.md`
- the current `project/docs/HANDOFF-ENGINEERING.md`

Required output before moving on:
- updated `project/docs/ART-DIRECTION.md`
- updated `project/docs/HANDOFF-CONTENT.md`
- updated `project/docs/STORE-BEATS.md`

### 4) Send the QA worker
Use `project/prompts/QA_SPRINT2_CLARITY_AND_FEEL_GATE.md`.

Pass along:
- engineer changed files summary
- content changed files summary
- commands actually run
- runtime evidence actually captured

Required output before calling the sprint ready:
- updated `project/docs/QA.md`
- updated `project/docs/TEST-PLAN-SMOKE.md`
- updated `project/docs/BACKLOG.md`
- explicit ready / not ready verdict
- clear distinction between logic regression risk and player-readability risk

### 5) Integrate as `main`
After all workers return:
- update `project/docs/SPRINT.md`
- call out what improved versus Sprint 1
- state whether Milestone 2 is ready
- identify the single best next delegation for Sprint 3

## Sprint status update template for `main`
Use this structure when reporting back:
- Goal status:
- Worker results:
- Files changed:
- What is runtime-verified:
- What is still unverified:
- Regression risks:
- Next best action:
