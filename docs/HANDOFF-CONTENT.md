# Content handoff

Use this file when engineering, production, or QA needs the locked Sprint 4 release-facing content package.

## Objective
Deliver a truthful launch-candidate content layer for the current build only.

Focus on:
- store-page copy that matches the real one-store experience
- in-game wording alignment for public-facing terms
- release notes for the current build
- icon / thumbnail / positioning guidance QA can validate against

Do **not** expand the promise beyond the existing build.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT4-PLAN.md`
- `project/docs/LAUNCH-WATCHLIST-S4.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/STORE-PAGE-BRIEF-S4.md`
- `project/docs/RELEASE_NOTES.md`

## Files edited for Sprint 4
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/STORE-PAGE-BRIEF-S4.md`
- `project/docs/RELEASE_NOTES.md`

## Locked player-facing wording alignment

### Core positioning
Use:
- `co-op horror job sim`
- `late-night supermarket`
- `short 8–10 minute shifts`
- `blackout, false tasks, and security alarms`

Avoid:
- `combat horror`
- `monster chase`
- `escape story`
- `multiple maps`
- `upgrade-heavy progression`

### Money and progression language
Use:
- `Shift Cash` for in-round earnings
- `Saved Cash` for the persistent balance
- `Cash` alone only when the surface is clearly persistent-only
- `Cash buys cosmetics`
- `XP and level unlock cosmetics only`

Avoid:
- `Banked`
- `upgrades` on store/release surfaces
- any wording that implies gameplay power purchases

### Event naming
External/player-facing preference:
- `false task`
- `security alarm`
- `blackout`

Internal shorthand like `mimic` may exist in docs/code, but player-facing store copy should prefer `false task` because it reads faster.

### Co-op and tension framing
Preferred framing:
- close the store with 1–6 players
- complete supermarket tasks before time runs out
- survive disruptions that waste time, split attention, and create panic

Do not frame the build as:
- a combat survival game
- a killer-vs-players game
- a lore-driven narrative campaign

## Release-surface acceptance criteria
- Title/tagline/description stay truthful to the one-store build.
- No release surface promises extra maps, enemies, combat, badges, live events, or monetization expansion.
- Publish copy makes the payoff loop clear: finish shifts, earn `Saved Cash` and XP, buy cosmetics.
- Mobile-readable wording stays short enough for store and update surfaces.
- QA can compare the store-page package against the live build without guessing intent.

## QA spot-check list for content
- Title matches `Closing Shift: Superstore 3AM`.
- Tagline matches `Close the store. Survive the shift.`
- Short description only mentions real tasks/disruptions/payoff.
- Long description does not imply extra locations or combat.
- Release notes call this a clarity/hardening build, not a major feature expansion.
- Thumbnail/icon art direction still reads as supermarket work + dread, not monster action.

## Known wording watch item
There is one doc-level mismatch still worth resolving outside this handoff:
- `project/docs/GDD.md` one-line pitch still says players spend their paycheck on `upgrades and cosmetics`.
- Sprint 4 launch-facing guidance is locked to cosmetics/progression only, with no gameplay-upgrade promise.

Flag this as a doc contradiction for follow-up rather than mirroring `upgrades` on release surfaces.
