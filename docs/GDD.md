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

## Current production lock — Sprint 7 full-store visual rollout
**Sprint 7 style sentence:** Closing Shift should now read as a fluorescent suburban supermarket that is modular, phone-legible, and subtly wrong—an ordinary late-night retail box where every player-traversed space shares the same signage grammar, material language, and lighting rhythm, and where the horror lands through contrast and disruption instead of bespoke hero clutter.

### Sprint 7 scope lock
Sprint 7 is a full-store visual rollout and store-presence sprint only.

In scope:
- remaining player-visible spaces
- signage and wayfinding pass
- performance-budget guardrails
- store-presence assets: icon, thumbnails, update/social shots

Out of scope:
- new gameplay systems
- new events or event mechanics
- economy changes
- matchmaking or combat work
- map expansion beyond already playable / visible areas
- bespoke hero-art pipelines that break shippability

### Full-store rollout tiers
#### Tier A — must look production-ready this sprint
- lobby / entrance
- all main playable aisles
- checkout zone and immediate queue space
- freezer / cooler path
- stockroom corner and any entered back-of-house space
- all transitions between those zones

#### Tier B — must be consistent, even if lighter detail
- secondary aisle edges
- sightline background walls and ceiling runs
- visible staff hall segments
- visible corners adjacent to active task nodes

#### Tier C — can stay simpler only if hidden or non-traversed
- unseen backsides of fixtures
- sealed-off or never-seen support spaces
- distant background views outside the playable frame

### Primitive replacement rule
Must disappear from Tier A and normally visible Tier B sightlines this sprint:
- raw gray floors, walls, and ceilings
- single-color block shelves and checkout counters
- primitive freezer blocks
- placeholder doors on playable thresholds
- unlabeled cube boxes, pallets, and stock props in readable spaces
- blank sign planes or floating temporary text markers

Acceptable remnants only if hidden from normal play and public capture:
- unseen backsides of modular fixtures
- sealed support-room internals
- ceiling or wall faces above normal sightlines
- fixture cores fully occluded by approved art shells
- distant exterior/background forms outside the playable frame

### Store-wide signage and wayfinding grammar
- **Aisle numbers:** one high-contrast hanging aisle marker per aisle mouth, readable from the main cross-aisle, using large numerals and a short secondary label only.
- **Category headers:** short retail nouns, mounted above the relevant bay or run, kept to one or two words so they stay phone-readable.
- **Checkout numbering:** large numerals above or immediately behind each lane so players can read checkout location at a glance from the front store.
- **Staff / hazard language:** direct operational wording only: `EMPLOYEES ONLY`, `STOCKROOM`, `FREEZER`, `WET FLOOR`, `NO ENTRY`, `BACK DOOR`, `EXIT`.
- **Sale card system:** one store-wide sale-card family with a consistent accent color, short headline, and large price read; sale cards cannot compete with gameplay alerts.
- **Emergency readability:** checkout, freezer, stockroom, and exits must remain locatable during blackout through silhouette, sign placement, and restrained emergency-color use.

### Zone transition rules
- **Lobby -> main floor:** the store brand and signage language begin in the lobby; the entrance threshold must clearly hand off from entry mat / vestibule treatment into the main retail tile and expose a readable sightline toward checkout or main aisles.
- **Main floor -> freezer:** cooler frames, colder lighting, and utility flooring define the shift, but freezer prompts and navigable paths stay as readable as the main floor.
- **Main floor -> stockroom:** transition through staff-only doors, simpler utility materials, reduced prop density, and explicit staff signage; stockroom should feel operational, not like a new biome.
- **Continuity rule:** transitions should change material palette and lighting emphasis without feeling like level streaming seams; no doorway should reveal raw placeholder geometry or a total style reset.

### Performance guardrails
- Reuse approved modular shelf, checkout, freezer, pallet, and signage families before introducing new one-off meshes.
- Default target: no new one-off hero meshes are required to finish Sprint 7.
- Material, tint, decal, and silhouette changes are preferred over geometry-heavy bespoke assets.
- Always-on non-ceiling accent lighting should stay to 2 or fewer in a normal Tier A gameplay frame.
- Event readability should mostly come from transforming existing lighting, with no more than 1 localized extra event-light cluster at a read point.
- Dense clutter belongs at focal points only; task lanes, queue space, and prompt areas stay clean.
- Decorative decals and sale cards must stay subordinate to gameplay prompts, alerts, and interactable affordances.
- One aisle number plus one category-header read per aisle mouth, and one sale-card family across the store, are the default limits.
- Any art upgrade that hurts phone readability, traversal clarity, blackout readability, or mimic readability fails the sprint goal.

### Store-presence asset direction
- **Icon:** square composition with checkout/store identity first and threat second; must still read at small size.
- **Thumbnail A — Store at 3AM:** readable supermarket identity, strong signage, honest in-game geometry.
- **Thumbnail B — Blackout:** same store, same layout, emergency lighting readability, no fake cinematic set.
- **Thumbnail C — Mimic tension:** uncanny wrongness in a real taskable zone without drifting into generic horror art.
- **Update / social shot:** use a before / after or visual-upgrade frame sourced from the real shipped build.

### Sprint 7 fallback order if time compresses
1. materials and silhouette cleanup
2. signage and wayfinding
3. lighting continuity
4. medium prop density
5. optional micro-clutter

## Future expansions
- new store types
- roaming manager enemy
- revive loop
- seasonal events
- social progression / badges

## Open questions
- exact revive design
- how punishing mimic tasks should be
- whether stamina exists in MVP or later
