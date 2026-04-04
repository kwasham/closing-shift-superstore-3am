# Main agent — Sprint 4 sequence

## Goal
Move **Closing Shift: Superstore 3AM** from a ready alpha into a real Milestone 4 launch candidate with:
- clearer launch-facing wording
- hardened release proof
- a complete publish surface package
- an honest go / no-go checklist

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/BACKLOG.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project-template/docs/SPRINT4-PLAN.md`
- `project-template/docs/LAUNCH-WATCHLIST-S4.md`
- `project-template/docs/RELEASE-CHECKLIST-S4.md`
- `project/prompts/README_SPRINT4.md`

## Producer rules for this sprint
- Protect the ready Sprint 1 + Sprint 2 + Sprint 3 baseline.
- `main` owns `project/docs/SPRINT.md`.
- Design must lock wording, publish-surface, and watchlist rules before engineering starts.
- Content may run alongside engineering only after design lands and only in content-owned docs.
- QA must separate **runtime regression proof**, **launch-facing clarity proof**, **publish-surface completeness**, and **still unverified**.
- Do not call Sprint 4 ready unless there is actual client evidence for payout/readability/late-join and a completed release checklist.
- No new gameplay systems, events, maps, or monetization surfaces in this sprint.

## Dispatch order
### 1) Send the design worker
Use `project/prompts/DESIGN_SPRINT4_LAUNCH_CANDIDATE_SPEC.md`.

Required output before moving on:
- updated `project/docs/GDD.md` if needed
- updated `project/docs/DECISIONS.md`
- updated `project/docs/HANDOFF-ENGINEERING.md`
- updated `project/docs/LAUNCH-WATCHLIST-S4.md`
- locked wording / first-10-minute / publish-surface rules

### 2) Send the engineer worker
Use `project/prompts/ENGINEER_SPRINT4_HARDENING_AND_RELEASE_IMPLEMENTATION.md`.

Pass along:
- the design worker summary
- the final `project/docs/HANDOFF-ENGINEERING.md`
- the current `project/docs/LAUNCH-WATCHLIST-S4.md`
- any new decision entries in `project/docs/DECISIONS.md`

Required output before moving on:
- code changes under `project/src/**`
- script or tooling changes under `project/scripts/**` if needed
- commands run and exact results
- runtime/client evidence or explicit unverified areas
- notes on any Rojo-warning cleanup or why it was deferred

### 3) Send the content worker
Use `project/prompts/CONTENT_SPRINT4_STORE_PAGE_AND_RELEASE_SURFACES.md`.

Pass along:
- the design worker summary
- the current `project/docs/GDD.md`
- the current `project/docs/HANDOFF-ENGINEERING.md`

Required output before moving on:
- updated `project/docs/ART-DIRECTION.md`
- updated `project/docs/HANDOFF-CONTENT.md`
- created or updated `project/docs/STORE-PAGE-BRIEF-S4.md`
- updated `project/docs/RELEASE_NOTES.md`

### 4) Send the QA worker
Use `project/prompts/QA_SPRINT4_LAUNCH_CANDIDATE_GATE.md`.

Pass along:
- engineer changed files summary
- content changed files summary
- commands actually run
- runtime evidence actually captured
- publish-surface docs actually completed

Required output before calling the sprint ready:
- updated `project/docs/QA.md`
- updated `project/docs/TEST-PLAN-SMOKE.md`
- updated `project/docs/BACKLOG.md`
- updated `project/docs/RELEASE-CHECKLIST-S4.md`
- explicit Ready / Not Ready verdict
- clear distinction between regression blockers, clarity blockers, and release-surface blockers

### 5) Integrate as `main`
After all workers return:
- update `project/docs/SPRINT.md`
- state whether Milestone 4 is ready
- call out what changed versus Sprint 3
- record any non-blocking issues left open
- identify the single best next delegation after Milestone 4

## Sprint status update template for `main`
Use this structure when reporting back:
- Goal status:
- Worker results:
- Files changed:
- What is runtime-proven:
- What is launch-surface-proven:
- What is still unverified:
- Known non-blocking issues:
- Producer decision:
- Next best action:
