# Closing Shift: Superstore 3AM — GDD

## One-line pitch
A 1–6 player co-op Roblox horror job sim where players close a supermarket at 3AM, complete store tasks, survive escalating paranormal events, and spend their paycheck on upgrades and cosmetics.

## Design pillars
1. **Instantly readable** — a player should understand the fantasy in under 10 seconds.
2. **Short tense rounds** — 8–10 minute sessions with rising pressure.
3. **Co-op chaos** — small mistakes create funny or scary moments with friends.
4. **Replay loop** — finish shift, earn payout, unlock more style and efficiency.
5. **Scope discipline** — one map, a handful of tasks, and two or three event types before any major expansion.

## Target session
- Players: 1–6
- Round length: 9 minutes
- Intermission: 15 seconds
- Goal: complete the store-close checklist and lock the register before time runs out

## MVP systems
- Lobby + one playable grocery store
- Task system
  - restock shelves
  - clean spills
  - take out trash
  - return carts
  - check freezer
  - close register
- Round manager
- Basic event system
  - blackout
  - mimic / false task
- End-of-round payout
- One currency
- Light cosmetic shop
- HUD and round alerts
- Smoke test path

## Sprint 1 implementation rules

### Round structure
- A round starts when at least 1 player is present and intermission finishes.
- The server snapshots the active roster at round start. Players who join after the round starts wait for the next intermission.
- The round fails only when the timer reaches 0 before the register is closed.
- The round is won when all non-register quotas are completed and then **Close Register** is completed.
- **Close Register** is always locked until every other quota reaches 0.

### Task quotas by player count
| Players at round start | Restock Shelf | Clean Spill | Take Out Trash | Return Cart | Check Freezer | Close Register | Total real tasks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 2 | 1 | 1 | 2 | 1 | 1 | 8 |
| 2 | 2 | 2 | 1 | 2 | 1 | 1 | 9 |
| 3–4 | 2 | 2 | 2 | 2 | 1 | 1 | 10 |
| 5–6 | 3 | 2 | 2 | 3 | 1 | 1 | 12 |

### Task contract summary
| Task | Prompt text | Reward | Hold |
| --- | --- | ---: | ---: |
| Restock Shelf | Hold to restock shelf | $14 | 1.5s |
| Clean Spill | Hold to mop spill | $18 | 1.8s |
| Take Out Trash | Hold to haul trash bag out back | $16 | 1.4s |
| Return Cart | Hold to return cart to corral | $12 | 1.0s |
| Check Freezer | Hold to inspect freezer alarm | $20 | 1.6s |
| Close Register | Hold to count drawer and lock register | $24 | 2.2s |

### Event rules
- **Blackout** happens once per round.
- Blackout triggers at a random time between **300 and 240 seconds remaining**.
- Blackout duration is **10 seconds**.
- During blackout, players may finish a task hold they already started, but they cannot start a new task interaction until power returns.
- While blackout is active, task prompts stay visible but are disabled and show blackout-specific text.
- **Mimic / false task** can happen once per round.
- Mimic becomes eligible between **180 and 135 seconds remaining**, only if at least **3 real tasks** are still unfinished and blackout is not active.
- Mimic can target any active non-register task node.
- If triggered, mimic applies a small time hit and a personal cash penalty, but never an instant fail.

### Payout model
- Cash is awarded at round end, not instantly per task.
- Each completed real task adds its reward value to the shift's base pay.
- On success, every active player receives **full base pay + $35 shift clear bonus**.
- On failure, every active player receives **60% of base pay**, rounded down, with **no clear bonus**.
- Any mimic penalty is deducted only from the player who triggered it, and payout never goes below $0.

### Anti-frustration rules
- Failure still pays partial cash so a rough round is not a total waste.
- There is at most **one blackout** and **one mimic** per round.
- Mimic cannot target **Close Register** and cannot appear during the last endgame stretch.
- Solo players get a smaller task quota than full groups.
- Punishments add pressure through short time loss, temporary denial, and cash loss rather than chain-death systems.

## Sprint 2 clarity-and-feel contract

### Tutorial / onboarding
- Sprint 2 uses a **4-step, non-modal tutorial** shown once per client session, only for players who are part of a round-start roster.
- Tutorial teaching priorities are locked to:
  1. finish the checklist before time runs out
  2. follow highlighted work and hold to interact
  3. understand that task cash is banked until the shift ends
  4. understand that **Close Register** unlocks last and ends the shift
- Late joiners during `Playing` or `Ended` do **not** receive tutorial steps for that live round. They stay in a wait-for-next-shift HUD state and begin the tutorial on the next intermission they are eligible to play.
- Blackout and mimic are taught reactively with short alert copy when they matter instead of front-loading extra tutorial text.

### HUD readability and message hierarchy
- The HUD remains a single compact top-left panel built for a **260–360 px** phone-safe width.
- Required blocks, in order, are: state, timer, saved cash, earnings, objectives, alert.
- **Earnings** should use short labeled lines rather than a long sentence:
  - `Banked: $X`
  - `Clear: $Y | Timeout: $Z`
  - add `False task: -$N` only when the local player has a penalty
- **Objectives** should fit inside **3 short lines** and always show register state as `locked`, `ready`, or `closed`.
- The HUD uses **one alert slot only**. Alerts do not stack into a scrolling feed.
- Alert priority is locked to:
  1. wait-for-next-shift / blackout active / round result
  2. register unlocked / blackout restored
  3. tutorial step / round-start hint
  4. ambient state text when no higher-priority alert is active

### Task readability and feedback
- Any real task node with remaining quota greater than 0 must read as active at a glance through a visible highlight or beacon.
- A completed or cooling-down node must visibly downgrade so players do not path toward dead work.
- **Close Register** stays visually distinct from normal tasks in both states:
  - locked: subdued highlight + locked prompt text
  - unlocked: strongest highlight in the room + unlock alert + unlock cue
- Completing a real task must update objective counts and projected payout immediately, paired with a short positive visual confirmation and local completion cue.
- During blackout, task prompts stay visible but disabled, and active highlights dim rather than disappear so players keep orientation.

### Blackout / mimic presentation
- **Blackout** is a clearly announced global state with a start cue, pinned alert while active, and a restore cue when power returns.
- **Mimic** is **not** globally announced when it spawns; Sprint 2 keeps the deception. Clarity comes from stronger feedback on trigger:
  - urgent alert that explains time and pay were lost
  - distinct trap audio sting
  - visible locked-node recovery state on the trapped task
- Mimic expiry without trigger stays silent in Sprint 2 to avoid noise and accidental false teaching.

### Round-end explanation
- The round-end HUD must explain payout using the player's actual numbers, not flavor text alone.
- Success summary shows:
  - shift cleared
  - tasks completed
  - banked pay
  - `+$35` clear bonus
  - optional personal false-task deduction
  - final cash added
- Failure summary shows:
  - shift failed
  - tasks completed
  - banked pay
  - `60%` payout conversion
  - optional personal false-task deduction
  - final cash added
- Late joiners who were excluded from the round do not receive a payout summary for that round.

### No-regression guardrail
- Sprint 2 improves communication, readability, and presentation without changing the locked Sprint 1 rules for round length, intermission, quota bundles, payout math, blackout timing/duration, or mimic timing/consequences.

## Failure / tension model
- Tension comes from the timer, a mid-round blackout, and a single deceptive mimic prompt.
- The player should feel pressure without losing an entire run to one mistake.
- Sprint 1 avoids revive, stamina, or persistent injury systems.

## MVP monetization boundaries
Acceptable:
- cosmetics
- emotes
- flashlight skins
- private server
- extra loadout slots
- optional revive as a limited dev product

Avoid at MVP:
- heavy pay-to-win combat boosts
- multi-currency confusion
- deep stat grinds

## Future expansions
- new store types
- roaming manager enemy
- revive loop
- seasonal events
- social progression / badges

## Open questions
- exact asset list and sourcing path for the Sprint 2 UI / event cues
- whether post-Sprint 2 playtests still need a stronger pre-trigger mimic tell
- when tutorial completion should become persistent once save-backed progression exists
