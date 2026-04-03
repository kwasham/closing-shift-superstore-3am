# Content Handoff

Use this file when engineering, design, or production needs Sprint 2 player-facing copy, signage, readability priorities, and sound-cue intent.

## Objective
Define the exact tutorial wording, alert wording, end-of-round explanation copy, signage text, and readability-first content direction for the Sprint 2 clarity-and-feel pass in **Closing Shift: Superstore 3AM**.

## Source of truth
For Sprint 2 content, treat these as locked:
1. `project/docs/HANDOFF-ENGINEERING.md`
2. `project/docs/DECISIONS.md`
3. `project/docs/GDD.md`
4. `project/docs/STORE-BEATS.md`
5. `project/docs/ART-DIRECTION.md`

## Locked Sprint 2 content rules
- Sprint 2 is a clarity-and-feel pass only.
- Sprint 1 gameplay rules remain unchanged.
- Copy must stay short, readable, and phone-safe.
- `Close Register` remains the final gated task.
- Late joiners during `Playing` or `Ended` stay in a wait-for-next-shift state.
- Mimic remains deceptive on spawn; do not add a global spawn alert.
- Sound guidance must support placeholder assets if final content is not ready.

## 1) Tutorial copy
Use these lines exactly unless engineering needs a tiny formatting change for UI limits.

| Step id | Trigger intent | Exact copy |
| --- | --- | --- |
| `tutorial_goal` | first eligible intermission | `Finish the list before time runs out.` |
| `tutorial_follow_task` | first active round snapshot | `Follow the glow. Hold on a task to work.` |
| `tutorial_banked_pay` | first real task complete or early fallback | `Task cash is banked. Register unlocks last.` |
| `tutorial_register_end` | first register unlock | `Close Register is ready. Finish the shift.` |

### Tutorial tone rules
- One sentence only.
- No lore, jokes, or punctuation-heavy lines.
- Teach one useful thing per step.
- If a line feels clever, shorten it.

## 2) Alert copy
These are the preferred defaults for Sprint 2.

| Alert id / moment | Exact copy | Notes |
| --- | --- | --- |
| `late_join_wait` | `Shift in progress. Wait for the next one.` | Pinned wait-state message |
| `blackout_active` | `Blackout. Wait for backup power.` | Pinned for blackout duration |
| `blackout_end` | `Power restored. Get back to work.` | Short recovery cue |
| `register_unlocked` | `Close Register unlocked.` | Final-task callout |
| `round_start_hint` | `Clock in. Follow the task glow.` | Low-priority start hint |
| `mimic_triggered` | `False task. Lost time and pay.` | Urgent trigger feedback |
| `round_success` | `Shift cleared. Cashing out.` | Round result |
| `round_failure` | `Time's up. Partial pay.` | Round result |

### Alert rules
- One alert slot only; no stacked feed language.
- Keep each line under the Sprint 2 handoff character target.
- Do not create a mimic spawn alert.
- Blackout should read like a store-wide outage.
- Mimic trigger should read like a mistake/trap, not a power failure.

## 3) End-of-round summary copy
Use compact, number-friendly wording.

### Success summary
- Header: `SHIFT CLEARED`
- Line labels:
  - `Tasks:`
  - `Banked:`
  - `Bonus: +$35`
  - `False task:` only if needed
  - `Cash added:`

### Failure summary
- Header: `SHIFT FAILED`
- Line labels:
  - `Tasks:`
  - `Banked:`
  - `60% pay:`
  - `False task:` only if needed
  - `Cash added:`

### Summary rules
- Explain the player's own payout numbers only.
- Omit the `False task:` line when penalty is `0`.
- Keep headers blunt and readable.
- Do not add long flavor blurbs after win/loss.

## 4) Late-join wait-state copy
Use this wording for excluded joiners.

| UI element | Exact copy |
| --- | --- |
| State | `Waiting for next shift` |
| Alert | `Shift in progress. Wait for the next one.` |
| Objectives | `Shift in progress. Wait for the next one.` |
| Earnings / payout helper | `Current shift is locked to the starting roster. You'll clock in next round.` |

Rules:
- This state should feel stable, not like a bug.
- Do not show active-round guidance to excluded joiners.
- Do not show payout-summary language to excluded joiners for that round.

## 5) Signage / decal text
These are the highest-priority readability signs for Sprint 2.

| Zone | Text | Purpose |
| --- | --- | --- |
| Front entry | `ENTRANCE` / `EXIT` | orientation |
| Checkout | `CHECKOUT` | front-half anchor |
| Register lane | `LANE 1` | final-task identity |
| Aisle headers | `Aisle A`, `Aisle B`, `Aisle C` | route clarity |
| Freezer wall | `FROZEN` | cold-zone callout |
| Back route | `EMPLOYEES ONLY` | trash-route clarity |
| Exterior corral | `CART RETURN` | obvious cart destination |
| Spill support | `CAUTION WET FLOOR` | spill readability support |
| Register support | `REGISTER CLOSED` | optional locked-state support |

### Signage rules
- Prefer 1 to 3 words.
- Keep fonts simple and high contrast.
- Use signage to clarify, not decorate.
- Never place dense sign clusters behind task prompts.

## 6) Highest-priority props and signs for the next Studio pass
1. `CHECKOUT` and `LANE 1` signs that clearly frame the register lane
2. Large, readable aisle headers for A / B / C
3. A stronger freezer alarm panel silhouette and light treatment
4. A clean `EMPLOYEES ONLY` back-door marker and trash-route anchor props
5. A simple, unmistakable `CART RETURN` corral read from the storefront

## 7) Sound cue intent
These cues may use placeholder or final assets.

| Cue id | Intended emotion | Suggested duration | Notes |
| --- | --- | --- | --- |
| `task_complete` | quick confirmation | 0.2–0.4s | light, not celebratory |
| `register_unlocked` | objective snap-in | 0.5–0.9s | should pull focus cleanly |
| `blackout_start` | abrupt loss of control | 0.6–1.2s | hard power-cut feel |
| `blackout_end` | recovery / momentum return | 0.5–1.0s | brighter than start cue |
| `mimic_triggered` | wrong / punished / unsettling | 0.7–1.3s | should feel off, not explosive |
| `round_success` | relief + completion | 0.8–1.5s | modest win cue |
| `round_failure` | flat disappointment / dread | 0.8–1.5s | avoid melodrama |

### Audio content rules
- Prioritize distinct state-change communication over atmosphere layering.
- Avoid noisy loops that compete with alerts.
- If a cue asset is missing, text/visual feedback must still carry meaning.

## 8) Builder/readability notes
- The first thing a new player should see from spawn is checkout plus at least one aisle label.
- Restock shelf anchors should sit where shelf gaps are visible from aisle mouths.
- Freezer and trash interactions should feel memorable without being visually hidden.
- The register lane should remain the cleanest and most legible landmark in the store.
- Blackout mood should come from contrast loss and sound, not from removing all orientation.

## Sprint 2 content target
The store should feel easier to understand, not busier. If a sign, prop, or line of copy does not help a first-time player know where to go or what just happened, cut it.