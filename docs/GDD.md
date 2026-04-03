# Closing Shift: Superstore 3AM — GDD

## One-line pitch
A 1–6 player co-op Roblox horror job sim where players close a supermarket at 3AM, survive paranormal disruptions, earn persistent `Cash` and Employee Rank, and spend saved `Cash` on simple visible cosmetics.

## Design pillars
1. **Instantly readable** — a player should understand the fantasy in under 10 seconds.
2. **Short tense rounds** — sessions stay compact and replayable.
3. **Co-op chaos** — small mistakes create funny or scary moments with friends.
4. **Return loop without power creep** — players should want another shift because of rank and style, not stat buffs.
5. **Scope discipline** — one map, a small event set, and a tiny shop before any larger expansion.

## Target session
- Players: 1–6
- Round length target: short, replayable alpha sessions
- Intermission: 15–20 seconds target
- Goal: complete the task list, survive the event stack, and close the register before time runs out

## Current alpha feature set
- Lobby + one playable grocery store
- Task system
  - restock shelves
  - clean spills
  - take out trash
  - return carts
  - check freezer
  - close register
- Round manager
- Event stack
  - blackout
  - mimic / false task
  - security alarm
- End-of-round results and payout
- Persistent profile
  - `Cash`
  - `XP`
  - `Level`
  - `ShiftsPlayed`
  - `ShiftsCleared`
  - `OwnedCosmetics`
  - `EquippedCosmetics`
  - `ProfileVersion`
- Lobby cosmetic shop v1
- HUD and round alerts
- KPI / structured logging contract for Sprint 3

## Failure / tension model
- Players are under shared time pressure.
- Events create urgency, confusion, or movement pressure.
- Failure should feel tense, not brutal enough to kill replayability.
- Sprint 3 keeps the punishment readable:
  - blackout blocks new interactions briefly
  - mimic hits the triggering player and shared timer
  - security alarm hits the shared timer only if ignored

## Sprint 3 locked alpha return loop

### 1) New event — `Security Alarm`

**Design intent**
- create a readable front-of-store panic beat
- work in solo and co-op
- create movement without introducing NPCs or combat
- add urgency without damage, death chains, or cash loss

#### Security Alarm contract
| Item | Locked rule |
|---|---|
| Event id | `security_alarm` |
| World node | `security_panel_node` |
| Node folder | `Workspace.EventNodes` |
| Max fires per round | 1 |
| Trigger roll | roll once at round start: random threshold from **165 to 125 seconds remaining** |
| Pending state begins | when round timer first reaches the rolled threshold or below |
| Start gates | round is `Playing`; alarm not yet consumed; blackout not active; no mimic node is currently active; `Close Register` is still locked; at least 1 non-register task still remains |
| Cancel without firing | if the round ends, `Close Register` becomes completed, or time falls below **45 seconds remaining** before the alarm actually starts |
| Active countdown | **15.0 seconds** |
| Panel hold duration | **2.0 seconds** |
| Success rule | the server must receive the completed hold before the 15.0 second deadline; starting a hold before the deadline does **not** reserve success if the hold finishes late |
| Success outcome | event ends immediately; no timer penalty; no cash penalty; no damage; resolver gets **+4 XP** |
| Failure outcome | when the 15.0 second window expires unresolved, apply **-12 seconds** to the shared round timer exactly once; no cash penalty; no damage |
| Player count behavior | first successful trigger resolves it; extra simultaneous holds are ignored once resolved |
| Late-join behavior | late joiners stay excluded from active-round participation and cannot resolve the alarm during `Playing` |

#### Overlap and priority rules
- `Security Alarm` can never be active at the same time as **blackout**.
- `Security Alarm` can never start while any **mimic** node is active.
- While `Security Alarm` is active:
  - blackout cannot start
  - mimic cannot spawn
  - `Close Register` cannot unlock mid-alarm
- If the final non-register task is completed during the alarm window, register unlock is **deferred** until the alarm resolves or fails.
- If blackout or mimic is already blocking the start when the alarm becomes pending, the alarm waits in pending state until the block clears or until the cancel rule is hit.

#### Player-facing copy and cues
| Surface | Exact copy / id |
|---|---|
| Start alert id | `security_alarm_active` |
| Start alert text | `Security Alarm. Reset the front panel.` |
| Start cue id | `security_alarm_start` |
| Panel object text | `Security Panel` |
| Panel action text while active | `Reset Alarm` |
| Success alert id | `security_alarm_reset` |
| Success alert text | `Alarm reset. Keep closing.` |
| Success cue id | `security_alarm_reset` |
| Fail alert id | `security_alarm_failed` |
| Fail alert text | `Alarm missed. Lost 12 seconds.` |
| Fail cue id | `security_alarm_fail` |

#### Node state model
`security_panel_node` uses these exact `FeedbackState` values:
- `security_idle` — default before the event fires; prompt disabled
- `security_active` — alarm live; prompt enabled; red/high-urgency presentation
- `security_resolved` — alarm was reset successfully; prompt disabled for the rest of the round
- `security_failed` — alarm timed out; prompt disabled for the rest of the round

No additional Sprint 3 alarm states are required.

### 2) Progression v1 — `Employee Rank`

**Design intent**
- give players a persistent reason to replay
- keep progression readable in one glance
- avoid any gameplay buff that distorts the Sprint 1/2 balance

#### Persistent profile fields
Sprint 3 profile data must include:
- `ProfileVersion`
- `Cash`
- `XP`
- `Level`
- `ShiftsPlayed`
- `ShiftsCleared`
- `OwnedCosmetics`
- `EquippedCosmetics`

#### Source-of-truth rules
- `Cash` is persistent soft currency and is spent in the shop.
- `XP` is persistent career progress and is **never** spent.
- `Level` is saved for quick display, but `XP` is the source of truth if a profile mismatch is found.
- `OwnedCosmetics` is a dictionary keyed by cosmetic `itemId`.
- `EquippedCosmetics` is a dictionary keyed by slot name.

#### XP earn rules
| Source | Award | Recipient |
|---|---:|---|
| Any real non-register task completion | +2 XP | acting player only |
| `Close Register` completion | +4 XP | acting player only |
| `Security Alarm` reset | +4 XP | resolver only |
| Shift clear bonus | +10 XP | each round-start player still present at round resolution |
| Shift fail consolation | +4 XP | each round-start player still present at round resolution |

#### Progression rules
- mimic does **not** remove saved XP
- blackout gives no direct XP by itself
- security alarm failure removes time only; it does **not** remove saved XP
- late joiners do not earn Sprint 3 XP until the next round they start in the round-start roster
- `ShiftsPlayed` increments once for each player in the round-start roster
- `ShiftsCleared` increments on successful clear for round-start players who are still present when the round resolves

#### Level thresholds
| Level | Total XP required |
|---|---:|
| 1 | 0 |
| 2 | 20 |
| 3 | 45 |
| 4 | 75 |
| 5 | 110 |
| 6 | 150 |

#### Level cap rule
- Sprint 3 ships with a displayed unlock cap of **Level 6**.
- `XP` may continue to save above 150 for forward compatibility.
- Sprint 3 unlock checks treat any `XP >= 150` player as `Level 6`.
- Sprint 3 grants no additional unlocks or gameplay effects above Level 6.

#### Where progression is displayed
- lobby header / shop header
- post-round results summary
- waiting / late-join state where the player can still see their current `Level` and `Cash`

#### What progression affects
- cosmetic unlock requirements only
- player identity / status display only

#### What progression does **not** affect
- move speed
- stamina
- health
- damage
- revive access
- task hold times
- event timings
- cash payout multipliers
- success / failure formulas

#### Cash vs XP explanation
Use this exact plain-language rule in UX copy or help text:
- `Cash buys cosmetics. XP raises Employee Rank. Rank unlocks cosmetics only.`

### 3) Cosmetic shop v1

**Design intent**
- turn saved `Cash` into a visible reward loop
- keep the first shop tiny and QA-visible
- avoid inventory sprawl and mid-round distraction

#### Shop access rule
- Shop is available only in non-playing states.
- It is never usable during `Playing`.
- The post-round results flow may include a CTA into the same non-playing shop UI after payout.

#### Cosmetic slots
Sprint 3 uses exactly these two equip slots:
1. `NameplateStyle`
2. `LanyardColor`

#### Default owned items
These items are always owned on profile creation / migration:
- `nameplate_standard_issue`
- `lanyard_gray_clip`

Default equipped state on a fresh profile:
- `EquippedCosmetics.NameplateStyle = "nameplate_standard_issue"`
- `EquippedCosmetics.LanyardColor = "lanyard_gray_clip"`

#### Starter sellable catalog
| itemId | Display name | Slot | Price (`Cash`) | Required level | Flavor copy |
|---|---|---|---:|---:|---|
| `clean_shift` | Clean Shift | `NameplateStyle` | 40 | 1 | Fresh laminated badge for a dependable closer. |
| `retro_plastic` | Retro Plastic | `NameplateStyle` | 80 | 3 | Old store plastic with worn late-night charm. |
| `neon_night` | Neon Night | `NameplateStyle` | 120 | 5 | Electric edge trim that reads from across the lobby. |
| `blue_id` | Blue ID | `LanyardColor` | 50 | 1 | Calm blue strap for routine night shifts. |
| `red_id` | Red ID | `LanyardColor` | 75 | 2 | Loud red strap that stands out fast. |
| `gold_id` | Gold ID | `LanyardColor` | 100 | 4 | Gold trim for proven overnight staff. |

#### Ownership and equip rules
- one equipped item per slot
- purchase permanently adds the item to `OwnedCosmetics`
- purchase does **not** auto-equip
- selecting an owned, unequipped item equips it immediately and unequips the prior item in that same slot
- selecting an already equipped item does nothing
- players can always switch back to the default owned item for that slot
- Sprint 3 does **not** support selling, refunding, gifting, duplicate ownership, or empty-slot unequip

#### Purchase decision priority
When a player presses the primary shop action on an item, resolve in this exact order:
1. if item is already equipped: no-op
2. else if item is already owned: equip it
3. else if player level is below requirement: deny for level
4. else if player `Cash` is below price: deny for funds
5. else: purchase succeeds

#### Exact UI state copy
| State | Exact copy |
|---|---|
| Buy button | `Buy for $<price>` |
| Locked by level | `Requires Level <level>` |
| Insufficient level denial | `Employee Rank too low. Reach Level <level>.` |
| Insufficient funds denial | `Not enough Cash. Finish another shift.` |
| Owned / ready to equip | `Owned — Equip` |
| Equipped | `Equipped` |

#### QA-visible representation rule
Sprint 3 cosmetics must be verifiable in simple UI, not heavy character art.

Required visibility:
- **Lobby shop preview**: shows current `NameplateStyle` frame and `LanyardColor` swatch/strap treatment
- **Post-round results card**: shows the same equipped `NameplateStyle` and `LanyardColor` for the local player

Sprint 3 does **not** require 3D accessory meshes, avatar rig changes, or first-person cosmetic rendering.

### 4) Instrumentation contract

#### Canonical event naming rule
- Use exact snake_case event names.
- Do not invent parallel aliases for the same action.
- If dashboard data lags, structured local/server log lines using the same exact event names are acceptable alpha proof.

#### Required Sprint 3 event coverage
- `profile_loaded`
- `onboarding_shown`
- `onboarding_completed`
- `shift_started`
- `first_task_completed`
- `shift_success`
- `shift_failure`
- `blackout_seen`
- `mimic_spawned`
- `mimic_triggered`
- `mimic_expired`
- `security_alarm_seen`
- `security_alarm_reset`
- `security_alarm_failed`
- `results_shown`
- `shop_opened`
- `shop_purchase_denied`
- `shop_purchase_succeeded`
- `cosmetic_equipped`

#### Minimum proof rule
Sprint 3 analytics work counts as implemented when all three are true:
1. the exact event names are documented and wired
2. the code emits structured logs or equivalent local evidence for each required path
3. QA can map runtime behavior to the emitted event names and fields without guesswork

## MVP monetization boundaries
Acceptable in or after alpha:
- cosmetics
- emotes
- flashlight skins
- private server

Not in Sprint 3:
- Robux shop rollout
- subscriptions
- battle pass / season pass
- pay-to-win power boosts
- revive monetization
- multi-currency expansion

## Future expansions
- new store types
- roaming manager enemy
- revive loop
- seasonal events
- broader cosmetic inventory once the 2-slot loop is proven

## Open questions intentionally closed for Sprint 3
- Sprint 3 does **not** add stamina.
- Sprint 3 does **not** add combat or chase behavior.
- Sprint 3 does **not** add gameplay buffs from progression.
- Sprint 3 does **not** expand beyond the two cosmetic slots listed above.
