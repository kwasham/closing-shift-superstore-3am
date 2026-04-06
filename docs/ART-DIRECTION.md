# Art direction

## Visual tone
- Familiar suburban supermarket
- fluorescent lighting
- uneasy emptiness
- retail realism with subtle paranormal wrongness

## Sprint 7 full-experience style sentence
Closing Shift should now read as a fluorescent suburban supermarket that is modular, phone-legible, and subtly wrong—an ordinary late-night retail box where every player-traversed space shares the same signage grammar, material language, and lighting rhythm, and where the horror lands through contrast and disruption instead of bespoke hero clutter.

## Art priorities for Sprint 7
1. **Consistency over novelty**
   - The full store should feel like one shipped game, not one polished slice surrounded by graybox.
2. **Wayfinding is part of the art pass**
   - Signs, aisle numbers, and department reads do navigation work.
3. **Sprint 6 stays protected**
   - The accepted Sprint 6 slice is the baseline to scale, not a direction to replace.
4. **Phone-safe readability wins**
   - If text, prompts, or silhouettes stop reading on a small screen, the art pass is wrong.
5. **Honest public surfaces**
   - Store-page images must depict the real in-game look, not a fake overpaint.

## Rollout tiers
### Tier A — production-ready this sprint
- lobby / entrance
- all main playable aisles
- checkout zone and queue
- freezer / cooler path
- stockroom corner and entered back-of-house space
- all transitions between those spaces

### Tier B — consistent but lighter detail
- secondary aisle edges
- sightline background walls and ceiling runs
- visible staff-hall segments
- visible corners next to active task nodes

### Tier C — simple only if hidden or non-traversed
- unseen backsides of fixtures
- sealed support rooms
- distant background views outside the real playable frame

## Material and fixture language
### Floors
- Lobby / entrance: entry mat or threshold strip into commercial retail tile.
- Main floor: clean commercial tile or sealed store floor finish with visible lane structure.
- Freezer: colder sealed utility floor language.
- Stockroom: harder-wearing utility floor, simpler than the sales floor but still authored.

### Walls
- Main floor walls should use paneled or painted commercial treatments, not flat gray blocks.
- Freezer walls should read colder, cleaner, and more sealed.
- Stockroom walls should read practical and operational, with notice-board or staff-sign potential.

### Ceilings
- The whole traversed store needs a readable ceiling rhythm: grid, fixture spacing, and predictable fluorescent cadence.
- Exposed ceiling simplicity is acceptable only when it looks intentional and consistent, not placeholder.

### Fixture families
Approved repeated families for this sprint:
- modular shelf family
- checkout counter / bagging / scanner family
- freezer / glass-door family
- pallet / dolly / labeled box family
- hanging sign and aisle-marker family

Do not depend on bespoke hero fixtures to make a zone work.

## Must-replace primitive forms
These must be removed or art-shelled in Tier A and normal Tier B sightlines:
- raw gray floor slabs
- flat gray walls with no commercial treatment
- raw ceiling blocks with no fixture rhythm
- primitive shelf blocks
- primitive checkout blocks
- primitive freezer cubes
- placeholder threshold doors
- unlabeled primitive crates, boxes, and pallets in readable spaces
- blank signage panels or temp text markers

## Acceptable hidden remnants
These can survive only if they are hidden from ordinary play, QA proof, and public capture:
- unseen rear faces of shelves or coolers
- fixture internals fully occluded by approved shells
- support-room interiors behind sealed doors
- upper faces above normal camera sightlines
- distant exterior/background placeholder forms outside the playable frame

If a remnant appears in a Tier A walkthrough, a before/after proof frame, or a store-page capture angle, it is not acceptable.

## Store-wide signage / wayfinding grammar
### Aisle numbers
- One hanging aisle marker at each aisle mouth.
- Large numeral first, short secondary label second.
- Keep numerals bold and high contrast.
- No novelty fonts, scripts, or handwritten treatment.

### Category headers
- Use short retail nouns only.
- One or two words maximum for the visible headline.
- Mount above the relevant shelf run or department edge.
- Good examples: `SNACKS`, `CANNED`, `FROZEN`, `DAIRY`, `CLEANING`, `HOUSEHOLD`.

### Checkout numbering
- Large numerals above or just behind each checkout lane.
- All checkout signs use the same shape, scale family, and placement logic.
- Queue space should read from the front store without needing close inspection.

### Staff / hazard language
Use direct, operational language only:
- `EMPLOYEES ONLY`
- `STOCKROOM`
- `FREEZER`
- `NO ENTRY`
- `WET FLOOR`
- `EXIT`
- `BACK DOOR`
- `NOTICE BOARD`

Warning language should be sparse so it keeps authority.

### Sale-card rules
- One sale-card family for the whole store.
- Accent color is reserved and consistent.
- Short headline plus large price read.
- No rainbow discount spam.
- Sale cards cannot visually compete with event alerts, prompts, or hazard signage.

## Transition rules
### Lobby -> main floor
- The lobby starts the same store identity: palette, logo language, and sign grammar already present.
- The threshold should expose a clean sightline toward checkout or the main aisle structure.
- Floor and lighting shift should feel like entering the sales floor, not teleporting into a different map style.

### Main floor -> freezer
- Cooler frames, colder tint, and utility floor treatment define the transition.
- Freezer remains readable as part of the same store because signage, silhouettes, and fixture logic stay consistent.
- Cold mood is allowed; murky prompt unreadability is not.

### Main floor -> stockroom
- Staff-only doors and utility materials define the shift.
- Prop density can drop, but the space must still look authored.
- Notice-board, pallet, and operations signage should support the area, not turn it into clutter.

### Global transition continuity
- Each threshold should keep the same overall production language while changing zone emphasis.
- Do not hard-reset palette, prop density, or fixture logic between adjacent spaces.
- No player-facing seam should expose raw placeholder geometry.

## Lighting continuity rules
- Base lighting stays fluorescent and readable across the whole store.
- Lobby can be slightly warmer than the main floor, but still clearly part of the same retail box.
- Freezer can skew colder than the main floor.
- Stockroom can be slightly dimmer and more industrial than the sales floor.
- Blackout and mimic should remix the established lighting, not replace it with unrelated spectacle.
- Players must still be able to identify checkout, freezer, stockroom, exits, prompts, and teammates under stress states.

## Performance-aware art boundaries
- Reuse existing modular kits before adding imported one-offs.
- Default target: no new one-off hero meshes are required to finish Sprint 7.
- Prefer shared materials, recolors, and decals over extra mesh families.
- Keep always-on non-ceiling accent lights to 2 or fewer in a normal Tier A gameplay frame.
- Use at most 1 localized extra event-light cluster at a read point; prefer transforming existing fixtures.
- Use dense props only at focal points; traversal and interaction lanes stay clean.
- One aisle number plus one category-header read per aisle mouth is the default target, not stacked sign spam.
- One sale-card family only across the store.
- Remove or hide obsolete visible graybox once a replacement is in.
- If a decorative pass hurts clarity, cut micro-props first, then extra decals, then non-essential accent lights.

## Public-facing asset direction
### Experience icon
- Square frame.
- Checkout or front-store identity should read first.
- Threat or paranormal wrongness is secondary, not abstract noise.
- Must survive Roblox small-size readability.

### Thumbnail set
1. **Store at 3AM**
   - wide recognizable supermarket frame
   - signage and layout clearly visible
   - uses a real completed Tier A angle
2. **Blackout**
   - same store identity under emergency conditions
   - strong silhouette and route readability
   - no fake cinematic over-lighting
3. **Mimic tension**
   - uncanny wrongness in a real task zone
   - still obviously this supermarket
   - avoid monster-poster composition drift

### Update / social shot priorities
1. before / after visual-upgrade comparison
2. full-store hero aisle or checkout proof shot
3. blackout readability shot
4. mimic readability shot

## Capture honesty rules
- Capture from the real shipped build whenever possible.
- Use real completed Tier A zones.
- Do not frame out unresolved Tier A seams and then imply the whole store matches the shot.
- Do not paint over lighting, props, or geometry beyond what the live game actually ships.

## UI tone
- short verbs
- mobile readable
- practical with a slightly eerie edge
