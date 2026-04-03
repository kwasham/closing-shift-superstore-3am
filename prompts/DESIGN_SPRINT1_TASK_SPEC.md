# Worker prompt — design

## Objective
Turn the current concept for **Closing Shift: Superstore 3AM** into an implementation-ready Sprint 1 spec for tasks, event timing, payout, and anti-frustration rules.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/BACKLOG.md`
- `project/docs/DECISIONS.md`
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`

## Edit these files
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/BACKLOG.md` only if you identify post-sprint follow-up work

## Do not edit
- `project/docs/SPRINT.md`
- `project/src/**`

## Constraints
- Keep Sprint 1 inside the existing MVP scope.
- Stay with **1–6 players**, **8–10 minute rounds**, and **one currency**.
- Use the six MVP task categories already in the project:
  - Restock Shelf
  - Clean Spill
  - Take Out Trash
  - Return Cart
  - Check Freezer
  - Close Register
- Use the two MVP events already in the project:
  - Blackout
  - Mimic / false task
- No revive system, stamina system, shop pass, or persistence design in this sprint.
- Punishments should create tension without making the game feel unfair or dead-on-arrival for solo players.

## Required deliverables
### In `project/docs/GDD.md`
Refine only the sections that need concrete numbers or behavior. Do not bloat the doc.

### In `project/docs/DECISIONS.md`
Record the important settled decisions for Sprint 1, including:
- payout model
- failure condition
- how mimic punishes the player
- blackout interaction behavior
- anti-frustration rules

### In `project/docs/HANDOFF-ENGINEERING.md`
Create an implementation-ready brief with:
1. A task contract table for all six tasks containing:
   - task id / name
   - player-facing prompt text
   - reward
   - hold duration
   - any special note
2. Round rules:
   - start condition
   - win condition
   - fail condition
   - payout timing
3. Event rules:
   - blackout trigger timing and duration
   - what task prompts do during blackout
   - mimic selection rules
   - mimic penalty details
4. Anti-frustration rules:
   - cap or pacing notes on punishments
   - solo-play fairness notes
5. Open risks / deferred items for future sprints

## Acceptance criteria
- Engineering can implement directly from your handoff without asking for core rule clarification.
- Every task has readable values and prompt text.
- Payout and event behavior are numerically defined.
- Open questions are reduced to non-blocking items.

## Return format
- Summary of the design decisions you made
- Changed files
- 3–5 biggest implementation implications for engineering
- Any unresolved but non-blocking risks
- A short producer note that `main` can paste into `project/docs/SPRINT.md`
