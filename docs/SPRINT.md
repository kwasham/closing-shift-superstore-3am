# Sprint

## Sprint 6 — Visual Identity + Environment Art Foundation

## Sprint goal
Take the Sprint 5 Ready baseline and move the game off an obvious primitive / graybox look by shipping one polished visual vertical slice and the reusable visual rules behind it.

## Scope locked for this sprint
- lobby / entrance
- checkout zone
- one hero aisle
- freezer section
- stockroom corner
- lighting states for normal / blackout / mimic / round-end
- HUD / UI skin refresh
- interaction feedback polish
- before / after proof captures
- live visual proof standards for QA

## Explicitly out of scope
- new gameplay systems
- new map
- new round event or enemy type
- economy rebalance
- progression expansion
- monetization changes
- full-store bespoke prop pass
- photoreal rendering target
- heavy VFX spam or cinematic-only lighting setups that hurt gameplay readability

## File-ownership rule for this sprint
To reduce merge conflicts:
- `main` owns `project/docs/SPRINT.md`
- `design` owns visual direction and handoff lock in docs
- `engineer` owns implementation in `project/src/**` and proof/support scripts
- `content` owns environment/UI art-facing docs, signage/copy/art-surface support, and capture-direction support docs
- `qa` owns `project/docs/QA.md` and QA follow-ups in `project/docs/BACKLOG.md`

## Suggested execution order
1. `design` locks the visual language and priority zones.
2. `engineer` and `content` execute in parallel from the locked design contract.
3. `qa` validates the visual vertical slice with before / after and live proof.
4. `main` integrates status and decides whether Sprint 6 is Ready.

## Acceptance criteria for sprint completion
- The critical-path slice zones no longer read as obvious graybox from player camera positions.
- The visual slice follows one consistent art language across architecture, props, signage, lighting, and UI.
- Blackout, mimic, and round-end are visually distinct and readable in runtime proof.
- Phone HUD readability remains green after the skin refresh.
- Existing gameplay interaction points remain stable after the art pass.
- Build, smoke, and basic 1-player / 2-player runtime sanity remain green.
- QA has before / after captures and live evidence for the key visual states.

## Current status
### Ready for delegation
- engineer implementation pass from the locked Sprint 6 visual handoff
- content environment / UI art pass from the locked Sprint 6 visual handoff

### In progress
- Sprint 6 is active as **Visual Identity + Environment Art Foundation**
- design lock is complete

### Done
- Sprint 1 is **Ready**
- Sprint 2 is **Ready**
- Sprint 3 is **Ready**
- Sprint 4 is **Ready**
- Sprint 5 is **Ready**
- Sprint 6 visual direction is locked across:
  - `project/docs/GDD.md`
  - `project/docs/ART-DIRECTION.md`
  - `project/docs/DECISIONS.md`
  - `project/docs/HANDOFF-ENGINEERING.md`
  - `project/docs/HANDOFF-CONTENT.md`
  - `project/docs/BACKLOG.md`

## Risks
- Optional imported art could cause scope slip if the team chases bespoke polish too early.
- The sprint must preserve phone readability and the Sprint 5 gameplay baseline.
- The team should favor Studio-first modular reuse over expensive one-off assets.

## Next producer action
Dispatch Sprint 6 engineering and content in parallel from the locked visual direction handoff, then send QA on the visual vertical slice gate.
