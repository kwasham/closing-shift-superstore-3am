# Decisions

## Decision log
- Use a text-first Rojo workflow instead of a Studio-only binary workflow.
- Keep MVP to one store map and one currency.
- Server owns round state, rewards, and dangerous events.
- Cosmetics come before strong power monetization.
- OpenClaw uses `main` as orchestrator plus worker agents for design, engineering, content, and QA.

## 2026-04-03 — Sprint 4 launch-candidate locks
- Player-facing economy terms are locked to `Shift Cash` for current-round earnings and `Saved Cash` for the persistent balance. Standalone `Banked` wording is removed from launch-facing HUD, tutorial, late-join, and results surfaces.
- `Clear` and `Timeout` cannot appear as unexplained standalone payout labels. Sprint 4 copy must use outcome-first phrasing such as `If you clear`, `If time runs out`, `Clear bonus`, and `Timeout pay (60%)`.
- Sprint 4 clarity work is limited to copy, ordering, wrap/auto-size, and other low-risk hierarchy changes on the existing HUD / results / late-join surfaces. No new UI system, no new gameplay tutorial system, and no economy-rule changes are allowed in this sprint.
- Publish-surface copy is locked to the current build: one supermarket, short co-op horror closing shifts, blackout + false task + security alarm disruptions, and cosmetic `Cash` spending. Do not promise roaming enemies, combat, extra maps, live events, badges, or monetization expansion.
- Milestone 4 readiness requires actual client-visible proof for tutorial/start readability, active HUD readability, late-join readability, and results readability. Headless or harness proof still counts for regression coverage, but it is not enough by itself for launch-facing clarity signoff.
- The `Remotes.model.json` Rojo warning may be cleaned up only by removing the ignored top-level `Name` field if the build stays stable. Any broader remote-folder or Rojo-structure refactor is deferred.
