# Engineering handoff

Use this file when design has a concrete implementation brief for engineering.

## Objective
Implement Sprint 3's alpha return loop without destabilizing the ready Sprint 1 + Sprint 2 baseline.

Locked Sprint 3 scope only:
- `Security Alarm`
- persistent `XP` / `Level`
- simple non-playing cosmetic shop with persistent purchase/equip state
- KPI / analytics + structured log contract

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/KPI-CANDIDATES-S3.md`
- `project/docs/SPRINT3-PLAN.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Files to edit
Expected engineering touch points are likely under:
- `project/src/ServerScriptService/**`
- `project/src/ReplicatedStorage/**`
- `project/src/StarterGui/**`
- `project/src/StarterPlayer/**`
- `project/scripts/**` if a smoke/runtime harness needs Sprint 3 coverage

Do not widen scope beyond the locked Sprint 3 contract in this file.

## Non-goals / do not add
- no NPCs
- no chase/combat
- no second map
- no revive system
- no stamina or movement buffs
- no payout multipliers from progression
- no Robux rollout
- no subscriptions / battle pass / daily quests
- no broader inventory beyond the 2 slots below

---

## 1) `Security Alarm` implementation contract

### Core event rules
| Item | Locked rule |
|---|---|
| Event id | `security_alarm` |
| Max per round | 1 |
| Trigger roll at round start | random threshold from **165 to 125 seconds remaining** |
| Pending begins | once remaining time is at or below the rolled threshold |
| Start gates | round state `Playing`; alarm not consumed; blackout not active; no active mimic node; `Close Register` not yet unlocked; at least 1 non-register task still remains |
| Cancel without firing | if round ends, `Close Register` is completed, or remaining time drops below **45** before legal start |
| Active countdown | **15.0s** |
| Hold duration | **2.0s** |
| Fail penalty | **-12s** shared round timer, once |
| Cash penalty | none |
| Damage / health | none |

### Overlap / priority rules
Implement these exactly:
- `Security Alarm` cannot start during blackout.
- `Security Alarm` cannot start while a mimic node is active.
- While `Security Alarm` is active:
  - blackout start is deferred
  - mimic spawn is deferred
  - `Close Register` unlock is deferred
- If players complete the final non-register task during an active alarm, do **not** unlock register until the alarm resolves/fails.
- If the alarm is pending but never finds a legal window before 45 seconds remaining, mark it consumed/canceled for the round and move on.

### Success / fail edge handling
- Success only counts if the server receives the completed prompt trigger before the 15.0s deadline.
- Starting the hold before timeout does **not** guarantee success if the hold completes after the deadline.
- First successful resolver wins the event.
- After success or fail, the node becomes non-interactable for the rest of the round.
- Late joiners remain excluded from active-round participation and must not be able to resolve the alarm during `Playing`.

### Node contract
Create a dedicated event node:
- folder: `Workspace.EventNodes`
- part name: `security_panel_node`

Required attributes / identifiers:
- `NodeId = "security_panel_node"`
- `EventId = "security_alarm"`
- `FeedbackState` string
- `PromptEnabled` boolean

Required `FeedbackState` enum values:
- `security_idle`
- `security_active`
- `security_resolved`
- `security_failed`

### Node presentation / copy contract
| Surface | Exact value |
|---|---|
| Object text | `Security Panel` |
| Action text while active | `Reset Alarm` |
| Start alert id | `security_alarm_active` |
| Start alert text | `Security Alarm. Reset the front panel.` |
| Start cue id | `security_alarm_start` |
| Success alert id | `security_alarm_reset` |
| Success alert text | `Alarm reset. Keep closing.` |
| Success cue id | `security_alarm_reset` |
| Fail alert id | `security_alarm_failed` |
| Fail alert text | `Alarm missed. Lost 12 seconds.` |
| Fail cue id | `security_alarm_fail` |

### Recommended round-state fields
Use or mirror a server-owned round slice with these exact meanings:
- `securityAlarmTriggerRemaining`
- `securityAlarmPending`
- `securityAlarmActive`
- `securityAlarmEndsAt`
- `securityAlarmConsumed`
- `securityAlarmState` (`idle|active|resolved|failed|canceled` internally is fine)
- `securityAlarmResolvedByUserId` (nullable)

Exact internal naming can differ, but the behavior above may not.

---

## 2) Persistence / profile contract

### Profile schema
Sprint 3 persistent profile must include these fields:

```lua
{
  ProfileVersion = 1,
  Cash = 0,
  XP = 0,
  Level = 1,
  ShiftsPlayed = 0,
  ShiftsCleared = 0,
  OwnedCosmetics = {
    nameplate_standard_issue = true,
    lanyard_gray_clip = true,
  },
  EquippedCosmetics = {
    NameplateStyle = "nameplate_standard_issue",
    LanyardColor = "lanyard_gray_clip",
  },
}
```

### Source-of-truth rules
- `XP` is the source of truth for `Level`.
- Recompute `Level` from `XP` whenever XP changes or a migrated profile loads.
- If a loaded profile has a `Level` mismatch, trust `XP`, repair `Level`, and save on the next normal save opportunity.
- `OwnedCosmetics` is a dictionary keyed by item id.
- `EquippedCosmetics` is keyed by slot name and may only contain a valid owned item for that slot.

### Level thresholds
| Level | Total XP required |
|---|---:|
| 1 | 0 |
| 2 | 20 |
| 3 | 45 |
| 4 | 75 |
| 5 | 110 |
| 6 | 150 |

Sprint 3 behavior above Level 6:
- keep saving total `XP`
- clamp unlock/display checks to `Level 6`
- no extra Sprint 3 unlocks beyond that

### XP award rules
| Source | Award | Recipient |
|---|---:|---|
| real non-register task completion | +2 XP | acting player only |
| `Close Register` completion | +4 XP | acting player only |
| `Security Alarm` reset | +4 XP | resolver only |
| shift clear bonus | +10 XP | each round-start player still present at round resolution |
| shift fail consolation | +4 XP | each round-start player still present at round resolution |

Explicit non-awards:
- no XP loss from mimic
- no XP loss from alarm fail
- no direct XP for blackout alone
- no active-round XP for late joiners excluded from the roster

### Shift counters
- `ShiftsPlayed`: increment once for every player in the round-start roster
- `ShiftsCleared`: increment on successful clear for round-start players still present at round resolution

### Save timing contract
To avoid noisy writes and unclear persistence behavior:
- load profile on `PlayerAdded`
- save after round-resolution reward commit (cash + XP + counters)
- save immediately after successful purchase
- save immediately after equip change
- save on `PlayerRemoving`
- do **not** write a datastore on every single task completion tick; accumulate round XP in memory and commit at round resolution unless a profile-leave path forces a save

### Migration rule
If a legacy or partial profile exists:
- preserve any existing saved `Cash`
- fill missing Sprint 3 fields with the defaults above
- inject the default owned/equipped cosmetics if absent
- normalize invalid equipped ids back to the default item for that slot

---

## 3) Shop v1 implementation contract

### Shop access
- The shop is usable only in non-playing states.
- Do not allow purchase or equip actions during `Playing`.
- The results flow may link into the same non-playing shop UI after payout.

### Slots
Exactly these two slots:
- `NameplateStyle`
- `LanyardColor`

### Catalog
Implement exactly these six paid items:

| itemId | Display name | Slot | Price | Required level | Flavor copy |
|---|---|---|---:|---:|---|
| `clean_shift` | Clean Shift | `NameplateStyle` | 40 | 1 | Fresh laminated badge for a dependable closer. |
| `retro_plastic` | Retro Plastic | `NameplateStyle` | 80 | 3 | Old store plastic with worn late-night charm. |
| `neon_night` | Neon Night | `NameplateStyle` | 120 | 5 | Electric edge trim that reads from across the lobby. |
| `blue_id` | Blue ID | `LanyardColor` | 50 | 1 | Calm blue strap for routine night shifts. |
| `red_id` | Red ID | `LanyardColor` | 75 | 2 | Loud red strap that stands out fast. |
| `gold_id` | Gold ID | `LanyardColor` | 100 | 4 | Gold trim for proven overnight staff. |

### Action priority
When the player presses the primary action on an item, resolve in this exact order:
1. if item is already equipped -> no-op
2. else if item is already owned -> equip it
3. else if player level is below requirement -> deny for level
4. else if player cash is below price -> deny for funds
5. else -> purchase succeeds

### Purchase / equip rules
- purchase adds the item permanently to `OwnedCosmetics`
- purchase does **not** auto-equip
- equip swaps the current equipped item for that slot only
- players may always re-equip their default item
- no sell / refund / gift / duplicate purchase logic in Sprint 3
- no empty-slot unequip state in Sprint 3

### Exact UI copy
| State | Exact copy |
|---|---|
| Buy button | `Buy for $<price>` |
| Level gate badge | `Requires Level <level>` |
| Insufficient level denial | `Employee Rank too low. Reach Level <level>.` |
| Insufficient funds denial | `Not enough Cash. Finish another shift.` |
| Owned / equip action | `Owned — Equip` |
| Equipped | `Equipped` |

### QA-visible representation
Keep this UI-first and light:
- lobby shop preview must visibly show current `NameplateStyle` and `LanyardColor`
- post-round results card for the local player must show the same equipped style/color
- 2D representation is sufficient
- 3D accessory meshes are not required for Sprint 3

---

## 4) Cash / XP / level UX contract

The player must be able to understand the difference without guessing.

Exact plain-language rule to surface in UI/help text where appropriate:
- `Cash buys cosmetics. XP raises Employee Rank. Rank unlocks cosmetics only.`

Required display surfaces:
- lobby / shop header: show `Cash`, `Level`, and current XP progress
- results summary: show `Cash earned`, `XP earned`, `current Level`, and any unlock-relevant change
- waiting / late-join state: still show persistent `Cash` and `Level`

What progression must **not** change:
- movement speed
- stamina
- health
- damage
- revive access
- task hold times
- timer length
- blackout timing
- mimic timing
- payout multipliers

---

## 5) Analytics and structured log contract

### Canonical event names
Emit these exact snake_case events. Do not rename them across code paths.

#### Profile / funnel
- `profile_loaded`
- `onboarding_shown`
- `onboarding_completed`
- `shift_started`
- `first_task_completed`
- `results_shown`
- `shift_success`
- `shift_failure`

#### Existing event coverage
- `blackout_seen`
- `mimic_spawned`
- `mimic_triggered`
- `mimic_expired`

#### New Sprint 3 event coverage
- `security_alarm_seen`
- `security_alarm_reset`
- `security_alarm_failed`

#### Shop / economy coverage
- `shop_opened`
- `shop_purchase_denied`
- `shop_purchase_succeeded`
- `cosmetic_equipped`

### Common field contract
Every emitted event should include at least:
- `user_id`
- `server_job_id`
- `round_id` (use `null`/omit only for true lobby-only events if necessary)
- `ts_unix`

### Event-specific minimum fields
| Event | Required extra fields |
|---|---|
| `profile_loaded` | `profile_version`, `cash`, `xp`, `level`, `owned_cosmetic_count` |
| `shift_started` | `party_size`, `level`, `cash` |
| `first_task_completed` | `task_id`, `seconds_elapsed` |
| `shift_success` | `party_size`, `remaining_seconds`, `cash_awarded`, `xp_awarded` |
| `shift_failure` | `party_size`, `remaining_seconds`, `cash_awarded`, `xp_awarded` |
| `blackout_seen` | `remaining_seconds` |
| `mimic_spawned` | `node_id`, `remaining_seconds` |
| `mimic_triggered` | `node_id`, `trigger_user_id`, `timer_penalty_seconds`, `cash_penalty` |
| `mimic_expired` | `node_id` |
| `security_alarm_seen` | `node_id`, `remaining_seconds`, `response_window_seconds` |
| `security_alarm_reset` | `node_id`, `resolver_user_id`, `seconds_left`, `response_time_seconds` |
| `security_alarm_failed` | `node_id`, `timer_penalty_seconds` |
| `results_shown` | `outcome`, `cash_total`, `xp_total`, `level` |
| `shop_opened` | `entry_point` |
| `shop_purchase_denied` | `item_id`, `slot_id`, `deny_reason`, `required_level`, `price_cash`, `player_level`, `player_cash` |
| `shop_purchase_succeeded` | `item_id`, `slot_id`, `price_cash`, `required_level`, `cash_before`, `cash_after` |
| `cosmetic_equipped` | `item_id`, `slot_id`, `previous_item_id` |

Locked denial reasons:
- `insufficient_level`
- `insufficient_cash`

### Structured log fallback
If dashboard analytics lag, emit a structured log line for every required event path using this pattern:

```text
[analytics] <event_name> <json-payload>
```

Example:

```text
[analytics] security_alarm_reset {"user_id":123,"round_id":"r-17","node_id":"security_panel_node","seconds_left":6.4}
```

QA can accept this local/server log evidence if the exact event name and required fields are present.

### Derived metric note
`second_shift_started` is a KPI concept, not a required emitted event. Derive it from the player's second `shift_started` in the same play session.

---

## Acceptance criteria
Engineering implementation is complete for design handoff purposes when all of the below are true:
- `Security Alarm` exists as a once-per-round event with the exact timing, hold, overlap, and fail rules above.
- `Security Alarm` uses `security_panel_node` and the locked alert/cue naming.
- `Security Alarm` cannot overlap blackout or active mimic, and register unlock is deferred while alarm is active.
- Player profiles persist `Cash`, `XP`, `Level`, `ShiftsPlayed`, `ShiftsCleared`, `OwnedCosmetics`, `EquippedCosmetics`, and `ProfileVersion`.
- The exact six paid cosmetic items exist, using the exact two slots and exact level/price rules above.
- Purchase denial reasons are unambiguous and use the locked copy / reason names.
- Purchase and equip state both persist across leave/rejoin.
- Cosmetics are visibly testable in lobby/results UI without relying on imagination.
- The exact analytics event names above are emitted, or at minimum mirrored in structured log output with the required fields.
- Sprint 1 / Sprint 2 behavior remains intact for blackout, mimic, payout, onboarding, and late-join exclusion.
