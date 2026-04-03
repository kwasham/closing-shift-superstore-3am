# Worker prompt — design

## Objective
Turn Sprint 2 of **Closing Shift: Superstore 3AM** into an implementation-ready spec for onboarding, active-task readability, HUD wording hierarchy, end-of-round explanation, and blackout / mimic presentation cues.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/BACKLOG.md`
- `project/docs/DECISIONS.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`

## Edit these files
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/BACKLOG.md` only if you identify clean post-sprint follow-up work

## Do not edit
- `project/docs/SPRINT.md`
- `project/src/**`

## Constraints
- Keep Sprint 2 focused on readability and feel.
- Preserve the proven Sprint 1 round logic:
  - 9-minute round
  - 15-second intermission
  - current quota bundle logic
  - current blackout / mimic gameplay consequences
  unless there is a genuine clarity or bug reason to propose a small change.
- Do not introduce:
  - new event types
  - manager NPC
  - revive
  - stamina
  - persistence
  - cosmetic shop or economy expansion
- Phone readability matters more than flavor text.
- Fewer, clearer messages beat many clever messages.

## Required deliverables
### In `project/docs/GDD.md`
Refine only the sections needed to support Sprint 2. Keep the doc lean.

### In `project/docs/DECISIONS.md`
Record the settled Sprint 2 decisions, including:
- tutorial scope and trigger rules
- alert hierarchy and copy-length constraints
- active-task highlight behavior
- final-task unlock communication
- end-of-round summary requirements
- audio cue contract / categories

### In `project/docs/HANDOFF-ENGINEERING.md`
Create an implementation-ready brief with:
1. **Tutorial flow**
   - when it appears
   - how many steps
   - exact teaching priorities
   - how it behaves for late joiners
2. **HUD / alert hierarchy**
   - top-priority messages
   - message length limits
   - stack / replace rules
   - phone-safe layout guidance
3. **Task feedback rules**
   - how active tasks are highlighted
   - what happens on task completion
   - how `Close Register` stays obviously locked / unlocked
4. **Audio cue matrix**
   - cue id / name
   - trigger
   - priority
   - fallback rule if asset is missing
5. **Round-end summary**
   - what success shows
   - what failure shows
   - how projected payout and landed `Cash` are explained
6. **No-regression guardrails**
   - rules that must remain unchanged from Sprint 1
7. **Deferred items**
   - what stays for Sprint 3 or later

## Acceptance criteria
- Engineering can implement directly from the handoff without needing core UX clarification.
- Tutorial, audio, and feedback behavior are specific enough to build.
- The design protects Sprint 1 logic instead of reopening it.

## Return format
- Summary of the Sprint 2 design decisions
- Changed files
- 3–5 biggest implementation implications for engineering
- Any unresolved but non-blocking risks
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
