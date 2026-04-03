# Worker prompt — content

## Objective
Define the Sprint 2 content package for **Closing Shift: Superstore 3AM**: store readability, signage, onboarding copy, alert copy, end-of-round copy, and sound-cue intent.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/STORE-BEATS.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present

## Edit these files
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/STORE-BEATS.md`

## Do not edit
- `project/docs/SPRINT.md`
- `project/src/**`
- `project/docs/GDD.md` unless you discover a true contradiction; if so, report it instead of editing directly

## Constraints
- Keep the single store map. This is not an expansion sprint.
- Make the environment easier to read before making it denser.
- All player-facing copy must remain short enough for phone-sized UI.
- Match the canonical task names and event names from engineering / design.
- Sound guidance should support either placeholder or final assets.
- Clarity beats lore.

## Required deliverables
### In `project/docs/ART-DIRECTION.md`
Define:
- signage and landmark rules
- contrast / readability rules for lit versus blackout states
- prop-density guidance for aisles and checkout
- HUD copy tone and readability constraints
- audio tone guidance for tension without noise fatigue

### In `project/docs/STORE-BEATS.md`
Create a revised v2 readability spec for:
- spawn / lobby-to-store handoff
- entrance and checkout landmarks
- aisle labeling strategy
- freezer section readability
- trash / back-area readability
- cart return readability
- best zones for blackout mood
- best zones for mimic readability
- sightlines and “where should a new player look first?”

### In `project/docs/HANDOFF-CONTENT.md`
Create a practical content handoff including:
- tutorial copy
- alert copy variants for blackout / mimic / final-task unlock
- end-of-round summary copy
- late-join wait-state copy
- signage / decal text
- highest-priority props and signs for the next Studio pass
- sound cue list with intended emotion and suggested duration

## Acceptance criteria
- A builder can improve the first store layout from the docs alone.
- Copy is short, readable, and consistent across tutorial, HUD, and alerts.
- Sound cues and visual landmarks support the same player guidance.

## Return format
- Summary of the Sprint 2 content package
- Changed files
- Top 5 highest-priority content tasks for the next Studio pass
- Any contradictions or risks you spotted
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
