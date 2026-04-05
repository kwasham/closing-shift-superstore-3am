# Main Agent — Sprint 6 Sequence

## Sprint title
Visual Identity + Environment Art Foundation

## Goal
Take the Sprint 5 Ready baseline and move the game off an obvious primitive / graybox look by shipping one polished visual vertical slice and the reusable rules behind it.

## Producer rules
- Protect the Sprint 5 Ready baseline
- No feature creep into new mechanics, new maps, or economy work
- Design locks the visual language before implementation starts
- After design is locked, engineer and content run in parallel
- QA must judge this sprint on live player-facing proof, not taste alone
- Asset-import ambition must not become a blocker; a strong modular Studio-material pass is acceptable if it ships the goal

## Dispatch order
1. Send `DESIGN_SPRINT6_VISUAL_DIRECTION_SPEC.md`
2. After design locks the style and priority zones, dispatch in parallel:
   - `ENGINEER_SPRINT6_VISUAL_IMPLEMENTATION.md`
   - `CONTENT_SPRINT6_ENVIRONMENT_UI_ART_PASS.md`
3. After both return, dispatch:
   - `QA_SPRINT6_VISUAL_VERTICAL_SLICE_GATE.md`

## Non-negotiable deliverables
- final art direction lock
- modular environment kit list
- polished player-facing slice zones
- lighting state implementation
- HUD / UI skin refresh
- before / after proof captures
- regression sanity proof
- hero shot list / visual identity pack

## Stop conditions
Do not call Sprint 6 Ready unless QA has evidence that:
- the key slice zones no longer read as raw graybox from player cameras
- blackout and mimic are visually distinct and still readable
- phone HUD readability remains green after the skin pass
- 1-player and 2-player core runtime sanity remain green
- build / smoke remain green

## Output expectations
Each worker must update the relevant docs and handoff notes, not just provide prose summaries.
