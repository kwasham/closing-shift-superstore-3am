# Sprint 2 Plan — Clarity and Feel Pass

## Recommended sprint name
**Sprint 2 — New-Player Clarity and Feel**

## Why this sprint now
Sprint 1 proved the round loop. The fastest way to raise the quality bar is not more feature surface. It is making the existing shift understandable, readable, and atmospheric enough that a new player can complete a round without live coaching.

This sprint should convert the current internal playable into a cleaner alpha-feeling slice while protecting the now-proven Sprint 1 game logic.

## Sprint goal
Ship a polished internal build where a first-time player can:
- understand the objective quickly
- identify active work without confusion
- read the HUD on phone-sized screens
- recognize blackout and mimic states from clear visual + audio cues
- understand success / failure payout from an end-of-round summary
- join late and understand they must wait for the next shift

## Scope locked for this sprint
- first-session onboarding / tutorial pass
- active-task readability and feedback polish
- final-task unlock communication for `Close Register`
- HUD copy / layout / alert polish for phone-sized play
- end-of-round result summary
- blackout + mimic presentation pass
  - clearer alert copy
  - distinct audio hooks / cues
  - clear start / end feedback
- compact store readability pass in docs
  - landmarks
  - signage
  - prop priorities
  - task-node placement guidance
- live runtime verification focused on clarity and no-regression

## Explicitly out of scope
- new event types
- roaming manager NPC
- revive system
- stamina
- DataStore persistence
- cosmetic shop UI
- progression / unlock economy
- second store or extra map
- major round-timer / quota rebalance unless required by a clarity bug

## Success criteria
Sprint 2 is ready when:
1. A new tester can enter the experience and understand the goal without verbal explanation.
2. The HUD remains readable on a phone-sized viewport during normal play and alert states.
3. Active tasks and the `Close Register` final-task unlock are obvious enough that testers do not stall on “what do I do next?”
4. Blackout and mimic both have distinct presentation cues that match their gameplay consequences.
5. End-of-round success / failure clearly explains projected payout and what landed in visible `Cash`.
6. Late join shows a clear “wait for the next shift” state without broken initialization.
7. Sprint 1 core gameplay behavior does not regress.

## Recommended execution order
1. `design` locks the clarity / feedback / onboarding spec.
2. `engineer` implements the UI / tutorial / audio-hook / feedback pass.
3. `content` delivers the store readability, signage, copy, and cue package in parallel with engineering after design lands.
4. `qa` runs a regression + clarity gate.
5. `main` updates `project/docs/SPRINT.md` and decides whether Milestone 2 is ready.

## File ownership recommendation
- `main` owns `project/docs/SPRINT.md`
- `design` owns `project/docs/GDD.md`, `project/docs/DECISIONS.md`, `project/docs/HANDOFF-ENGINEERING.md`
- `engineer` owns `project/src/**` and `project/scripts/smoke_runner.lua`
- `content` owns `project/docs/ART-DIRECTION.md`, `project/docs/HANDOFF-CONTENT.md`, `project/docs/STORE-BEATS.md`
- `qa` owns `project/docs/QA.md`, `project/docs/TEST-PLAN-SMOKE.md`, and QA follow-ups in `project/docs/BACKLOG.md`

## Risks to control
- adding polish that quietly changes proven Sprint 1 gameplay rules
- overlong tutorial text that hurts phone readability
- sound asset sourcing delaying otherwise-ready polish work
- content / engineering drift on cue names or task-callout language
- UI improvements that break late-join or alert stacking

## Producer call
Keep this sprint as a **clarity-and-feel pass**, not a content explosion sprint.
Defer persistence, progression, and new event types until this slice reads cleanly to a first-time player.
