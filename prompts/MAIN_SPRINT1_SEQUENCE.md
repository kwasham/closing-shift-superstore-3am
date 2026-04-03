# Main agent — Sprint 1 sequence

## Goal
Get **Closing Shift: Superstore 3AM** from scaffold to a first playable internal MVP slice.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/BACKLOG.md`
- `project/prompts/README.md`

## Producer rules for this sprint
- Keep the sprint slice small and playable.
- `main` owns `project/docs/SPRINT.md`.
- Do not parallelize workers that will edit the same files.
- Design must land before engineering starts implementation.
- Content can run after design and may run alongside engineering **only** if it stays inside its owned docs.
- QA runs after engineering and content return.
- Never claim runtime verification happened unless the worker explicitly says which commands were run.

## Dispatch order
### 1) Send the design worker
Use `project/prompts/DESIGN_SPRINT1_TASK_SPEC.md`.

Required output before moving on:
- updated `project/docs/GDD.md` if needed
- updated `project/docs/DECISIONS.md`
- updated `project/docs/HANDOFF-ENGINEERING.md`
- clear task/event/payout rules

### 2) Send the engineer worker
Use `project/prompts/ENGINEER_SPRINT1_MVP_IMPLEMENTATION.md`.

Pass along:
- the design worker summary
- the final `project/docs/HANDOFF-ENGINEERING.md`
- any design decisions added to `project/docs/DECISIONS.md`

Required output before moving on:
- code changes under `project/src/**`
- updated `project/scripts/smoke_runner.lua` if needed
- commands run and results
- manual validation notes or explicit unverified areas

### 3) Send the content worker
Use `project/prompts/CONTENT_SPRINT1_ENVIRONMENT_AND_COPY.md`.

Pass along:
- the design worker summary
- the current `project/docs/GDD.md`
- the current `project/docs/HANDOFF-ENGINEERING.md` so content matches real task names

Required output before moving on:
- updated `project/docs/ART-DIRECTION.md`
- updated `project/docs/HANDOFF-CONTENT.md`
- updated `project/docs/STORE-BEATS.md`

### 4) Send the QA worker
Use `project/prompts/QA_SPRINT1_VALIDATION.md`.

Pass along:
- engineer changed files summary
- content changed files summary
- any commands actually run

Required output before calling the sprint slice ready:
- updated `project/docs/QA.md`
- updated `project/docs/TEST-PLAN-SMOKE.md`
- updated `project/docs/BACKLOG.md` with issues/follow-ups
- explicit ready / not ready verdict

### 5) Integrate as `main`
After all workers return:
- update `project/docs/SPRINT.md`
- call out what is done vs still risky
- state whether Milestone 1 is on track
- identify the single best next delegation

## Sprint status update template for `main`
Use this structure when reporting back to the user:
- Goal status:
- Worker results:
- Files changed:
- What is verified:
- Risks / unknowns:
- Next best action:
