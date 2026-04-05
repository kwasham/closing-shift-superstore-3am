# Engineer Worker — Sprint 6 Visual Implementation

## Mission
Implement the visual systems and runtime-safe presentation work needed for Sprint 6 without destabilizing the Sprint 5 gameplay baseline.

## You own
1. lighting-state implementation,
2. visual config / theme tokens in code,
3. HUD skin plumbing and safe layout preservation,
4. event presentation hooks,
5. runtime-safe integration points for content's environment pass,
6. regression proof that gameplay still works.

## Implementation targets
- Add / centralize visual constants or theme tokens where appropriate
- Implement lighting / atmosphere presets for:
  - normal shift
  - blackout
  - mimic emphasis
  - round-end win
  - round-end fail
- Update HUD / UI styling so the game no longer feels like debug UI
- Preserve phone-safe layout hierarchy and alert readability
- Support content-side art replacements without breaking gameplay-critical nodes
- Add any safe helper structure needed for signage, decals, or hero-zone grouping
- Keep task prompts, task hitboxes, and close-register logic stable

## Constraints
- No new mechanics
- No gameplay-rule rewrites
- Do not rename or remove critical runtime paths carelessly
- Prefer low-cost effects and lighting over expensive effect spam
- If an art asset is missing, the runtime must fail gracefully rather than breaking the scene

## QA-facing proof requirements
Collect or enable proof for:
- normal / blackout / mimic / round-end visual states
- phone HUD readability during active play and alert states
- 1-player and 2-player runtime sanity after the visual pass
- before / after captures of the main slice zones
- build + smoke still green

## Files you will likely touch
- runtime source under `project/src/**`
- any shared visual config / theme modules you add
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/BACKLOG.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Definition of done
The new visual layer is integrated, runtime-safe, and regression-ready for QA.
