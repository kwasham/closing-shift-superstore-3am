# Backlog

## Severity — high priority warning

### P1 — Clarify `Banked` / money / payout wording after first no-coaching pass
- **Owner:** design / QA / engineering
- **Why it matters:** the final human-observed no-coaching pass cleared the Sprint 2 blocker, but the player still hesitated on what `Banked` means and how round-end money is awarded.
- **Evidence behind it:** observed confusion on `Banked`, payout/readout language, and round-end money explanation; goal/task/event understanding still passed and the player completed the basic loop without coaching.
- **Definition of done:** tighten the wording enough that the next fresh-player check no longer stalls on money terminology.


### P1 — Live audio cue sanity check
- **Owner:** QA / content
- **Why it matters:** cue hooks are implemented, but real cue presence and behavior are still unverified.
- **Needed evidence:** confirm whether placeholder or final cues fire for task complete, register unlock, blackout start/end, mimic trigger, and round result.
- **Note:** missing cues are not supposed to block gameplay, but QA should explicitly verify whether silence is intentional or accidental.

### P1 — Clean the Rojo warning on `Remotes.model.json`
- **Owner:** engineering
- **Why it matters:** not a gameplay bug, but noisy build output makes future validation less clean.
- **Definition of done:** remove or rename the top-level `Name` usage so `bash scripts/build.sh` is warning-free.

### P1 — Capture shareable clarity artifacts
- **Owner:** QA
- **Why it matters:** the phone HUD and co-op presentation blockers are closed by runtime-backed evidence, but producer/demo use will still benefit from a few stable human-view artifacts.
- **Needed captures:**
  - late-join wait-state screenshot
  - phone-sized HUD screenshot
  - round-end summary screenshot
  - blackout or mimic presentation clip from a real co-op session
  - register-unlocked moment screenshot or short clip

## Severity — polish later

### P2 — Evaluate whether mimic needs a stronger pre-trigger tell after playtests
- **Owner:** design / QA / content
- **Why it matters:** Sprint 2 intentionally keeps mimic deceptive on spawn, but real-player fairness may still need tuning later.
- **When to revisit:** after the first no-coaching playtests.

### P2 — Persist tutorial completion and add replay control later
- **Owner:** design / engineering
- **Why it matters:** Sprint 2 tutorial is only session-scoped right now.
- **When to revisit:** once save-backed progression exists.

### P2 — Validate store readability against the real content-authored layout
- **Owner:** content / QA
- **Why it matters:** the docs are strong, but landmark readability still needs to be proven in the actual store art/layout pass.
- **Focus areas:** checkout landmarking, aisle headers, freezer silhouette, trash-route readability, cart-return silhouette.

### P2 — Expand deterministic smoke only where it adds real confidence
- **Owner:** engineering / QA
- **Why it matters:** smoke should keep buying signal without pretending to replace human clarity checks.
- **Rule:** prefer narrow deterministic assertions over brittle UI automation.

## Strategic follow-ups
- Design thumbnail and store-page package
- Decide whether future horror punishment should use health damage, sanity pressure, or timer-only pressure after MVP
- Roaming manager NPC
- Revive mechanic
- Seasonal event framework
- Extra stores
- Daily quests
