# Closing Shift: Superstore 3AM — GDD

## One-line pitch
A 1–6 player co-op Roblox horror job sim where players close a supermarket at 3AM, complete store tasks, survive escalating paranormal events, and spend their paycheck on upgrades and cosmetics.

## Design pillars
1. **Instantly readable** — a player should understand the fantasy in under 10 seconds.
2. **Short tense rounds** — 8–10 minute sessions with rising pressure.
3. **Co-op chaos** — small mistakes create funny or scary moments with friends.
4. **Replay loop** — finish shift, earn payout, unlock more style and efficiency.
5. **Scope discipline** — one map, a handful of tasks, and two or three event types before any major expansion.

## Target session
- Players: 1–6
- Round length: 8–10 minutes
- Intermission: 15–20 seconds
- Goal: complete tasks and survive until shift end

## MVP systems
- Lobby + one playable grocery store
- Task system
  - restock shelves
  - clean spills
  - take out trash
  - return carts
  - check freezer
  - close register
- Round manager
- Basic event system
  - blackout
  - mimic / false task
- End-of-round payout
- One currency
- Light cosmetic shop
- HUD and round alerts
- Smoke test path

## Failure / tension model
- Players are under time pressure.
- Some tasks or events create risk.
- Failure should feel tense, not punishing enough to kill replayability.

## MVP monetization boundaries
Acceptable:
- cosmetics
- emotes
- flashlight skins
- private server
- extra loadout slots
- optional revive as a limited dev product

Avoid at MVP:
- heavy pay-to-win combat boosts
- multi-currency confusion
- deep stat grinds

## Future expansions
- new store types
- roaming manager enemy
- revive loop
- seasonal events
- social progression / badges

## Milestone 4 launch-candidate contract

### Player-facing currency and payout language
- Persistent profile currency is **`Saved Cash`**.
- In-round earnings before shift end are **`Shift Cash`**.
- `Cash` by itself is only acceptable on surfaces that show persistent currency only, such as shop prices, shop balance, or profile totals. Any surface that compares current-shift earnings against the persistent balance must spell out **`Saved Cash`**.
- Remove standalone **`Banked`** wording from launch-facing HUD, tutorial, late-join, and results surfaces.
- Active-shift payout preview must use outcome-first phrasing instead of unexplained shorthand:
  - `Shift Cash: $X`
  - `If you clear: +$Y`
  - `If time runs out: +$Z`
  - optional `False task penalty: -$P`
- Round-end payout summary must preserve the existing Sprint 1–3 economy rules and use:
  - `Shift Cash: $X`
  - success branch `Clear bonus: +$35`
  - failure branch `Timeout pay (60%): $Z`
  - optional `False task penalty: -$P`
  - `Saved Cash added: +$A`

### First-10-minute clarity rules
- Mandatory opening/tutorial wording:
  - round-start hint: `Clock in. Follow the glow to your first task.`
  - goal tutorial: `Finish the task list before the timer hits zero.`
  - in-round earnings tutorial: `Tasks add Shift Cash. Register unlocks last.`
  - late-join pinned alert stays `Shift in progress. Wait for the next one.`
- Late-join support copy must make two facts obvious without extra explanation:
  - the current shift started without that player
  - that player joins the next round instead of earning from the active one
- Allowed layout changes for Sprint 4:
  - auto-size and wrap the existing HUD / alert / objective / results text
  - increase results-card height or allow vertical scrolling if copy wraps
  - reorder existing payout lines so the `Saved Cash` landing is obvious
- Explicitly out of scope for Sprint 4 clarity work:
  - new tutorial systems or extra tutorial steps beyond the existing sequence
  - new HUD panels, popups, tabs, or economy explainer modals
  - any payout, XP, timer, quota, shop-price, or progression rebalance unless a confirmed blocker forces it

### Publish surface contract
- **Recommended title:** `Closing Shift: Superstore 3AM`
- **Recommended tagline:** `Close the store. Survive the shift.`
- **Short description direction:** `1–6 players close a haunted supermarket at 3AM: finish tasks, survive blackout, false-task, and security-alarm disruptions, then cash out for cosmetics.`
- **Long description direction:**
  1. Lead with the co-op overnight supermarket fantasy: restock shelves, clean spills, take out trash, return carts, check the freezer, and close the register.
  2. Call out the real disruption set only: blackout, false tasks, and security alarms.
  3. Explain the real reward loop only: finish shifts to add `Saved Cash` and XP, then spend `Cash` on cosmetic nameplates and lanyards.
  4. Position the game as short replayable 8–10 minute rounds for 1–6 players.
  5. Do **not** promise extra maps, roaming enemies, combat, badges, live-event content, or monetization expansion.
- **Icon brief:** a readable fluorescent superstore-at-3AM image with checkout / aisle readability first, late-night dread second, and no monster close-up, combat pose, or extra-location promise.
- **Three thumbnail beats:**
  1. a co-op work shot with obvious supermarket tasks and timer pressure
  2. a disruption shot centered on blackout or false-task tension inside the same store
  3. a progression / payoff shot showing post-shift cosmetics or results readability without implying deeper inventory scope
- **Genre / mood guidance:** co-op horror job sim, late-night retail tension, short-session replayability, social panic and confusion over gore or chase-combat fantasy.
- **Content-maturity disclosure notes:** mild horror tension, darkness, sudden alarms / blackout states, and paranormal fake-out moments; no graphic gore or explicit violence focus.
- **Release-note headline bullets:**
  - clearer `Shift Cash` vs `Saved Cash` wording
  - clearer late-join and results wording
  - hardened phone-sized readability on launch-facing UI
  - launch-candidate hardening and low-risk build cleanup

### Launch proof bar
- Milestone 4 is not ready on headless proof alone. The team needs actual client-visible evidence for tutorial/start readability, active-HUD readability, late-join readability, and results readability.
- Broader analytics dashboards are follow-up work, not a Milestone 4 blocker, as long as the required runtime proof, client proof, release checklist, and watchlist evidence exist.

## Open questions
- exact revive design
- how punishing mimic tasks should be
- whether stamina exists in MVP or later
