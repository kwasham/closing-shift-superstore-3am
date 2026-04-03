# Main agent — Sprint 3 sequence

## Goal
Move **Closing Shift: Superstore 3AM** from a readable internal alpha slice into an alpha build with a measurable return loop:
- one new event
- persistent progression
- cosmetic spend/equip flow
- instrumentation and a harder QA bar

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/BACKLOG.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project-template/docs/SPRINT3-PLAN.md` or your copied Sprint 3 plan
- `project-template/docs/KPI-CANDIDATES-S3.md`
- `project/prompts/README_SPRINT3.md`

## Producer rules for this sprint
- Protect the ready Sprint 1 + Sprint 2 baseline.
- `main` owns `project/docs/SPRINT.md`.
- Design must lock the event/progression/shop contract before implementation starts.
- Content may run alongside engineering only after design lands and only in content-owned docs.
- QA must separate **runtime proven**, **log/instrumentation proven**, and **still unverified**.
- Do not call Sprint 3 ready unless persistence, purchase/equip, and `Security Alarm` runtime evidence are real.

## Dispatch order
### 1) Send the design worker
Use `project/prompts/DESIGN_SPRINT3_ALPHA_RETURN_LOOP_SPEC.md`.

Required output before moving on:
- updated `project/docs/GDD.md` if needed
- updated `project/docs/DECISIONS.md`
- updated `project/docs/HANDOFF-ENGINEERING.md`
- updated `project/docs/KPI-CANDIDATES-S3.md`
- locked event/progression/shop/instrumentation rules

### 2) Send the engineer worker
Use `project/prompts/ENGINEER_SPRINT3_ALPHA_RETURN_LOOP_IMPLEMENTATION.md`.

Pass along:
- the design worker summary
- the final `project/docs/HANDOFF-ENGINEERING.md`
- the current `project/docs/KPI-CANDIDATES-S3.md`
- any new decision entries in `project/docs/DECISIONS.md`

Required output before moving on:
- code changes under `project/src/**`
- script changes under `project/scripts/**` if needed
- commands run and exact results
- runtime evidence or explicit unverified areas
- log/instrumentation proof notes

### 3) Send the content worker
Use `project/prompts/CONTENT_SPRINT3_EVENT_SHOP_AND_REWARDS.md`.

Pass along:
- the design worker summary
- the current `project/docs/GDD.md`
- the current `project/docs/HANDOFF-ENGINEERING.md`

Required output before moving on:
- updated `project/docs/ART-DIRECTION.md`
- updated `project/docs/HANDOFF-CONTENT.md`
- created or updated `project/docs/SHOP-CATALOG-S3.md`

### 4) Send the QA worker
Use `project/prompts/QA_SPRINT3_ALPHA_RETURN_LOOP_GATE.md`.

Pass along:
- engineer changed files summary
- content changed files summary
- commands actually run
- runtime evidence actually captured
- instrumentation/log evidence actually captured

Required output before calling the sprint ready:
- updated `project/docs/QA.md`
- updated `project/docs/TEST-PLAN-SMOKE.md`
- updated `project/docs/BACKLOG.md`
- explicit ready / not-ready verdict
- clear distinction between regression proof, persistence/shop proof, and analytics/log proof

### 5) Integrate as `main`
After all workers return:
- update `project/docs/SPRINT.md`
- state whether Milestone 3 is ready
- note what changed from Sprint 2
- leave any non-blocking polish or monetization hooks in backlog
- identify the single best next delegation for Sprint 4

## Sprint status update template for `main`
Use this structure when reporting back:
- Goal status:
- Worker results:
- Files changed:
- What is runtime-proven:
- What is log/instrumentation-proven:
- What is still unverified:
- Regression risks:
- Producer decision:
- Next best action:
