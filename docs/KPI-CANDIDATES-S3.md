# Sprint 3 KPI candidates

Use this document to keep Sprint 3 analytics scoped and consistent.

## Sprint 3 analytics rule
Sprint 3 uses one canonical custom-event namespace: exact snake_case event names.

If dashboard propagation is delayed, the sprint can still pass if:
- the exact event names in this document are implemented,
- structured local/server logs show the same names and required fields,
- QA can map runtime behavior to those events without guesswork.

## Primary product questions
1. After one completed shift, do players have a clearer reason to start another one?
2. Do players understand that `Cash` buys cosmetics while `XP` and `Level` unlock them?
3. Does `Security Alarm` create urgency without feeling unfair or noisy next to blackout and mimic?
4. Can players successfully buy and equip a cosmetic item and still see it after rejoin?

## Canonical event names

### Profile / onboarding / shift funnel
- `profile_loaded`
- `onboarding_shown`
- `onboarding_completed`
- `shift_started`
- `first_task_completed`
- `results_shown`
- `shift_success`
- `shift_failure`

### Event coverage
- `blackout_seen`
- `mimic_spawned`
- `mimic_triggered`
- `mimic_expired`
- `security_alarm_seen`
- `security_alarm_reset`
- `security_alarm_failed`

### Shop / economy coverage
- `shop_opened`
- `shop_purchase_denied`
- `shop_purchase_succeeded`
- `cosmetic_equipped`

## Common field contract
Every event should include at least:
- `user_id`
- `server_job_id`
- `round_id` (omit or null only for true lobby-only events if necessary)
- `ts_unix`

## Event-specific required fields
| Event | Required fields beyond the common contract |
|---|---|
| `profile_loaded` | `profile_version`, `cash`, `xp`, `level`, `owned_cosmetic_count` |
| `shift_started` | `party_size`, `level`, `cash` |
| `first_task_completed` | `task_id`, `seconds_elapsed` |
| `results_shown` | `outcome`, `cash_total`, `xp_total`, `level` |
| `shift_success` | `party_size`, `remaining_seconds`, `cash_awarded`, `xp_awarded` |
| `shift_failure` | `party_size`, `remaining_seconds`, `cash_awarded`, `xp_awarded` |
| `blackout_seen` | `remaining_seconds` |
| `mimic_spawned` | `node_id`, `remaining_seconds` |
| `mimic_triggered` | `node_id`, `trigger_user_id`, `timer_penalty_seconds`, `cash_penalty` |
| `mimic_expired` | `node_id` |
| `security_alarm_seen` | `node_id`, `remaining_seconds`, `response_window_seconds` |
| `security_alarm_reset` | `node_id`, `resolver_user_id`, `seconds_left`, `response_time_seconds` |
| `security_alarm_failed` | `node_id`, `timer_penalty_seconds` |
| `shop_opened` | `entry_point` |
| `shop_purchase_denied` | `item_id`, `slot_id`, `deny_reason`, `required_level`, `price_cash`, `player_level`, `player_cash` |
| `shop_purchase_succeeded` | `item_id`, `slot_id`, `price_cash`, `required_level`, `cash_before`, `cash_after` |
| `cosmetic_equipped` | `item_id`, `slot_id`, `previous_item_id` |

### Locked shop denial reasons
- `insufficient_level`
- `insufficient_cash`

## Locked funnels

### Onboarding funnel
1. `profile_loaded`
2. `onboarding_shown`
3. `onboarding_completed`
4. `shift_started`
5. `first_task_completed`
6. `shift_success` or `shift_failure`

### Return-loop funnel
1. `results_shown`
2. `shop_opened`
3. `shop_purchase_succeeded`
4. `cosmetic_equipped`
5. next `shift_started`

**Important:** `second_shift_started` is a KPI concept derived from the player's second `shift_started` in the same play session. It is **not** a separate required emitted event name.

## Candidate KPIs

### Retention / progression
- first-session shift completion rate
- first-session next-shift start rate
- percentage of players who gain XP in session
- percentage of players who reach Level 2 in session
- percentage of returning players with a persisted profile (`profile_loaded` with non-default state)

### Economy / shop
- shop-open rate after `results_shown`
- purchase conversion rate among players who had enough `Cash`
- equip rate after successful purchase
- insufficient-funds denial count
- insufficient-level denial count
- percentage of purchased items still equipped after rejoin

### Event readability
- `Security Alarm` seen rate
- `Security Alarm` reset rate
- `Security Alarm` fail rate
- average time-to-reset alarm
- mimic trigger rate
- blackout seen rate
- QA frustration notes per event type

## Minimum proof required for the Sprint 3 gate
QA should expect proof for these paths at minimum:
- one `profile_loaded`
- one `shift_started`
- one `first_task_completed`
- one `results_shown`
- one `security_alarm_seen`
- either one `security_alarm_reset` or one `security_alarm_failed`
- one `shop_opened`
- one `shop_purchase_succeeded`
- one `cosmetic_equipped`
- one leave/rejoin proof where the profile still shows owned/equipped state

## Structured log fallback format
If dashboard data lags, the runtime/log proof should use this exact shape:

```text
[analytics] <event_name> <json-payload>
```

Example acceptable proof lines:

```text
[analytics] shop_purchase_succeeded {"user_id":123,"item_id":"blue_id","slot_id":"LanyardColor","cash_before":90,"cash_after":40}
[analytics] cosmetic_equipped {"user_id":123,"item_id":"blue_id","slot_id":"LanyardColor","previous_item_id":"lanyard_gray_clip"}
```
