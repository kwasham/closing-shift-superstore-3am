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
- exact cosmetic price curve once Sprint 1 payout data exists
- whether future horror events should use health damage, sanity, or pure objective pressure
- how much visual tell the mimic prompt should have after first internal playtests
