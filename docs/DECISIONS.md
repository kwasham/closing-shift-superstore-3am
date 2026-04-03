# Decisions

## Decision log
- Use a text-first Rojo workflow instead of a Studio-only binary workflow.
- Keep MVP to one store map and one currency.
- Server owns round state, rewards, and dangerous events.
- Cosmetics come before strong power monetization.
- OpenClaw uses `main` as orchestrator plus worker agents for design, engineering, content, and QA.
- 2026-04-03 — Sprint 3 is locked to a small alpha return loop only: `Security Alarm`, persistent `XP` / `Level`, a lobby/non-playing cosmetic shop v1, and KPI instrumentation. No NPCs, combat, second map, battle pass, subscription, or Robux rollout work is included.
- 2026-04-03 — `Security Alarm` is a once-per-round server-owned event using `security_panel_node`, a 15.0 second response window, a 2.0 second hold, and a single shared fail penalty of `-12s`. It does not deal damage, does not remove cash, and does not overlap active blackout or active mimic.
- 2026-04-03 — While `Security Alarm` is active, blackout start, mimic spawn, and `Close Register` unlock are all deferred until the alarm resolves or fails. If the alarm cannot legally start before 45 seconds remain, it is canceled for that round rather than forced into the endgame.
- 2026-04-03 — Sprint 3 progression is persistent but non-power. `Cash` remains spendable soft currency. `XP` and `Level` exist only to show Employee Rank and gate cosmetics. They do not modify speed, stamina, health, payout multipliers, task timings, or event timings.
- 2026-04-03 — Sprint 3 progression saves `ProfileVersion`, `Cash`, `XP`, `Level`, `ShiftsPlayed`, `ShiftsCleared`, `OwnedCosmetics`, and `EquippedCosmetics`. `XP` is the source of truth for `Level` if a mismatch is detected.
- 2026-04-03 — Sprint 3 shop scope is exactly 2 slots (`NameplateStyle`, `LanyardColor`) and 6 paid starter items. Purchase and equip are separate actions. Default items are always owned, and players can swap back to those defaults at any time.
- 2026-04-03 — Sprint 3 cosmetics are verified through simple 2D lobby/results presentation, not 3D accessory production. This keeps the cosmetic loop QA-visible without widening content scope.
- 2026-04-03 — Sprint 3 analytics names are locked to exact snake_case events documented in `project/docs/KPI-CANDIDATES-S3.md` and `project/docs/HANDOFF-ENGINEERING.md`. Structured local/server log evidence using those exact names is acceptable if dashboard propagation lags.
