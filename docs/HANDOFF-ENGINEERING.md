# Engineering handoff

Use this file when design has a concrete implementation brief for engineering.

## Objective
Implement the Sprint 4 launch-candidate hardening pass on the existing build only.

Focus on:
- launch-facing wording cleanup
- phone-width readability on the current HUD / results / late-join surfaces
- results-screen clarity around payout landing in persistent currency
- optional low-risk cleanup of the non-blocking `Remotes.model.json` warning

Do **not** expand scope into new gameplay, new UI systems, new monetization, or economy rebalance.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT4-PLAN.md`
- `project/docs/LAUNCH-WATCHLIST-S4.md`
- `project/docs/RELEASE-CHECKLIST-S4.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Files to edit
### Required target files
- `project/src/ReplicatedStorage/Shared/UIStrings.lua`
- `project/src/StarterGui/HUD.client.lua`
- `project/src/StarterGui/Sprint3UI.client.lua`

### Optional low-risk target file
- `project/src/ReplicatedStorage/Remotes.model.json`

### Only if needed for proof capture
- `project/scripts/**`
- `project/docs/RUNTIME-EVIDENCE.md`

## Hard no-change rules
Do not change:
- payout formulas
- success bonus amount
- timeout-pay multiplier
- task quotas
- XP rules
- shop prices / unlock requirements
- event roster
- map scope
- late-join participation rules

Sprint 4 is a wording / readability / release-hardening pass, not a systems pass.

## Locked copy contract

### 1) Persistent vs current-shift money
Use these terms exactly on player-facing launch surfaces:
- **`Saved Cash`** = persistent profile balance
- **`Shift Cash`** = current-round earnings before payout

Rules:
- Remove standalone **`Banked`** from launch-facing HUD, tutorial, late-join, and results surfaces.
- Use plain `Cash` only on surfaces that are clearly persistent-only already, such as shop prices or shop totals.
- Any surface that compares current-round earnings against the persistent balance must spell out **`Saved Cash`**.

### 2) HUD wording requirements
#### Persistent balance line
- Use: `Saved Cash: $%d`
- Do not use: `Saved cash`, `Cash` alone, or `Banked`

#### Active-shift earnings block
Use this order and meaning:
1. `Shift Cash: $%d`
2. `If you clear: +$%d | If time runs out: +$%d`
3. optional `False task penalty: -$%d`

Do not show bare `Clear: $%d | Timeout: $%d`.

#### Round-end HUD summary
Use this order and meaning:
1. `Shift Cash: $%d`
2. success branch: `Clear bonus: +$35`
3. failure branch: `Timeout pay (60%): $%d`
4. optional `False task penalty: -$%d`
5. `Saved Cash added: +$%d`

The math must stay identical to the current Sprint 1–3 behavior.

### 3) Tutorial / alert wording requirements
- Round-start hint: `Clock in. Follow the glow to your first task.`
- Goal tutorial: `Finish the task list before the timer hits zero.`
- Earnings tutorial: `Tasks add Shift Cash. Register unlocks last.`
- Late-join pinned alert remains: `Shift in progress. Wait for the next one.`
- `Close Register` unlock copy may stay close to the existing wording, but it must still read clearly after the `Shift Cash` rename.

### 4) Late-join support copy requirements
The late-join state must make two facts obvious without outside explanation:
- this shift started without the player
- the player joins the next round instead of earning from the active one

Acceptable implementation on the current HUD:
- state: `Waiting for next shift`
- pinned alert: `Shift in progress. Wait for the next one.`
- supporting objective / earnings text that plainly says the current shift started without the player and the next shift is where they can earn payout

Do not let the late joiner look like an active participant.

### 5) Results-screen wording requirements
Keep the existing results card flow, but make the money landing explicit.

Use this body line order:
1. `Saved Cash added: +$%d`
2. `XP earned: +%d`
3. `Current Level: %d`
4. `Totals — Saved Cash $%d • XP %d`

Results titles may remain:
- `Results — Shift Cleared`
- `Results — Shift Failed`

Do not add a new results system or extra modal explanation layer.

## Layout / hierarchy rules
Allowed Sprint 4 layout work:
- auto-size/wrap existing labels
- increase existing results-card height
- allow vertical scrolling if that is the lowest-risk fix for narrow phones
- reorder existing payout lines to improve readability

Not allowed:
- new tabs
- new popups
- new tutorial panels
- new HUD modules
- decorative layout churn that risks the proven Sprint 1–3 baseline

Priority on narrow phones:
1. state
2. timer
3. `Saved Cash`
4. current alert
5. objectives
6. payout/readout block

Clipped launch-facing text is a blocker.

## Live proof expectations for engineering
Before calling implementation done, capture both command-backed regression proof and actual client-visible readability proof.

### Regression proof
Need command/results evidence for:
- `bash scripts/check.sh`
- `bash scripts/build.sh`
- structural smoke
- payout still landing in persistent `Cash`
- late-join exclusion still working
- blackout / false task / security alarm sanity after the wording pass
- shop still spending persistent `Cash`

### Client-visible readability proof
Need at least one actual client-visible artifact for each of these surfaces:
- first playable HUD with the new `Shift Cash` / `Saved Cash` wording
- late-join wait state
- results screen after a shift

Headless or layout-probe evidence can support the case, but it does **not** replace actual client-visible proof for Sprint 4 signoff.
If a proof item cannot be captured in-session, leave it explicitly unverified instead of implying it passed.

## Low-risk Rojo warning cleanup
If safe, clean up the non-blocking warning in:
- `project/src/ReplicatedStorage/Remotes.model.json`

Allowed cleanup:
- remove the ignored top-level `Name` field only

Not allowed in Sprint 4:
- child remote renames
- folder lookup changes
- broader Rojo structure refactors

If any risk appears, defer the cleanup and document why.

## Acceptance criteria
- No player-facing `Banked` remains on the Sprint 4 launch surfaces.
- A fresh player can tell the difference between current-round earnings and persistent balance without explanation.
- Results wording makes it obvious what amount was added to `Saved Cash`.
- Late join clearly reads as wait-for-next-shift, not active participation.
- HUD / results text stays readable on phone-width layouts.
- No Sprint 1–3 gameplay, progression, or payout rule regresses.
- Any remaining unverified item is called out honestly in runtime evidence / QA notes.
