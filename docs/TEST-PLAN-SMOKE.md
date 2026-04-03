# Sprint 1 smoke test plan

This document is the concrete smoke/manual test plan for **Closing Shift: Superstore 3AM** Sprint 1.

## Current status
- **Plan ready**
- **Command smoke evidence is captured:** `bash scripts/check.sh` passed, `bash scripts/build.sh` passed, and the structural smoke runner passes.
- **Headless Roblox-engine runtime evidence is captured** for the core gameplay rules: solo success/failure, blackout, mimic expire/trigger, exact `-8s` timer loss, personal-only co-op mimic penalty, leave-before-payout handling, and the late-join server exclusion path.
- **Remaining blocker proof is now one narrow client-facing rerun:** the post-hotfix late-join wait-for-next-shift HUD/state behavior still needs one direct real-player artifact.
- Use this file to run that final late-join spot-check and record outcomes.

## Evidence capture rules
For every run, capture:
- date / tester
- build source or branch
- player count
- commands run
- pass/fail per test id
- screenshots or video for any failure
- exact timer values for `Blackout` and `Mimic` observations

---

## A. Command-based smoke
These steps validate repo/build shape first. They are not a replacement for Studio play.

### A1. Formatting / lint
```bash
cd project
bash scripts/check.sh
```
**Expected**
- `stylua src scripts` exits cleanly
- `selene src scripts` exits cleanly
- no new syntax/lint regressions in Sprint 1 files

**Current evidence**
- `bash scripts/check.sh` passed with:
  ```text
  Results:
  0 errors
  0 warnings
  0 parse errors
  ```

### A2. Build place file
```bash
cd project
bash scripts/build.sh
```
**Expected**
- build succeeds
- generated place contains updated round/task/event/HUD scripts

**Current evidence**
- `bash scripts/build.sh` passed.
- Current build output includes a non-blocking Rojo warning about `Remotes.model.json` having a top-level `Name` field.

### A3. Structural smoke path
```bash
cd project
run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua
```
**Expected**
- completes without assertion failure
- prints `SMOKE_OK: core folders and scripts are present`
- prints `SMOKE_OK: sprint 1 round loop structure is present`

**Current evidence**
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` now passes after the smoke-harness bootstrap hotfix.
- Captured output:
  ```text
  SMOKE_OK: core folders and scripts are present
  SMOKE_OK: sprint 1 round loop structure is present
  ```

### A4. Command smoke checklist
| ID | Check | Expected |
| --- | --- | --- |
| CMD-01 | Constants load | round = 540s, intermission = 15s |
| CMD-02 | Services exist | `TaskService`, `EventService`, `PayoutService`, `ShiftService` present |
| CMD-03 | Remotes exist | `RoundStateChanged`, `TaskProgressChanged`, `AlertRaised` present |
| CMD-04 | Quota helpers work | solo total = 8, full-party total = 12 |
| CMD-05 | HUD script present | `HUD` under `StarterPlayerScripts` |
| CMD-06 | Task nodes boot | `TaskNodes/close_register_node` exists |

---

## B. Manual Studio / play-session smoke
Run these in a fresh server first with **1 player**, then repeat the co-op subset with **2 players**.

> QA note: most server-authoritative gameplay rules below are already proven by headless Roblox-engine runtime and should not be reopened unless a real-player run contradicts them. The final must-capture item is the post-hotfix late-join client initialization / wait-for-next-shift HUD state.

### B1. Single-player golden path
| ID | Step | Expected result |
| --- | --- | --- |
| MAN-01 | Open a fresh server with 1 player present | Server leaves `Waiting` and enters `Intermission` |
| MAN-02 | Observe intermission countdown | Starts at **15** and reaches **0** cleanly |
| MAN-03 | Round starts | HUD shows `Playing` and timer at **09:00** |
| MAN-04 | Read HUD on round start | Player can understand saved cash vs banked shift pay vs clear/fail projection |
| MAN-05 | Attempt `Close Register` immediately | Prompt stays locked and/or alert explains `Finish all other tasks first` |
| MAN-06 | Complete one `Restock Shelf` | Restock remaining count drops by 1; total progress increments; banked pay increases by **$14** |
| MAN-07 | Complete one `Clean Spill` | Spill remaining count drops by 1; total progress increments; banked pay increases by **$18** |
| MAN-08 | Complete one `Take Out Trash` | Trash remaining count drops by 1; total progress increments; banked pay increases by **$16** |
| MAN-09 | Complete one `Return Cart` | Cart remaining count drops by 1; total progress increments; banked pay increases by **$12** |
| MAN-10 | Complete `Check Freezer` | Freezer remaining count drops to 0; banked pay increases by **$20** |
| MAN-11 | Finish all non-register quotas | HUD/register state clearly changes to unlocked |
| MAN-12 | Complete `Close Register` | Round ends immediately in success |
| MAN-13 | Observe payout | Final `Cash` increase equals **full banked value + $35** |

**Still required from a real-player run:**
- no new blocker in this section for the narrow recheck; only escalate if live play contradicts the already-captured runtime evidence

### B2. Locked timing validation
| ID | Step | Expected result |
| --- | --- | --- |
| TIME-01 | Record round-start timer | `09:00` |
| TIME-02 | Record blackout start when observed | Occurs once with timer between **05:00 and 04:00** remaining |
| TIME-03 | Measure blackout length | Lasts **10 seconds** |
| TIME-04 | Record mimic appearance when observed | Becomes relevant between **03:00 and 02:15** remaining while at least 3 real tasks remain |
| TIME-05 | Ignore mimic if possible | Expires after roughly **18 seconds** with no penalty and no replacement mimic |

### B3. Blackout smoke
Set this up during a live round. Do not finish the round too quickly.

| ID | Step | Expected result |
| --- | --- | --- |
| BO-01 | Wait for blackout start alert | Global alert reads `Blackout. Wait for backup power.` |
| BO-02 | Try to start a new untouched task during blackout | New interaction does **not** start |
| BO-03 | Begin a task hold shortly before blackout, keep holding through event start | In-progress hold completes if it was valid before blackout started |
| BO-04 | Check task prompt text during blackout | Prompt remains visible but disabled with blackout-specific wording |
| BO-05 | Wait for blackout end | Alert reads `Backup power restored.` |
| BO-06 | Retry a blocked task after blackout ends | Prompt re-enables and interaction works normally |
| BO-07 | Watch for repeat blackout | No second blackout occurs that round |

### B4. Mimic smoke
To make this likely, keep at least **3 real tasks** unfinished into the mimic window.

| ID | Step | Expected result |
| --- | --- | --- |
| MI-01 | Reach timer between **03:00 and 02:15** with 3+ real tasks remaining | Mimic is eligible |
| MI-02 | Trigger the false task if it appears | No quota progress is awarded |
| MI-03 | Check timer immediately after trigger | Shared timer drops by **8 seconds** |
| MI-04 | Check player payout projection immediately after trigger | Triggering player loses **$12** from projected payout |
| MI-05 | Reuse same node immediately | Node is locked for about **8 seconds** |
| MI-06 | Watch round for second mimic | No second mimic occurs |
| MI-07 | Alternate path: ignore the mimic for its full life | It expires after ~18 seconds with no penalty |

### B5. Failure-path smoke
| ID | Step | Expected result |
| --- | --- | --- |
| FAIL-01 | Bank some value, then let timer expire without closing register | Round ends in failure |
| FAIL-02 | Check final payout | `Cash` increase equals `floor(0.60 * banked value)` minus any personal penalty |
| FAIL-03 | Create a low-bank scenario with a mimic penalty | Final payout never drops below **$0** |
| FAIL-04 | Reach timer 0 while register is still locked | Round fails cleanly; no soft lock or infinite state |

---

## C. 2-player co-op sanity checks
Run with exactly **2 players** who both join before intermission ends.

> QA note: the co-op mimic penalty logic is already engine-backed and proven. For the final gate, use this section primarily to execute the late-join rerun and capture what the excluded joiner actually sees.

| ID | Step | Expected result |
| --- | --- | --- |
| COOP-01 | Start round with 2 players | Total quota bundle matches **9** real tasks + final register |
| COOP-02 | Split task work across both players | Shared progress/HUD stays in sync for both |
| COOP-03 | Trigger mimic with Player A | Shared timer drops for both players |
| COOP-04 | Compare projected payouts after mimic | Only Player A shows the **-$12** personal penalty |
| COOP-05 | Finish round successfully | Both players receive same base payout, minus only their own personal penalties |
| COOP-06 | Add Player C mid-round | Player C gets `State: Waiting for next shift`, sees pinned `Shift in progress. Wait for the next one.`, and gets no current-round task credit/payout |
| COOP-07 | Observe register unlock | Both players see the unlocked final objective state |

---

## D. Failure-case checks
These are the minimum “don’t embarrass the demo” checks.

| ID | Scenario | Expected result |
| --- | --- | --- |
| FC-01 | Player spams locked `Close Register` early | No progress; lock messaging stays clear |
| FC-02 | Player hits a task node with 0 remaining quota | No extra progress or duplicated banked pay |
| FC-03 | Player joins after round start | Wait message shown; no active-round rewards |
| FC-04 | Blackout starts while a player is already holding | Hold is not unfairly canceled |
| FC-05 | Blackout ends | Disabled prompts recover without needing a rejoin/reset |
| FC-06 | Mimic node is ignored | No punishment fires after expiry |
| FC-07 | Trigger mimic late in a bad round | Time loss and personal penalty happen once only |
| FC-08 | Active player leaves before payout | Confirm current sprint behavior and document if payout is lost |

---

## E. Exploratory checks
These are not all blockers, but they are high-value probes for Sprint 1.

### E1. UX / clarity
- Is the banked-vs-saved cash distinction understandable without explanation?
- Is the register lock state obvious from both HUD text and world prompt?
- Are blackout and mimic alerts distinct enough at mobile size?
- Does the objective panel stay readable when alerts are active?

### E2. Interaction edge cases
- Two players hold different tasks during blackout start.
- Two players contest the same node around cooldown/lockout expiration.
- A task completes on the same moment blackout starts.
- Final non-register task and register unlock happen while another player is nearby.

### E3. Event feel
- Does blackout feel like a temporary pressure beat instead of a bug?
- Does mimic feel readable enough to be fair without killing the scare?
- Is the 8-second timer hit noticeable but not run-killing?

### E4. Content/readability sanity
- Are the generated MVP nodes readable enough to playtest routes?
- Can players find freezer/trash/cart/register tasks without verbal guidance?
- Does the current MVP arena cause confusion that the final store layout should solve?

---

## Run sheet template
Copy this section for each execution pass.

### Smoke run record
- **Date / tester:**
- **Build / branch:**
- **Player count:**
- **Commands run:**
- **Tests passed:**
- **Tests failed:**
- **Blocked / skipped:**
- **Key evidence links:**
- **Notes:**
