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

## Current product lock — Sprint 6 visual identity foundation
Sprint 6 does **not** expand gameplay scope. It upgrades presentation so the shipped MVP reads like a branded product instead of a graybox prototype while preserving the Sprint 5 Ready baseline.

### Final art-style statement
**Closing Shift: Superstore 3AM is stylized retail horror: an ordinary late-night supermarket built from clean modular forms, readable materials, and fluorescent lighting that becomes subtly wrong under pressure.**

### Sprint 6 scope lock
This sprint only covers:
- lobby / entrance
- checkout zone
- one hero aisle
- freezer section
- stockroom corner
- lighting states for normal / blackout / mimic / round-end
- HUD / UI skin refresh
- interaction feedback polish
- before / after proof and hero-shot direction

### Explicit non-goals for Sprint 6
- no new gameplay systems
- no new map
- no economy rebalance
- no combat or enemy expansion
- no matchmaking changes
- no requirement for a custom external asset pipeline

### Locked polish priority
1. lobby / entrance
2. checkout zone
3. one hero aisle
4. freezer section
5. stockroom corner

### Visual rules that define the product
- **Retail first, horror second** — the store must read as a believable supermarket before it reads as haunted.
- **Readable on phones** — prompts, objectives, and alerts win over decoration.
- **Modular, not bespoke** — reusable shelf, counter, cooler, signage, and prop kits beat one-off hero pieces.
- **Normal but wrong** — horror comes from lighting, absence, asymmetry, and local wrongness, not gore.
- **Cheap to render** — materials, decals, signage, and controlled lighting carry more weight than heavy particles or dense unique meshes.

### Event presentation lock
- **Normal shift** uses cool fluorescent top light, clear aisle signage, and neutral readable contrast.
- **Blackout** drops store lighting fast and shifts readability to emergency / spill light without making navigation impossible.
- **Mimic** is a local uncanny cue, not a store-wide mode; the affected node gets the wrong-color emphasis and subtle instability.
- **Round end** separates success and failure instantly, with receipt/payroll framing for success and warning-weighted framing for failure.

### Asset-source policy
Sprint 6 ships on a **Studio-first with optional imports** rule:
- Studio-built modular parts, Roblox materials, decals, and simple team-controlled assets are sufficient for success.
- Imported meshes or textures are optional polish only if they do not block delivery and are documented.

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

## Open questions
- exact revive design
- how punishing mimic tasks should be
- whether stamina exists in MVP or later
