# Sprint 2 smoke and live validation plan

This document is the concrete validation plan for the **Sprint 2 clarity-and-feel** pass in **Closing Shift: Superstore 3AM**.

## Current gate status
- **Not Ready**
- **What is already covered:**
  - command smoke is passing
  - build is passing
  - Sprint 1 gameplay baseline already has headless Roblox-engine runtime proof for payout, register gating, blackout, mimic, co-op mimic penalty, leave-before-payout, and late join exclusion
  - Sprint 2 phone-sized HUD readability now has a runtime-backed pass at `260px` panel width / `236px` inner width with no clipping/overlap
  - Sprint 2 blackout + mimic co-op presentation now has a runtime-backed sanity pass with distinct cues, correct blackout behavior, shared `-8s`, and personal-only `-$12`
- **What still must be captured live for Sprint 2 readiness:**
  1. first-time-player / no-verbal-coaching pass

## Evidence capture rules
For every run, record:
- date / tester
- build used
- player count
- device or viewport size
- commands run
- tests passed / failed / skipped
- screenshots or video for any failure
- screenshots for phone HUD proof, late-join wait state, and round-end summary

---

## A. Command-based smoke
These checks prove structural health. They do **not** replace live clarity validation.

### A1. Formatting / lint
```bash
cd project
bash scripts/check.sh
```
**Expected**
- `stylua src scripts` passes
- `selene src scripts` passes
- no new syntax or lint regressions

### A2. Build place file
```bash
cd project
bash scripts/build.sh
```
**Expected**
- build succeeds
- generated place includes the Sprint 2 HUD/tutorial/effects/audio changes
- non-blocking warning on `Remotes.model.json` may still appear

### A3. Structural smoke
```bash
cd project
run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua
```
**Expected**
- exits cleanly
- prints:
  - `SMOKE_OK: core folders and scripts are present`
  - `SMOKE_OK: sprint 1 round loop structure is present`
- smoke shape implicitly confirms presence of:
  - `Shared/UIStrings`
  - `StarterGui/HUD`
  - `StarterPlayerScripts/Audio`
  - `StarterPlayerScripts/ClientEffects`

### A4. Current command evidence
This plan already has current QA-pass evidence for:
- `bash scripts/check.sh` — pass
- `bash scripts/build.sh` — pass
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` — pass

---

## B. Live 1-player clarity pass
Run this in Studio or local server with exactly **1 player**. This pass is about readability and explanation, not reopening already-proven Sprint 1 math unless a contradiction appears.

### B1. Tutorial / onboarding flow
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-01 | Join before intermission and wait for the next playable round | Tutorial begins only when the player is eligible to play |
| CLAR-02 | Observe first intermission tutorial step | `Finish the list before time runs out.` appears without blocking movement |
| CLAR-03 | Observe round start | `Follow the glow. Hold on a task to work.` appears in the same alert slot, not as a modal |
| CLAR-04 | Complete one real task or reach the fallback timing | `Task cash is banked. Register unlocks last.` appears |
| CLAR-05 | Unlock register | `Close Register is ready. Finish the shift.` appears and does not stack into a feed |
| CLAR-06 | Stay in control throughout | Tutorial never blocks movement, camera, or interaction |

### B2. Active-task readability
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-07 | Enter the store at round start | At least one task highlight is obvious without spinning in place |
| CLAR-08 | Walk toward active nodes | Available tasks read as active at a glance |
| CLAR-09 | Finish a real task | Completed/cooling-down node visibly downgrades |
| CLAR-10 | Complete the last non-register task | Register becomes the strongest objective read in the room |
| CLAR-11 | Attempt locked register earlier in the round | Prompt clearly communicates `Finish all other tasks first` |

### B3. HUD readability during normal play
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-12 | Read HUD at round start | Player can identify state, timer, saved cash, earnings, objectives, and alert quickly |
| CLAR-13 | Complete one real task | Objectives and `Banked: $X` update immediately |
| CLAR-14 | Check earnings block | Uses short lines: `Banked`, `Clear`, `Timeout`, optional `False task` |
| CLAR-15 | Check objectives block | Fits inside three short lines and keeps `Reg locked/ready/closed` visible |
| CLAR-16 | Observe alert behavior over time | Only one alert slot is visible; messages replace each other rather than stacking |

### B4. Blackout presentation
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-17 | Wait for blackout | Alert reads `Blackout. Wait for backup power.` |
| CLAR-18 | Observe the world during blackout | Orientation remains possible; active nodes dim instead of disappearing |
| CLAR-19 | Try to start a new task | Prompt stays visible but disabled with blackout wording |
| CLAR-20 | Wait for blackout end | Alert reads `Power restored. Get back to work.` |

### B5. Mimic presentation
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-21 | Keep 3+ real tasks active into the mimic window | No global spawn alert appears |
| CLAR-22 | Trigger the false task | Alert reads `False task. Lost time and pay.` |
| CLAR-23 | Check the trapped node | Node shows a distinct locked-out recovery state |
| CLAR-24 | Check HUD after trigger | Local player can understand that time and pay were lost |

### B6. Round-end explanation
| ID | Step | Expected result |
| --- | --- | --- |
| CLAR-25 | Finish a successful round | Summary shows `SHIFT CLEARED`, tasks, banked pay, `Bonus: +$35`, optional false-task line, and `Cash added` |
| CLAR-26 | Fail a round with banked pay | Summary shows `SHIFT FAILED`, tasks, banked pay, `60% pay`, optional false-task line, and `Cash added` |
| CLAR-27 | Read summary quickly on phone-safe width | Numbers are readable without a separate full-screen result page |

---

## C. Live 2-player co-op sanity pass
Runtime-backed sanity evidence is already recorded for the current gate. Keep this section for optional human-view capture or contradiction checking.

Run with exactly **2 players** who both join before intermission ends.

### C1. Shared clarity and sync
| ID | Step | Expected result |
| --- | --- | --- |
| COOP-01 | Start a round with 2 players | Quota bundle remains the locked 2-player set |
| COOP-02 | Split work between players | Shared task progress remains in sync |
| COOP-03 | Trigger blackout | Both players receive the same blackout state and pinned alert |
| COOP-04 | Trigger mimic with Player A | Both players see the time hit; only Player A reads the personal penalty on payout projection/summary |
| COOP-05 | Unlock register | Both players see the unlock alert and strongest register highlight |
| COOP-06 | End the round | Both players receive correct local summaries based on their own penalty state |

### C2. Late-join wait-state sanity
| ID | Step | Expected result |
| --- | --- | --- |
| COOP-07 | Add Player C after the round is already playing | Player C does not join the live roster |
| COOP-08 | Observe Player C HUD | State reads `Waiting for next shift` |
| COOP-09 | Observe Player C alert/objectives | `Shift in progress. Wait for the next one.` stays stable |
| COOP-10 | Observe Player C payout at round end | Player C gets no current-round payout summary |

---

## D. Phone-sized HUD pass
This pass is now **closed by runtime-backed evidence** for the current gate. Keep it for optional human-view capture or contradiction checking.

### D1. Viewport requirements
Use one of:
- Studio emulator at **375x667** or similar phone portrait size
- a real phone client
- another viewport inside the locked **260–360 px** HUD width target

### D2. Capture states
Capture screenshots or clip for each:
1. intermission with tutorial step visible
2. active round with at least one completed task
3. blackout active
4. register unlocked
5. round-end summary
6. late-join wait state

### D3. Acceptance checks
| ID | Step | Expected result |
| --- | --- | --- |
| PHONE-01 | Open HUD on phone-sized viewport | No clipped text in normal play |
| PHONE-02 | Read earnings block | `Banked`, `Clear`, `Timeout`, and optional `False task` remain legible |
| PHONE-03 | Read objectives block | All three lines remain readable; register state remains visible |
| PHONE-04 | Show a long alert or tutorial line | Alert stays readable without overlapping other blocks |
| PHONE-05 | Show round-end summary | Summary remains readable without overflowing the panel |
| PHONE-06 | Move while reading | HUD remains usable in motion, not just in a static paused inspection |

---

## E. First-time-player / no-verbal-coaching pass
This is the **only remaining readiness blocker**.

### E1. Setup
- Tester should not be the implementer.
- Do not explain the game rules verbally once the run starts.
- Let the player rely on the tutorial, HUD, highlights, prompts, and map readability.
- Do not substitute another proxy harness here; the current block exists because the available runtime tools cannot create a true fresh local player (`CreateLocalPlayer` lacks `LocalUser`; direct `Player` creation lacks `WritePlayer`).

### E2. Record these questions
| ID | Question | Pass condition |
| --- | --- | --- |
| NVC-01 | Does the player understand the core goal before the round starts? | Yes, from tutorial/HUD alone |
| NVC-02 | Can the player find an initial task without coaching? | Yes |
| NVC-03 | Does the player understand that task cash is banked until round end? | Yes |
| NVC-04 | Does the player understand why `Close Register` is unavailable at first? | Yes |
| NVC-05 | When register unlocks, does the player notice it quickly? | Yes |
| NVC-06 | During blackout, does the player understand they must wait for power? | Yes |
| NVC-07 | After a mimic trigger, does the player understand they lost time and pay? | Yes |
| NVC-08 | At round end, can the player explain where the payout number came from? | Yes |

### E3. Failure rule
If the tester repeatedly asks where to go, why register is locked, or what happened to pay/time, Sprint 2 clarity is **not** ready regardless of command smoke success.

---

## F. Regression spot-checks during live validation
Do these only as targeted confirms. The locked Sprint 1 baseline already has strong runtime evidence.

| ID | Scenario | Expected result |
| --- | --- | --- |
| REG-01 | Finish a successful round | Success payout math still matches locked rules |
| REG-02 | Let timer expire with banked pay | Failure payout still uses `60%` conversion |
| REG-03 | Start a hold just before blackout | Hold may finish if already started |
| REG-04 | Start a new task during blackout | New interaction is blocked |
| REG-05 | Trigger mimic | Shared timer drops by exactly `8s` |
| REG-06 | Compare two players after mimic | Only the triggering player gets the `-$12` personal penalty |
| REG-07 | Add a late joiner | Excluded player gets wait-state messaging and no participation |

---

## Run sheet template
Copy this section for each execution pass.

### Validation run record
- **Date / tester:**
- **Build used:**
- **Player count:**
- **Device / viewport:**
- **Commands run:**
- **Sections executed:**
- **Tests passed:**
- **Tests failed:**
- **Blocked / skipped:**
- **Evidence links / screenshots:**
- **Notes:**
