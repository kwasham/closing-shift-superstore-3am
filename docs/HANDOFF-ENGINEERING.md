# Engineering handoff

## Objective
Implement the Sprint 1 playable round loop for **Closing Shift: Superstore 3AM** using exact task, event, payout, and anti-frustration rules that fit the locked MVP scope.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT.md`

## Files to edit
- `project/src/**`
- `project/scripts/smoke_runner.lua` if needed

## Core implementation note
The current scaffold values in code are placeholder numbers. Engineering should update constants/config to match this handoff rather than the current temporary defaults.

## 1) Task contract table

### Shared task rules
- Each completed **real** task adds its reward to the round's **base pay bank**.
- Rewards are **not** granted instantly to leaderstats; they are awarded at round end.
- If the map has fewer physical task nodes than the quota requires, completed nodes may be **reused after a 6-second cooldown** while that category still has remaining quota.
- `Close Register` never respawns in the same round.

| Task id | Name | Player-facing prompt text | Reward | Hold duration | Special note |
| --- | --- | --- | ---: | ---: | --- |
| `restock_shelf` | Restock Shelf | Hold to restock shelf | $14 | 1.5s | Can be required multiple times per round. On complete, decrement restock quota by 1. |
| `clean_spill` | Clean Spill | Hold to mop spill | $18 | 1.8s | On complete, decrement spill quota by 1 and clear the spill hazard/visual. |
| `take_out_trash` | Take Out Trash | Hold to haul trash bag out back | $16 | 1.4s | On complete, decrement trash quota by 1. |
| `return_cart` | Return Cart | Hold to return cart to corral | $12 | 1.0s | Fastest movement task; can be required multiple times per round. |
| `check_freezer` | Check Freezer | Hold to inspect freezer alarm | $20 | 1.6s | Only 1 completion is ever required in Sprint 1 rounds. |
| `close_register` | Close Register | Hold to count drawer and lock register | $24 | 2.2s | Locked until every non-register quota reaches 0. When locked, prompt text should read `Finish all other tasks first`. Completing this task ends the round in success immediately. |

## 2) Round rules

### Start condition
- Round flow remains `Waiting -> Intermission -> Playing -> Ended`.
- Enter `Intermission` when at least **1** player is present.
- Intermission length: **15 seconds**.
- At the moment the round enters `Playing`, snapshot the active players for that round.
- Players who join after `Playing` begins should wait for the next round and receive no payout for the current one.

### Round duration
- `Playing` duration: **540 seconds** total.

### Task quotas by player count
Use the active player count from the round-start snapshot.

| Players at round start | Restock Shelf | Clean Spill | Take Out Trash | Return Cart | Check Freezer | Close Register | Total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 2 | 1 | 1 | 2 | 1 | 1 | 8 |
| 2 | 2 | 2 | 1 | 2 | 1 | 1 | 9 |
| 3–4 | 2 | 2 | 2 | 2 | 1 | 1 | 10 |
| 5–6 | 3 | 2 | 2 | 3 | 1 | 1 | 12 |

### Progress rules
- Track both:
  1. **per-category remaining quotas** for server logic and register gating
  2. **total completed / total required** for the current HUD progress display
- `Close Register` should not count as available progress until its lock condition is met.
- Recommended formula for HUD total: include register in total required from round start, but keep its node locked until all other quotas are done.

### Win condition
- All non-register quotas reach 0.
- `Close Register` unlocks.
- A player completes `Close Register` before the timer reaches 0.

### Fail condition
- The timer reaches 0 before `Close Register` completes.
- There is no additional fail state in Sprint 1.

### Payout timing
- Enter `Ended`.
- Wait up to **3 seconds** for end-of-round UI/alert messaging.
- Then award `Cash` leaderstat payout to each active round player.

### Payout formula
1. Compute `basePay` = sum of rewards for all completed **real** tasks.
2. On success, each active round player receives:
   - `basePay + 35 - personalMimicPenalty`
3. On failure, each active round player receives:
   - `floor(basePay * 0.60) - personalMimicPenalty`
4. Clamp final payout to minimum **0**.

Notes:
- `personalMimicPenalty` starts at 0 for each player each round.
- Only the player who triggers the mimic receives the mimic cash deduction.
- There is no contribution weighting in Sprint 1; this is intentionally co-op-first.

## 3) Event rules

### Blackout
- Frequency: **exactly once max per round**.
- Trigger window: choose one random time when the round has between **300 and 240 seconds remaining**.
- Duration: **10 seconds**.
- Global alert on start: `Blackout. Wait for backup power.`
- Global alert on end: `Backup power restored.`

#### Blackout interaction behavior
- Any task interaction already in progress when blackout starts may finish normally if the player keeps holding.
- No new task interactions may begin during blackout.
- While blackout is active:
  - keep task prompts visible
  - disable prompt activation
  - replace prompt/action text with `Blackout — wait for backup power`
- When blackout ends, restore normal prompt text/behavior within the same frame or next update tick.

### Mimic / false task
- Frequency: **at most once per round**.
- Eligibility window: choose one random time when the round has between **180 and 135 seconds remaining**.
- Additional eligibility checks:
  - blackout must not be active
  - at least **3 real tasks** must still remain unfinished
  - `Close Register` is never eligible
  - do not place mimic on a node already being interacted with
- Selection rule:
  - choose **1** currently active eligible node from `restock_shelf`, `clean_spill`, `take_out_trash`, `return_cart`, or `check_freezer`
  - mark it as a false task for **18 seconds** or until triggered

#### Mimic player-facing behavior
- The node should still look like an interactable task prompt for Sprint 1.
- It should not be announced globally when spawned.
- It may use a subtle local-only audiovisual tell later, but that is not required for this sprint.

#### Mimic resolution
If a player completes the hold on the mimic node:
- do **not** increment task progress
- do **not** add reward to `basePay`
- add **$12** to that player's `personalMimicPenalty`
- subtract **8 seconds** from the shared round timer immediately
- disable that trapped node for **8 seconds** before it can become a real task again
- raise global alert: `That wasn't on the list.`
- clear the mimic state; no second mimic may spawn that round

If the mimic expires without interaction after 18 seconds:
- clear the mimic state
- apply no penalty
- do not spawn a replacement mimic that round

## 4) Anti-frustration rules
- Only **one blackout** and **one mimic** may happen in a single round.
- Mimic cannot appear in the late endgame because it requires at least **3 real tasks remaining** and a mid/late timing window.
- Mimic penalty is capped at **one 8-second time loss** and **one $12 personal deduction** per round.
- Failure still grants **60%** of earned base pay to every active round player.
- Solo fairness comes from lower quotas, single-event caps, and the absence of death/revive/stamina punishment systems.
- `Close Register` uses a hard lock with clear text so players are never confused about the final objective state.

## 5) Open risks / deferred items for future sprints
- Exact visual/audio tell strength for mimic should be tuned after internal playtests.
- Reward numbers and quota counts may need balance adjustment once real completion times are measured.
- If idling/leeching becomes a social problem, add contribution-aware bonus logic later rather than in Sprint 1.
- If blackout feels too passive, future sprints can add flashlight or backup-power gameplay, but not in this sprint.

## Acceptance criteria
- Server can run a 9-minute round with 1–6 players.
- Correct quota bundle is chosen from the player-count table at round start.
- `Close Register` remains locked until every other category quota is complete.
- Blackout disables new interactions for 10 seconds without soft-locking existing holds.
- Mimic can spawn once, apply the specified penalties, and never cause an instant fail by itself.
- End-of-round `Cash` payout matches the formula above and is visible to players.
