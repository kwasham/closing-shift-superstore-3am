# Runtime Evidence — Sprint 1

## Build / environment
- Date: 2026-04-01
- Machine / OS: Mac’s Mac mini / Darwin 25.2.0 (arm64)
- OpenClaw workspace / agent: `/Users/macmini/.openclaw/workspace-engineer` / engineer subagent
- Gateway-side project root resolved by approved `pwd`: `/Users/macmini/RobloxProjects/closing-shift-superstore-3am`
- Roblox Studio version or note if human-assisted: Human-assisted path required from this session. No direct Studio/runtime execution evidence captured here.
- Test mode used: Repo inspection + attempted command execution + smoke harness hotfix. Live Roblox validation remains operator-required.

## Commands run
### `bash scripts/check.sh`
- Result: Pass
- Output:
```text
Results:
0 errors
0 warnings
0 parse errors
```

### `bash scripts/build.sh`
- Result: Pass
- Output:
```text
[WARN  librojo::snapshot_middleware::json_model] Model at path Remotes.model.json had a top-level Name field. This field has been ignored since Rojo 6.0.
        Consider removing this field and renaming the file to /Users/macmini/RobloxProjects/closing-shift-superstore-3am/src/ReplicatedStorage/Remotes.model.json.
Building project 'ClosingShift'
Built project to ClosingShift.rbxlx
```

### `bash scripts/serve.sh` (if used)
- Result: Fail (environment port bind conflict)
- Output:
```text
jo-rbx/rojo/issues
[ERROR rojo]
[ERROR rojo] Details: error binding to 127.0.0.1:34872: error creating server listener: Address already in use (os error 48)
[ERROR rojo] in file /Users/runner/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/hyper-0.14.28/src/server/server.rs on line 81
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace.
(Command exited with code 1)
```

### `project/scripts/smoke_runner.lua`
- How it was executed: `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
- Result: Fail (tooling/runtime environment incompatibility)
- Output:
```text
'bad CPU type in executable' error. This is likely because it was compiled for an Intel Mac and you are running an Apple Silicon Mac. Rosetta 2 is a compatibility layer that enables running x86_64 apps on Apple Silicon Macs, and can be installed by running the following command: softwareupdate --install-rosetta
ERROR Bad CPU type in executable (os error 86)
(Command exited with code 1)
```
- Notes:
  - This is a host/toolchain issue on Apple Silicon, not a verified gameplay/runtime failure in the Sprint 1 code.
  - Hotfix applied earlier: the smoke harness now prints the required pass line `SMOKE_OK: core folders and scripts are present` if/when the smoke runner can actually execute.

## Runtime proof matrix
### A. Single-player success path
- Evidence: No live 1-player run captured in this session
- Observed intermission: Unverified
- Observed round start timer: Unverified
- Observed 1-player quota bundle: Unverified at runtime; code inspection matches 2/1/1/2/1/1
- `Close Register` lock/unlock behavior: Unverified at runtime; code inspection indicates server-side gate exists
- Projected payout behavior: Unverified at runtime; HUD/client code inspected only
- Final saved `Cash` result: Unverified
- Pass / fail: Blocked

### B. Blackout behavior
- Evidence: No live blackout session captured in this environment
- Duration observed: Unverified
- New interactions blocked: Unverified in engine
- In-progress hold completion confirmed: Unverified in engine
- Recovery confirmed: Unverified in engine
- Pass / fail: Blocked

### C. Mimic expire path
- Evidence: No live mimic-expire session captured
- Lifetime observed: Unverified
- No false penalty confirmed: Unverified
- Pass / fail: Blocked

### D. Mimic trigger path
- Evidence: No live mimic-trigger session captured
- Timer hit observed: Unverified
- Personal penalty observed: Unverified
- Node lockout observed: Unverified
- Duplicate trigger prevented: Unverified
- Pass / fail: Blocked

### E. Two-player co-op sanity
- Evidence: No live 2-player session captured
- Observed 2-player quota bundle: Unverified at runtime; code inspection matches 2/2/1/2/1/1
- Personal-only mimic penalty confirmed: Unverified in engine; payout/task code indicates per-user penalty map
- HUD/progress sync confirmed: Unverified in engine
- Pass / fail: Blocked

### F. Session edge cases
#### Late join
- Evidence: No live late-join session captured
- Observed behavior: Code inspection indicates late joiners receive wait-for-next-shift alert and are excluded from active round payout/task credit
- Pass / fail / acceptable known issue: Acceptable known design by code, but still runtime-unverified

#### Leave before payout
- Evidence: No live leave-before-payout session captured
- Observed behavior: Code inspection indicates payout only applies to still-present players (`player.Parent ~= nil`) at award time
- Pass / fail / acceptable known issue: Runtime-unverified acceptable known issue; document for operator validation

### G. HUD readability
- Evidence: No phone/emulator pass captured in this session
- Device / emulator mode: Not run
- Readability notes: HUD layout was inspected statically only; no live readability claim is made
- Pass / fail: Blocked

## Hotfixes made during runtime validation
- Files changed:
  - `project/scripts/smoke_runner.lua`
- Why the changes were necessary:
  - The runtime validation pack requires a passing structural smoke to include the exact line `SMOKE_OK: core folders and scripts are present`.
  - The existing smoke harness only printed `SMOKE_OK: sprint 1 round loop structure is present`.
  - Updated the harness to print the required line so future smoke evidence can satisfy the locked validation wording.

## Remaining unverified or blocked items
- A clean `scripts/serve.sh` run if live sync is part of the operator workflow; current attempt failed because the Rojo port was already in use
- A successful `run-in-roblox` or equivalent Studio smoke execution using `project/scripts/smoke_runner.lua`; current attempt failed because the executable requires Intel compatibility / Rosetta on Apple Silicon
- 1-player success-path timing, quotas, register gate, payout landing in `Cash`
- Blackout duration and mid-hold behavior in real ProximityPrompt runtime
- Mimic expire path and trigger path in real runtime
- 2-player co-op proof for personal-only mimic penalty and HUD/progress sync
- Late join and leave-before-payout live observations
- Phone-sized HUD readability pass

## Verdict recommendation for QA
- Recommended status: Not Ready
- Reason: Sprint 1 now has real repo-check and build evidence, but the structural smoke path failed due to Apple Silicon tool incompatibility and no live Studio/runtime proof has been captured yet for the gameplay matrix. The smoke harness wording issue is fixed, but live Roblox/operator validation is still required before QA can honestly flip the gate.

## 2026-04-02 — TaskNodes bootstrap smoke hotfix

### Objective
- Investigate and fix the new smoke failure: `TaskNodes folder was not created by the round bootstrap`.

### Commands run
#### `bash scripts/build.sh && run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
- Result: Reproduced fail
- Output:
```text
[WARN  librojo::snapshot_middleware::json_model] Model at path Remotes.model.json had a top-level Name field. This field has been ignored since Rojo 6.0.
        Consider removing this field and renaming the file to /Users/macmini/RobloxProjects/closing-shift-superstore-3am/src/ReplicatedStorage/Remotes.model.json.
Building project 'ClosingShift'
Built project to ClosingShift.rbxlx
user_run_in_roblox-50312.rbxmx.run-in-roblox-plugin.Main:54: TaskNodes folder was not created by the round bootstrap
user_run_in_roblox-50312.rbxmx.run-in-roblox-plugin.Main:54
user_run_in_roblox-50312.rbxmx.run-in-roblox-plugin:79

Stack Begin
Script 'user_run_in_roblox-50312.rbxmx.run-in-roblox-plugin', Line 84
Stack End

(Command exited with code 1)
```

#### Diagnostic harness against the built place
- Command:
```bash
run-in-roblox --place build/ClosingShift.rbxlx --script scripts/tmp_diag.lua
```
- Result: Pass (diagnostic only; temp script removed after use)
- Output:
```text
DIAG: has bootstrap script true
DIAG: preexisting TaskNodes false
DIAG: require ShiftService ok true
DIAG: after require TaskNodes true
DIAG: after start TaskNodes true
DIAG: node restock_shelf_node
DIAG: node clean_spill_node
DIAG: node take_out_trash_node
DIAG: node return_cart_node
DIAG: node check_freezer_node
DIAG: node close_register_node
```
- Finding:
  - `TaskService` / `ShiftService` can create and populate `Workspace.TaskNodes` correctly.
  - In the `run-in-roblox` smoke environment, the harness was asserting before the `ServerScriptService` bootstrap path had run.

#### `bash scripts/build.sh && run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
- Result: Pass after hotfix
- Output:
```text
[WARN  librojo::snapshot_middleware::json_model] Model at path Remotes.model.json had a top-level Name field. This field has been ignored since Rojo 6.0.
        Consider removing this field and renaming the file to /Users/macmini/RobloxProjects/closing-shift-superstore-3am/src/ReplicatedStorage/Remotes.model.json.
Building project 'ClosingShift'
Built project to ClosingShift.rbxlx
SMOKE_OK: core folders and scripts are present
SMOKE_OK: sprint 1 round loop structure is present
```

### Hotfix made
- `project/scripts/smoke_runner.lua`
  - The smoke harness now explicitly requires `Round/ShiftService` and calls `shiftService.start()` before asserting for runtime-created instances.
  - `ShiftService.start()` is already idempotent, so this remains safe if a future runtime path auto-starts the bootstrap earlier.

### Scope note
- No `project/src/**` gameplay module change was required for this defect.
- The failing condition was the smoke harness bootstrap assumption, not a broken `TaskRegistry` / `TaskService` node-generation path.

## 2026-04-02 — Sprint 1 live runtime pass (headless Roblox-engine evidence + phone HUD hotfix)

## Session metadata
- Date/time: 2026-04-02 01:11:50 CDT
- Build artifact: `project/build/ClosingShift.rbxlx`
- Studio / local server mode used: `run-in-roblox` against the built place with `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`; actual engine modules ran inside Roblox Studio, but the harness had to use fake round-player tables because headless `run-in-roblox` cannot create `Player` instances (`WritePlayer` capability missing)
- UI capture automation availability: unavailable on this host during the pass; `peekaboo permissions` reported `Screen Recording (Required): Not Granted` and `Accessibility (Required): Not Granted`
- Testers: engineer subagent only
- Branch / commit: unavailable; this mounted workspace copy is not a git checkout

---

## Test A — 1-player success path
- Pass / Fail: Pass (server-authoritative headless proof)
- Intermission observed: `15` seconds configured at runtime module load; full `ShiftService` intermission loop still requires real `Players`
- Round timer observed: `540` seconds configured at runtime module load
- 1-player quota observed: `Restock 2 | Spill 1 | Trash 1 | Cart 2 | Freezer 1 | Register 1` (total `8`)
- `Close Register` locked before completion: Yes; prompt stayed disabled with `Finish all other tasks first`
- `Close Register` unlocked after quotas complete: Yes; prompt enabled immediately after the last non-register quota hit `0`
- Success payout amount: `$165` (`$130` base pay + `$35` success bonus)
- `Cash` before: `$0` in the payout stub used by the harness
- `Cash` after: `$165` in the payout stub used by the harness
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: Completed the full solo quota path through the real `TaskService`/`PayoutService` modules inside Roblox Studio headless runtime. No mismatch vs locked Sprint 1 quota, register gate, or success payout math. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test B — 1-player failure path
- Pass / Fail: Pass (failure payout path + clamp proven headless)
- Failure payout amount: `$8` from a `$14` bank (`floor(14 * 0.60)`)
- `Cash` before: `$0` in the payout stub used by the harness
- `Cash` after: `$8` in the payout stub used by the harness
- Negative clamp issues observed: None; heavy personal penalty still clamps payout to `0`
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: Verified the real `PayoutService` failure formula and clamp behavior in Roblox Studio headless runtime. This did not exercise the literal `ShiftService` countdown-to-zero loop because headless runtime could not spawn real `Players`. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test C — Blackout mid-hold
- Pass / Fail: Pass
- Blackout count observed: `1`
- Duration observed: `10.0` seconds
- In-progress hold completed during blackout: Yes; a hold marked in progress before blackout still completed and incremented progress
- New interactions blocked during blackout: Yes; a fresh interaction target stayed disabled and returned `Blackout — wait for backup power`
- Interactions restored after blackout: Yes; prompt re-enabled after blackout ended
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: Used the real `TaskService` plus `EventService` in headless runtime. Observed `blackout starts=1`, `blackout ends=1`, and `observedDuration=10.0s`; no duplicate blackout fired in the forced once-per-round pass. Code changed during this test: none. Screenshot/clip requirement remains unfulfilled in headless mode.

## Test D — Mimic expire path
- Pass / Fail: Pass
- Mimic appeared: Yes; one eligible node was marked mimic
- Lifetime observed: `18` seconds
- Expired cleanly: Yes; mimic cleared with no script breakage
- Timer effect on expire: None (`540` stayed unchanged in the harness timer)
- Payout effect on expire: None (`basePay` stayed `0`, no penalties recorded)
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: Real `TaskService` mimic activation/expiration path behaved to spec in headless Roblox runtime. Code changed during this test: none. Screenshot/clip requirement remains unfulfilled in headless mode.

## Test E — Mimic trigger path (solo)
- Pass / Fail: Pass
- Timer before: `540`
- Timer after: `532`
- Observed timer delta: `-8`
- Triggering player projected / banked value before: `banked=0`, projected success payout `35`
- Triggering player projected / banked value after: `banked=0`, projected success payout `23`
- Observed penalty: `-$12` to the triggering player only
- Node lockout observed: Yes
- Lockout duration observed: `8.00` seconds remaining immediately after trigger
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: Triggering the mimic on a solo round caused exactly one `-8s` team timer hit, exactly one `-$12` personal penalty, no base-pay credit, and no duplicate penalty on immediate retry. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test F — 2-player personal-only penalty proof
- Pass / Fail: Pass
- Shared timer before: `540`
- Shared timer after: `532`
- Observed timer delta: `-8`
- Player A penalty observed: `12`
- Player B penalty observed: `nil` / none
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: The mimic penalty map only populated the triggering player’s userId, the shared timer dropped exactly once, and another real task still completed afterward (`completed=1`, `banked=14`), so the round stayed playable. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test G1 — Late join
- Pass / Fail: Pass (server exclusion path proven headless)
- What late joiner saw: Targeted alert `Shift in progress. Wait for the next one.`
- HUD/state initialized correctly: Unproven in client UI; server-side exclusion path behaved correctly
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: A late-joiner-equivalent actor could not advance active-round progress and got the correct wait-for-next-shift alert. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test G2 — Leave before payout
- Pass / Fail: Pass (award path proven headless)
- Remaining player payout correct: Yes; remaining player received `$8`
- Leaving player caused save/runtime issue: No; leaving player was skipped and caused no award-path error
- Evidence files: `project/build/ClosingShift.rbxlx`; headless console output from `/Users/macmini/.openclaw/workspace-engineer/tmp/runtime_proof_harness.lua`
- Notes: The real `PayoutService.awardPlayers` function skipped a player whose `Parent` was `nil` and still awarded the remaining player correctly. Code changed during this test: none. Screenshot requirement remains unfulfilled in headless mode.

## Test H — Phone-sized HUD
- Pass / Fail: Pass after hotfix (layout-level proof; still needs final live viewport screenshot from QA)
- Critical text readable: Yes after hotfix; the panel and rows now auto-size instead of clipping into fixed-height slots
- Clipping observed: Pre-fix yes by layout math; post-fix no fixed-height container clipping path remains
- Alerts readable: Yes after hotfix by layout design (`Alert` row now auto-sizes)
- Objectives readable: Yes after hotfix by layout design (`Objectives` row now auto-sizes)
- Payout/readout readable: Yes after hotfix by layout design (`Banked` row now auto-sizes)
- Evidence files: `project/src/StarterGui/HUD.client.lua`; `project/build/ClosingShift.rbxlx`; `bash scripts/check.sh && bash scripts/build.sh` pass output
- Notes: Pre-fix HUD panel height was fixed at `32%` of screen height while the stacked fixed rows totaled about `302px` before any extra wrapping. Exact phone proof on a `375x667` viewport: `preFrameHeight=213.44`, `preContentHeight=302`, `overflow=88.56`. Minimal Sev 2 hotfix applied: panel switched to `AutomaticSize.Y`, labels switched to `AutomaticSize.Y`, and a `UISizeConstraint` (`min width 260`, `max width 360`) was added so narrow-phone text has enough width to wrap cleanly. Post-fix proof: `postWidth=260`, `panelAutomaticHeight=true`, `labelAutomaticHeight=true`, clipping risk removed at the container level because rows now grow instead of truncating inside fixed slots. Retest: `bash scripts/check.sh && bash scripts/build.sh` passed after the fix. Exact code changed: `project/src/StarterGui/HUD.client.lua`.

---

## Defects found
- ID: S1-HUD-01
- Severity: Sev 2
- Repro: Open `project/src/StarterGui/HUD.client.lua` and measure the pre-fix layout. The panel height was fixed to `32%` of the viewport, while the stacked fixed row heights plus padding/gaps totaled about `302px`. Exact proof on a `375x667` phone viewport: `preFrameHeight=213.44`, `preContentHeight=302`, `overflow=88.56`, so the HUD necessarily clips before accounting for extra wrap on the long banked/objective/alert text.
- Expected: Phone-sized HUD stays readable; critical text and alerts are not clipped.
- Actual: Pre-fix phone layout had guaranteed vertical overflow and would clip HUD content on common phone-sized viewports.
- Files changed to fix: `project/src/StarterGui/HUD.client.lua`
- Retest result: Pass. After the hotfix, `bash scripts/check.sh && bash scripts/build.sh` passed, the HUD panel now auto-grows vertically, and the text rows auto-grow with it instead of truncating inside fixed-height slots.

## 2026-04-02 — Late-join HUD wait-state hotfix

### Bug before the fix
- In live play, a player who joined after the round was already in `Playing` could land on the normal in-round HUD instead of a clear wait-for-next-shift state.
- The server already snapshotted the active roster and `TaskService:_handlePromptTriggered()` still rejected non-roster players, but the client HUD did not consume the replicated `activeUserIds` snapshot.
- The client mostly relied on the one-shot `AlertRaised` mid-round-join message, which can be missed during join/bootstrap timing before the HUD script has connected its remote listeners.
- Result: the late joiner looked like they were in the live round, no stable wait-for-next-shift HUD/alert appeared, and the UX read as "I can join this shift now" even though the server-authoritative round roster was supposed to exclude them.

### Files changed
- `project/src/StarterGui/HUD.client.lua`

### What changed
- The HUD now tracks `payload.activeUserIds` from every `RoundStateChanged` snapshot.
- If the local player is not in the round-start roster while the round state is `Playing`, the HUD now initializes and stays in a wait-for-next-shift view instead of rendering the active-round objective/payout guidance.
- The late joiner now gets:
  - `State: Waiting for next shift`
  - pinned alert text `Shift in progress. Wait for the next one.`
  - objective text `Objectives: Shift in progress. Wait for the next one.`
  - payout/banked copy `Current shift is locked to the starting roster. You'll clock in next round.`
- While in that excluded state, the HUD ignores active-round alert spam (for example blackout/global round alerts) so the wait message stays stable and unambiguous.

### Late-join participation / payout rule after the fix
- Active-round participation remains blocked server-side by the existing round-start roster snapshot in `ShiftService` and the `TaskService:_isRoundPlayer()` gate.
- Active-round payout remains restricted to the round-start player snapshot passed into `PayoutService.awardPlayers()`.
- The hotfix did **not** broaden round access; it only makes the excluded client initialize into the correct wait state so the live UX matches the locked Sprint 1 rule.

### What was rerun
- `bash scripts/check.sh && bash scripts/build.sh && run-in-roblox --place build/ClosingShift.rbxlx --script ../tmp/late_join_proof.lua`
  - `check.sh`: passed implicitly; the chained command continued into `build.sh`
  - `build.sh`: passed; Rojo built `build/ClosingShift.rbxlx`
  - first `run-in-roblox` attempt: failed only because the proof harness path was outside the project root (`failed to open file ../tmp/late_join_proof.lua`)
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/late_join_proof.lua`
  - passed
  - output:
    - `LATE_JOIN_PROOF progress_before=0 progress_after=0`
    - `LATE_JOIN_PROOF banked_before=0 banked_after=0`
    - `LATE_JOIN_PROOF late_join_alert=Shift in progress. Wait for the next one.`
    - `LATE_JOIN_PROOF can_participate=false`
    - `LATE_JOIN_PROOF_OK`

### What the late joiner now sees
- A stable wait-for-next-shift HUD state instead of the normal active-round participation copy.
- A persistent wait alert even if the original one-shot join alert was missed during bootstrap.

### Can the late joiner participate during `Playing`?
- Server-authoritative rule: **No.**
- This remained true before and after the hotfix; the change closes the client-state gap so the late joiner no longer appears to be an active participant.

### Does HUD/state initialize cleanly now?
- By code path: **Yes.** The HUD no longer depends on the timing of a single remote alert for late-join initialization; it derives the wait state from replicated round snapshot data on every state update.
- Narrow command-backed rerun: **Yes for exclusion behavior.** The late-join proof rerun confirmed no progress change, no banked-pay change, and the correct wait alert.

### Remaining caveat
- This session now has command-backed proof for late-join exclusion plus the HUD-state hotfix implementation.
- A human-observed real client screenshot/clip would still be the strongest presentation artifact if QA wants to fully close the last player-visible evidence gap.

## 2026-04-02 — Sprint 2 narrow clarity-validation pass

### Validation A — Phone-sized HUD pass
- Test name: Sprint 2 phone-sized HUD pass
- Date/time: 2026-04-02 23:20:28 CDT
- Environment/setup:
  - Build artifact: `project/build/ClosingShift.rbxlx`
  - Runtime path: `run-in-roblox` against the built place using `/Users/macmini/.openclaw/workspace-engineer/tmp/hud_text_probe.lua` and `/Users/macmini/.openclaw/workspace-engineer/tmp/hud_panel_height_probe.lua`
  - Phone-safe target used for the probe: panel width `260px`, inner text width `236px`
  - No screenshots/clips available from this session; the harness can execute Roblox runtime scripts but cannot provide human-view captures here
- Pass / Fail: Pass (runtime text-bounds / layout proof)
- Exact observed behavior:
  - `State: Closing shift live`, timer, saved cash, active-play earnings lines, objectives lines, and round-end summary lines all fit inside the `236px` inner width without clipping.
  - Measured one-line fits included:
    - `Clear: $165 | Timeout: $78` → width `156`, height `14`
    - `Restock 2 | Spill 1 | Trash 1` → width `144`, height `13`
    - `Cart 2 | Freezer 1 | Reg locked` → width `168`, height `13`
    - `Cash added: +$153` → width `112`, height `14`
  - The two longest tutorial lines wrapped to two lines at the minimum width target but stayed readable inside the auto-growing alert slot:
    - `Follow the glow. Hold on a task to work.` → `2` lines, height `26`
    - `Task cash is banked. Register unlocks last.` → `2` lines, height `26`
  - Combined panel height stayed within a reasonable phone-safe stack:
    - active play worst-case sampled stack height: `221px`
    - round-end sampled stack height: `209px`
  - No fixed-height clipping path remains in the current HUD because the panel and labels are using automatic vertical sizing.
- Mismatch vs Sprint 2 clarity contract:
  - Minor copy/layout note only: two tutorial lines do not stay single-line at the strict `260px` minimum width.
  - This did **not** produce an overlap/clipping failure in the current HUD because the alert row expands vertically.
- Code changed: No
- Files changed: None
- Rerun after hotfix: No hotfix needed

### Validation B — First-time-player / no-verbal-coaching pass
- Test name: Sprint 2 first-time-player / no-verbal-coaching pass
- Date/time: 2026-04-02 23:20:28 CDT
- Environment/setup:
  - Attempted to execute a truer client-side pass first using `run-in-roblox` probes for local player creation
  - Runtime capability limits in this harness prevented creation of a real local/player client context:
    - `CreateLocalPlayer` failed with `lacking capability LocalUser`
    - direct `Player` creation failed with `lacking capability WritePlayer`
  - Because of that limitation, this session could not run an honest human-observed or true client-controlled no-verbal-coaching playthrough
- Pass / Fail: Fail (evidence blocked by client-runtime limitation)
- Exact observed behavior:
  - The subagent could not spawn a real first-time player client in the available Roblox runtime harness.
  - Source inspection still found the intended no-coaching teaching path in place:
    - goal tutorial at eligible intermission
    - follow-task tutorial on first playable snapshot
    - banked-pay/register-last tutorial on first task completion or `20s` fallback
    - register-end tutorial on first register unlock
    - locked register prompt stays `Finish all other tasks first`
  - That means the intended instructional sequence exists, but this pass did **not** directly observe whether a fresh player understands the objective, task-following, banked pay, and register-unlocks-last flow without help.
  - Tutorial timing therefore remains unjudged by human observation in this session; no honest too-early / too-late / just-right claim is made.
- Mismatch vs Sprint 2 clarity contract:
  - The blocker here is missing live first-time-player evidence, not a confirmed code-side design drift.
- Code changed: No
- Files changed: None
- Rerun after hotfix: No hotfix attempted; the blocker was environment/evidence, not a confirmed minimal code defect

### Validation C — 2-player blackout + mimic presentation sanity pass
- Test name: Sprint 2 2-player blackout + mimic presentation sanity pass
- Date/time: 2026-04-02 23:20:28 CDT
- Environment/setup:
  - Build artifact: `project/build/ClosingShift.rbxlx`
  - Runtime path: `run-in-roblox` against the built place using `/Users/macmini/.openclaw/workspace-engineer/tmp/coop_presentation_probe.lua`
  - Two fake round-player tables were used because this harness cannot create live `Player` instances, but the real `TaskService` and `EventService` modules executed inside Roblox runtime
  - No screenshots/clips available from this session
- Pass / Fail: Pass (runtime co-op presentation proxy)
- Exact observed behavior:
  - Blackout presentation:
    - alert definition observed: `blackout_active|Blackout. Wait for backup power.|cue=blackout_start`
    - task feedback state switched to `blackout`
    - task prompt switched to `Blackout — wait for backup power`
    - an already-held task remained finishable (`held_can_finish=true`)
    - a fresh task start remained blocked (`blocked_can_start=false`)
    - recovery alert definition observed: `blackout_end|Power restored. Get back to work.|cue=blackout_end`
    - measured blackout duration remained `10.0s`
  - Mimic presentation:
    - alert definition observed: `mimic_triggered|False task. Lost time and pay.|cue=mimic_triggered`
    - triggered mimic node changed from `available` to `mimic_lockout`
    - shared timer dropped from `540` to `532` (`-8s`)
    - personal penalty applied only to Player A: `12`
    - Player B penalty remained `nil`
  - Distinction remained clear in the runtime proxy:
    - blackout read as a store-wide power outage / temporary interaction block
    - mimic read as a false-task punishment with time + pay loss
    - the two did not present as the same gameplay consequence
- Mismatch vs Sprint 2 clarity contract:
  - None observed in the runtime proxy
  - Remaining limitation: this is still not a human-observed co-op session with two real clients on screen at once
- Code changed: No
- Files changed: None
- Rerun after hotfix: No hotfix needed

## 2026-04-02 — Final Sprint 2 blocker recheck: true no-coaching pass viability

- Test name: Sprint 2 first-time-player / no-verbal-coaching blocker recheck
- Date/time: 2026-04-02 23:38:52 CDT
- Environment/setup:
  - Build artifact refreshed with `cd project && bash scripts/build.sh`
  - Runtime path checked with `run-in-roblox` against `build/ClosingShift.rbxlx`
  - Diagnostic scripts used:
    - `/Users/macmini/.openclaw/workspace-engineer/tmp/diag_create_local_player.lua`
    - `/Users/macmini/.openclaw/workspace-engineer/tmp/diag_player.lua`
  - Goal of this recheck: determine whether this host can now execute a true fresh-player / no-verbal-coaching pass instead of another fake-player proxy
  - Screenshot/clip capture: unavailable in this session
- Pass / Fail: Fail (still blocked on true-player runtime capability)
- Exact observed behavior:
  - Build still succeeds; only the existing non-blocking Rojo warning on `Remotes.model.json` appeared.
  - `run-in-roblox --place build/ClosingShift.rbxlx --script /Users/macmini/.openclaw/workspace-engineer/tmp/diag_create_local_player.lua`
    returned:
    - `DIAG CreateLocalPlayer ok false`
    - `DIAG CreateLocalPlayer err The current thread cannot call 'CreateLocalPlayer' (lacking capability LocalUser)`
    - `DIAG count after 0`
  - `run-in-roblox --place build/ClosingShift.rbxlx --script /Users/macmini/.openclaw/workspace-engineer/tmp/diag_player.lua`
    returned:
    - `DIAG create player ok false`
    - `DIAG create player err The current thread cannot create 'Player' (lacking capability WritePlayer)`
  - Result: this host still cannot create a real `LocalPlayer` or even a writable `Player` instance inside the available Roblox runtime path, so it still cannot execute an honest first-time-player observation run.
- Hesitation/confusion points:
  - Not observable in this recheck because no true player session could be created.
- What the player understood without help:
  - Not observable in this recheck because no true player session could be created.
- Whether the tutorial / HUD / task cues were sufficient:
  - Unjudged by this recheck. Existing code/runtime-proxy evidence still says the intended cues are present, but this section does **not** claim they were sufficient for a real first-time player.
- Whether the player could complete the basic loop without verbal coaching:
  - Not tested. A true no-verbal-coaching player run was still impossible on this host.
- Whether banked pay and register-unlocks-last were understood:
  - Not observable in this recheck.
- Whether blackout and mimic consequences read clearly when encountered:
  - Not observable in this recheck with a true player; prior proxy evidence remains separate and does not satisfy this blocker.
- Code changed:
  - No
- Files changed:
  - `project/docs/RUNTIME-EVIDENCE.md`
- Whether the case was rerun after any hotfix:
  - No hotfix was justified or applied. The blocker remains evidence/runtime-access, not a confirmed clarity defect in `project/src/**`.
- Remaining blocker after this recheck:
  - One honest human-observed first-time-player / no-verbal-coaching pass is still required to close Sprint 2.
- Screenshot / clip references:
  - None available from this session


## Sprint 2 final blocker — true first-time-player / no-verbal-coaching pass

**Session**
- Date/time: not recorded
- Tester: human playtester (name not recorded)
- Build used: not recorded
- Device / viewport: not recorded
- Observer: not recorded
- Coaching given: none

**What the player understood without help**
- Goal understanding: yes
- Tutorial understanding: no tutorial was observed during this session
- Task understanding: yes
- Event understanding: yes
- Payout understanding: unclear

**Observed hesitation points**
1. Understanding what "Banked" means
2. Understanding how money is awarded at round end
3. Interpreting the payout/readout language without explanation

**Did the player complete the basic loop without coaching?**
- Yes
- Notes: the player completed the basic loop without verbal coaching

**Where the player got confused**
- bank
- money
- payout explanation

**What worked well**
- task execution
- basic objective following
- understanding how to interact with tasks

**What still felt unclear**
- money
- banked-pay meaning
- payout explanation

**Observer verdict**
- Pass
- Reason: Pass

**Artifact references**
- screenshot / clip / notes: none recorded; evidence is based on live human-observed notes
