# Main Agent — Sprint 7 Sequence

## Sprint title
Full-Store Art Rollout + Store Presence

## Goal
Take the accepted Sprint 6 visual slice and scale it into a consistent full-store presentation while refreshing the public-facing asset pack to match the real in-game look.

## Producer rules
- Protect the Sprint 6 Ready baseline
- No feature creep into new mechanics, events, or economy work
- Design locks rollout tiers, signage language, and public-asset direction before implementation starts
- After design is locked, engineer and content run in parallel
- QA judges this sprint on player-visible consistency, readability, honest capture assets, and runtime safety
- Asset ambition must stay shippable; a cohesive modular rollout beats a half-finished bespoke art binge

## Dispatch order
1. Send `DESIGN_SPRINT7_FULL_STORE_VISUAL_ROLLOUT_SPEC.md`
2. After design locks the rollout plan, dispatch in parallel:
   - `ENGINEER_SPRINT7_ART_ROLLOUT_AND_PERFORMANCE.md`
   - `CONTENT_SPRINT7_FULL_STORE_ART_AND_CAPTURE.md`
3. After both return, dispatch:
   - `QA_SPRINT7_FULL_STORE_ART_GATE.md`

## Non-negotiable deliverables
- full-store rollout matrix
- signage and wayfinding system
- performance guardrails
- store-presence asset direction / capture set
- before / after proof for all Tier A zones
- build / smoke / runtime sanity evidence

## Stop conditions
Do not call Sprint 7 Ready unless QA has evidence that:
- player-traversed zones no longer look half-graybox,
- the full store reads as one consistent game,
- phone HUD / prompts remain readable,
- blackout and mimic still read clearly after the rollout,
- store-page assets match the shipped look,
- build / smoke / live sanity stay green.

## Output expectations
Each worker must update the relevant docs and handoffs, not just return prose summaries.
