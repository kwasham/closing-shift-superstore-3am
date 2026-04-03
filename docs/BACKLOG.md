# Backlog

## P0 — Current blockers
- None.

## P1 — High-urgency follow-ups
- **Optional: capture a real-player late-join HUD artifact for demo/presentation strength**
  - Owner: QA
  - The blocker is cleared by the command-backed late-join proof already recorded in `project/docs/RUNTIME-EVIDENCE.md`.
  - A human-operated Studio/local-server screenshot or clip would still be useful for presentation, but it is no longer required to call Sprint 1 ready.
- **Clean up the Rojo warning on `Remotes.model.json`**
  - Owner: engineering
  - Remove the top-level `Name` field or rename the file as suggested by Rojo so build output is clean.
- **Optional: capture real 2-player HUD comparison for mimic penalty communication**
  - Owner: QA / UI
  - Core co-op penalty logic is already engine-backed and proven.
  - A real-player HUD comparison would reduce presentation risk if the team wants stronger demo evidence.
- **Expand smoke coverage only where deterministic and safe**
  - Owner: engineering / QA
  - Keep scope tight; prefer assertions that do not depend on unavailable real-player capabilities.

## P2 — Important, not blocking Sprint 1 gate
- **Tune mimic readability after first internal playtests**
  - Owner: design / content
  - Decide how subtle or obvious the false-task tell should be.
- **Playtest quota pacing and payout numbers with real completion-time data**
  - Owner: design / QA
  - Rebalance only after actual solo/co-op round timing is measured.
- **Evaluate whether co-op payout needs contribution-aware bonuses later**
  - Owner: design
  - Only revisit if idle/leech behavior becomes a real issue after MVP.
- **Replace MVP-generated task arena with final content-authored store layout**
  - Owner: content / engineering
  - Current generated task space is acceptable for validation, not final presentation.
- **Add clearer end-of-round summary surfacing who took mimic penalty**
  - Owner: UI / engineering
  - Nice-to-have if co-op players get confused about why payouts differ.

## Existing strategic items
- Design thumbnail and store-page package
- Decide whether future horror punishment should use health damage, sanity pressure, or timer-only pressure after MVP
- roaming manager NPC
- revive mechanic
- seasonal event framework
- extra stores
- daily quests
