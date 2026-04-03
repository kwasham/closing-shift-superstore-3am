# Engineering handoff — Sprint 2 clarity and feel

## Objective
Implement the Sprint 2 onboarding, HUD readability, task feedback, event presentation, and round-end explanation pass for **Closing Shift: Superstore 3AM** without reopening the proven Sprint 1 gameplay baseline.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT2-PLAN.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Files to edit
- `project/src/**`
- `project/scripts/smoke_runner.lua` only if the Sprint 2 UI / state pass needs narrow smoke coverage

## Implementation stance
- Treat Sprint 1 round logic as locked.
- Sprint 2 is a communication and presentation pass.
- If a clarity improvement would require changing timers, quotas, payout math, event counts, or roster rules, do **not** change it here.

## 1) Tutorial flow

### Tutorial tracking rule
- Track tutorial completion **per client session only**.
- Because persistence is out of scope, the tutorial should show once after a player joins a server and becomes eligible to play a round.
- Eligible means the local player is inside the round-start roster for the next playable shift.
- Late joiners during `Playing` or `Ended` do **not** start the tutorial for that live round.

### Tutorial presentation rule
- Tutorial is **non-modal**.
- Use the existing HUD alert area or a visually adjacent coachmark style, but never block movement or interaction.
- Only **one** tutorial step can be visible at a time.
- Tutorial text must obey the same phone-safe copy limits as alerts.

### Tutorial steps
| Step id | Trigger | Exact copy | Duration / clear rule | Notes |
| --- | --- | --- | --- | --- |
| `tutorial_goal` | First eligible intermission after join, after HUD is visible for ~1 second | `Finish the list before time runs out.` | Show for 4 seconds, or until intermission ends | This is the only pre-round goal statement. |
| `tutorial_follow_task` | First `Playing` snapshot for an eligible player who saw step 1 | `Follow the glow. Hold on a task to work.` | Show for 5 seconds, or clear on first successful hold start | Teaches highlight + hold interaction together. |
| `tutorial_banked_pay` | First real task completion, or 20 seconds into `Playing`, whichever happens first | `Task cash is banked. Register unlocks last.` | Show for 5 seconds | Do not split this into two extra tutorial messages. |
| `tutorial_register_end` | First time `Close Register` unlocks for that player | `Close Register is ready. Finish the shift.` | Show for 4 seconds, then fall back to the normal unlock alert behavior | This can piggyback on the register unlock event. |

### Late join behavior
- If the player joins during `Playing` or `Ended`, show only the wait-state HUD messaging:
  - state: `Waiting for next shift`
  - alert: `Shift in progress. Wait for the next one.`
  - objectives: `Shift in progress. Wait for the next one.`
- Do not advance tutorial state while excluded from the live round.
- If the player stays for the next intermission and becomes eligible, begin at `tutorial_goal`.

## 2) HUD / alert hierarchy

### Phone-safe HUD layout contract
Keep the Sprint 1 top-left HUD panel, but make the text hierarchy predictable and compact.

Required layout rules:
- Width clamp: **260–360 px**
- Auto-height: **required**
- One vertical stack only; no side-by-side micro-panels on phone
- Text blocks in this order:
  1. title
  2. state
  3. timer
  4. saved cash
  5. earnings
  6. objectives
  7. alert / tutorial line
- Do not rely on color alone for lock, danger, or payout meaning.

### Copy-length rules
- Alert / tutorial text: **42 characters max**
- State line: **28 characters max**
- Objectives block: **3 lines max**
- Earnings block: **3 lines max**
- Round-end summary line: target **24 characters max before numbers**, keep it readable at 260 px width

### Earnings block format
Use short labeled lines rather than the current dense sentence.

Required format during active play:
- Line 1: `Banked: $X`
- Line 2: `Clear: $Y | Timeout: $Z`
- Line 3: only when needed: `False task: -$N`

Rules:
- `Clear` means success payout after bonus and after the local player's personal mimic deduction.
- `Timeout` means failure payout after the `60%` conversion and after the local player's personal mimic deduction.
- If there is no personal deduction, omit line 3 entirely.

### Objectives block format
Required format during active play:
- Line 1: `Tasks: completed/total`
- Line 2: `Restock R | Spill S | Trash T`
- Line 3: `Cart C | Freezer F | Reg STATE`

Rules:
- `STATE` must be one of `locked`, `ready`, or `closed`.
- Keep the register state visible even when the rest of the line compresses.
- A late joiner wait state replaces this whole block with the wait-for-next-shift copy.

### Alert priority table
| Priority | Alert ids / moments | Exact copy | Behavior |
| --- | --- | --- | --- |
| P0 pinned | `late_join_wait` | `Shift in progress. Wait for the next one.` | Replaces all lower alerts until the player becomes eligible next round. |
| P0 pinned | `blackout_active` | `Blackout. Wait for backup power.` | Pins for the full blackout duration. |
| P0 result | `round_success` | `Shift cleared. Cashing out.` | Holds through the round-end summary window. |
| P0 result | `round_failure` | `Time's up. Partial pay.` | Holds through the round-end summary window. |
| P0 urgent | `mimic_triggered` | `False task. Lost time and pay.` | Show for 4 seconds. Interrupts lower-priority text. |
| P1 action | `register_unlocked` | `Close Register unlocked.` | Show for 4 seconds. |
| P1 recovery | `blackout_end` | `Power restored. Get back to work.` | Show for 3 seconds after blackout ends. |
| P2 start hint | `round_start_hint` | `Clock in. Follow the task glow.` | Show for 4 seconds if no higher alert is active. |
| P2 tutorial | tutorial steps above | exact tutorial copy | Tutorial shares the same slot and obeys higher-priority replacement rules. |
| P3 ambient fallback | no active alert | state-driven helper text | Only visible when nothing higher is active. |

### Stack / replace rules
- Use **one alert slot only**.
- Higher priority replaces lower priority immediately.
- Lower priority does **not** queue behind P0 pinned states.
- Keep at most **one pending P1/P2** message after a transient P0 alert; if a newer message of the same or higher priority arrives, drop the older pending one.
- Re-firing the same alert refreshes its timer instead of duplicating it.
- Real task completion should normally update the node + objectives + earnings without stealing the main alert slot.

## 3) Task feedback rules

### Active-task highlight behavior
Use readable world feedback on live task nodes without adding new mechanics.

| Task-node state | World feedback | Prompt behavior | HUD behavior |
| --- | --- | --- | --- |
| Real task available | Soft pulse / highlight visible at a glance | Normal prompt text | Objectives and earnings remain live |
| Real task being worked | Stronger local focus while held | Normal prompt text during hold | No new alert needed |
| Real task completed and quota still remains later | Brief positive flash, then cooldown / neutral state | Prompt disabled during reuse cooldown | Objectives decrement immediately |
| Task category fully done | Highlight removed or downgraded so it no longer reads as active | Prompt can disable or stay visually inactive | Remaining count shows `0` |
| Register locked | Subdued but visible locked highlight | `Finish all other tasks first` | Objectives line shows `Reg locked` |
| Register unlocked | Strongest highlight in the room | Normal register prompt text | Objectives line flips to `Reg ready`; alert + cue fire immediately |
| Register completed | Completion flash, then inactive | No further reuse this round | Objectives line shows `Reg closed` |
| Blackout active | Keep nodes visible but dim active highlights | Replace prompt text with `Blackout — wait for backup power`; block new starts | Pinned blackout alert stays visible |
| Mimic node after trigger | Use a trapped / disabled visual distinct from a normal cooldown | `Node locked after false task` for the lockout | No progress added; urgent mimic alert remains |

### Task completion rules
When a **real** task completes:
- Update remaining quota and total completed count in the same frame or next replicated update tick.
- Update the earnings block in that same update.
- Give a brief positive confirmation on the node (`~0.6s` flash is enough).
- Play the local `task_complete` cue if available.
- Do **not** post a big banner alert unless the completion also unlocks the register.

### `Close Register` lock / unlock communication
`Close Register` must stay obvious without extra explanation.

Locked rules:
- Prompt text: `Finish all other tasks first`
- Objectives line: `Reg locked`
- Register remains visible in the world but not as the strongest active task

Unlocked rules, fired immediately when the last non-register quota reaches `0`:
- Objectives line flips to `Reg ready`
- Register highlight becomes the strongest active highlight
- Alert fires: `Close Register unlocked.`
- Audio fires: `register_unlocked`
- If the tutorial is still active this round, count this moment as `tutorial_register_end`

## 4) Audio cue matrix

### Cue priorities
- **P0 critical:** interrupt any lower cue
- **P1 important:** interrupt P2 only
- **P2 informational:** never interrupt higher cues; may drop if something stronger is playing

### Required cue table
| Cue id | Trigger | Audience | Priority | Fallback if asset is missing |
| --- | --- | --- | --- | --- |
| `task_complete` | A real task completes successfully | Local triggering player | P2 | Silent fallback; visual completion flash and HUD updates still carry the feedback |
| `register_unlocked` | Last non-register quota reaches `0` | All active round players | P1 | Reuse `task_complete` once if available; otherwise silent fallback |
| `blackout_start` | Blackout begins | All active round players | P0 | Silent fallback; pinned blackout alert + dimmed prompts must still communicate the state |
| `blackout_end` | Blackout ends | All active round players | P1 | Reuse `register_unlocked` once if available; otherwise silent fallback |
| `mimic_triggered` | A player completes the false task | All active round players | P0 | Silent fallback; urgent alert + trapped-node visual must still land |
| `round_success` | `Close Register` completes before timer hits `0` | All active round players | P0 | Reuse `register_unlocked` once if available; otherwise silent fallback |
| `round_failure` | Timer reaches `0` before register completion | All active round players | P0 | Silent fallback; result copy + summary still explain the outcome |

Rules:
- No audio cue should be required for gameplay correctness.
- Missing sounds must never block alerts, progress, or payout.
- Do not add a global cue for mimic spawn in Sprint 2.

## 5) Round-end summary

### Summary behavior
- Show the summary immediately when the round enters `Ended`.
- Use the player's own numbers.
- Late joiners excluded from the active roster do **not** receive a payout summary for that round.
- Keep the summary compact enough to read on phone without a separate full-screen results page.

### Success summary contract
Required content order:
1. Header: `SHIFT CLEARED`
2. `Tasks: completed/total`
3. `Banked: $X`
4. `Bonus: +$35`
5. Optional: `False task: -$N`
6. `Cash added: +$Z`

Formula:
- `Z = bankedPay + 35 - personalPenalty`, clamped to `0`

### Failure summary contract
Required content order:
1. Header: `SHIFT FAILED`
2. `Tasks: completed/total`
3. `Banked: $X`
4. `60% pay: $Y`
5. Optional: `False task: -$N`
6. `Cash added: +$Z`

Formula:
- `Y = floor(bankedPay * 0.60)`
- `Z = Y - personalPenalty`, clamped to `0`

### Summary clarity rules
- If `personalPenalty == 0`, omit the false-task line entirely.
- Do not list teammate penalties here; keep it local and readable.
- The summary must explain the deposited `Cash` amount, not just the result state.

## 6) No-regression guardrails
- Keep the round flow `Waiting -> Intermission -> Playing -> Ended`.
- Keep **15 seconds** of intermission.
- Keep **540 seconds** of active round time.
- Keep the existing player-count quota bundles.
- Keep task rewards, hold durations, and `Close Register` as the final gated task.
- Keep blackout to **one max per round**, **10 seconds**, within the existing timing window.
- Keep mimic to **one max per round**, within the existing timing window, with the existing `-8s` team hit, `-$12` personal penalty, and `8s` node lockout.
- Keep late joiners excluded from participation and payout for the current round.
- Do not add new task types, events, NPCs, revive, stamina, persistence, progression systems, or economy expansion.

## 7) Deferred items
- Persistent tutorial seen-state and an optional replay button wait for future save-backed progression work.
- Stronger pre-trigger mimic tells stay deferred unless post-Sprint 2 tests show the current deceptive spawn still reads as unfair.
- If highlighted tasks are still not enough for new players, evaluate a directional locator in a later sprint instead of expanding Sprint 2 here.

## Acceptance criteria
- A first-time player can follow the tutorial flow without any modal interruption.
- The HUD stays readable at phone-safe width while showing state, timer, cash, earnings, objectives, and alerts.
- Active real tasks are visually distinguishable from inactive, cooling-down, locked, and blackout-disabled states.
- `Close Register` is clearly locked, then clearly unlocked, without needing voice explanation.
- Blackout and mimic trigger have distinct text/audio/visual presentation without altering their Sprint 1 gameplay consequences.
- The round-end summary explains exactly how the player's `Cash` deposit was computed.
