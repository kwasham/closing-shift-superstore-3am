# Worker prompt — content

## Objective
Define the first compact supermarket layout, task-facing copy, onboarding text, and atmosphere rules for the Sprint 1 MVP slice of **Closing Shift: Superstore 3AM**.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/src/ReplicatedStorage/Shared/Constants.lua`

## Edit these files
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/STORE-BEATS.md`

## Do not edit
- `project/docs/SPRINT.md`
- `project/src/**`
- `project/docs/GDD.md` unless you discover a true contradiction; if so, note it in your return instead of editing it directly

## Constraints
- Content must match the six MVP tasks and the two MVP events.
- Keep the first map compact, readable, and mobile-friendly.
- Lean into fluorescent supermarket horror, but keep interaction text instantly understandable.
- Focus on what the builder/designer in Roblox Studio needs next, not on long lore writing.
- Assume the first playable slice is about clarity and mood, not full environmental polish.

## Required deliverables
### In `project/docs/ART-DIRECTION.md`
Define:
- visual pillars
- lighting mood
- material / color rules
- prop density guidance
- silhouette / readability notes
- mobile UI readability constraints

### In `project/docs/STORE-BEATS.md`
Create a room-by-room or zone-by-zone spec for the first store, including:
- entrance / front doors
- checkout lane area
- aisles / shelf zones
- freezer section
- trash / back area
- cart return / exterior or front area
- where the blackout feels strongest
- where mimic tasks are most readable/scary

### In `project/docs/HANDOFF-CONTENT.md`
Create a practical content handoff including:
- task prompt copy and interaction verbs
- alert copy variations for blackout and mimic
- onboarding / first-round instruction sequence
- essential signs / decals / label text
- highest-priority props to place first in Studio
- optional sound cues and where they trigger

## Acceptance criteria
- A builder/content designer could lay out the first store from your docs.
- Prompt text matches the task names engineering will implement.
- Onboarding is short and readable on mobile.
- The horror tone is clear without making navigation confusing.

## Return format
- Summary of the content package
- Changed files
- Top 5 highest-priority content tasks for the next Studio pass
- Any contradictions or risks you spotted
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
