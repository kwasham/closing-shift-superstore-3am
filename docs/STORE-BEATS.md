# Store Beats

This file is the buildable room-by-room spec for the first playable store in **Closing Shift: Superstore 3AM**.

## Sprint 1 store concept
A compact neighborhood supermarket with one open sales floor, one checkout lane, a short freezer wall, a small employees-only trash route, and a shallow exterior apron for carts. The player should understand the full map in one lap.

## Layout goals
- Keep the first map compact enough for solo play.
- Let players see or infer every major zone from the front half of the store.
- Support all six MVP tasks without requiring a large backroom or parking lot.
- Make the freezer and back-trash corner feel most uncomfortable.
- Keep the front entrance and checkout as the visual home base.

## Travel budget
- From the register to the farthest task node should feel like roughly **5 to 7 seconds** of movement, not a long run.
- No zone should require multiple door transitions except the trash route.
- A solo player should be able to mentally track the whole store without opening a map.

## Top-down layout summary
Use a simple rectangle with a shallow exterior strip.

```text
[ Exterior apron / cart return / front windows ]
[ Vestibule ] [ Front promo / queue ] [ Checkout lane ]
[ Aisle A ] [ Aisle B ] [ Aisle C ]
[ Freezer wall / cold corner ] [ Back trash door / utility nook ]
```

## Physical node plan
This is the recommended first pass for interactable placement. Engineering can reuse nodes after cooldown, but the builder should place enough distinct anchors that the store does not feel repetitive.

| Task | Recommended physical nodes | Primary locations |
| --- | ---: | --- |
| Restock Shelf | 2 | Aisle A mid-shelf, Aisle C rear shelf |
| Clean Spill | 2 candidate spots | Front queue tile, freezer aisle mouth |
| Take Out Trash | 1 | Back trash door / dumpster route |
| Return Cart | 2 | Exterior left loose cart, exterior right near corral |
| Check Freezer | 1 | Freezer alarm panel on rear-left wall |
| Close Register | 1 | Checkout counter, lane 1 |

## Zone-by-zone spec

### 1) Exterior front apron + cart return
**Purpose**
- Sells the storefront silhouette before players go inside.
- Hosts `Return Cart` task space.
- Gives the store a readable front-facing anchor during blackout.

**Build notes**
- Keep exterior shallow: storefront windows, concrete curb, small asphalt strip, and one cart corral.
- Place 2 to 4 loose carts max.
- Use one streetlamp or parking-lot light source plus storefront spill.
- Keep the cart route readable from the front doors.

**Key props**
- cart corral
- loose shopping carts
- curb paint / bollards
- trash can
- front windows with sale posters

**Task coverage**
- `Return Cart` node 1: loose cart near left window
- `Return Cart` node 2: loose cart near right curb/corral

**Mood**
- Quiet, open, slightly exposed.
- Not the scariest area, but should feel lonely and too empty.

**Readability rule**
- Players standing at the doors should instantly spot where carts belong.

### 2) Vestibule + front doors
**Purpose**
- Entry anchor and orientation point.
- First clean sightline into the store.
- Good candidate area for onboarding text to make sense spatially.

**Build notes**
- Use a compact vestibule with entry mats and glass doors.
- Keep this area uncluttered so players can read the store at a glance.
- Sale posters and a simple `ENTRANCE` / `EXIT` treatment are enough.

**Key props**
- glass doors
- floor mats
- poster frames
- promo bin or newspaper rack

**Task coverage**
- No dedicated required task node here by default.
- If needed for variation later, a spill candidate can live just beyond the mat line.

**Mood**
- Safer than the rear of the store.
- Still sterile and uncanny because the store is open-looking but empty.

**Readability rule**
- From here, players should see checkout, at least one aisle sign, and the glow from the freezer direction.

### 3) Checkout lane area
**Purpose**
- Home base landmark.
- Hosts `Close Register` final task.
- Good place for early-round orientation and fallback navigation.

**Build notes**
- Use one hero checkout lane only.
- Keep the counter silhouette strong and isolated from visual noise.
- Queue space should be small; do not build multiple lanes for Sprint 1.
- Keep enough open floor that a spill can be read instantly if placed nearby.

**Key props**
- checkout counter
- register terminal
- bag rack or bag carousel
- candy / gum impulse shelf
- queue rails or floor markers
- `LANE 1` sign

**Task coverage**
- `Close Register` node behind or beside the register terminal
- `Clean Spill` candidate spot at front queue tile, visible from mid-store

**Mood**
- Brightest zone in the map.
- Feels controlled until it suddenly becomes the last thing left to do.

**Readability rule**
- `Close Register` must be visually unique even while locked.
- A player should understand: "that is the final objective location."

### 4) Aisles / shelf zones
**Purpose**
- Main readable work loop.
- Hosts most `Restock Shelf` readability beats.
- Creates simple tension through partial occlusion without becoming a maze.

**Build notes**
- Use **3 short gondola aisles max**.
- Keep aisle spacing wide enough for fast turning and clear camera movement.
- Add hanging or endcap signage: `Aisle A`, `Aisle B`, `Aisle C`.
- Use half-stocked shelf gaps or visible cardboard cases to telegraph restock points.

**Suggested aisle identities**
- `Aisle A` Snacks
- `Aisle B` Drinks
- `Aisle C` Household

**Task coverage**
- `Restock Shelf` node 1: Aisle A, mid-left shelf gap
- `Restock Shelf` node 2: Aisle C, rear-right shelf gap
- Optional spill candidate can appear at an aisle mouth if later variation is needed, but Sprint 1 should favor the front queue and freezer mouth for clarity

**Mood**
- Slightly oppressive through repeated shelves and humming lights.
- This is where the store starts feeling empty instead of normal.

**Readability rule**
- Keep endcaps visually distinct.
- Players should not need to enter every aisle to know where the tasks are.

### 5) Freezer section
**Purpose**
- Strongest cold-horror beat in Sprint 1.
- Hosts `Check Freezer`.
- One of the best zones for blackout tension and mimic suspicion.

**Build notes**
- Place freezer wall along the rear-left edge of the store.
- Use 4 to 6 freezer doors or a short continuous freezer bank.
- Give the section a colder blue cast than the rest of the store.
- Add a visible alarm box, panel, or warning light for the task anchor.

**Key props**
- freezer doors
- frost decals / condensation hints
- alarm panel or blinking indicator
- freezer product silhouettes

**Task coverage**
- `Check Freezer` node on the alarm panel or service latch cluster
- `Clean Spill` candidate spot at the freezer aisle mouth or directly in front of the doors

**Mood**
- Mechanical hum, colder light, slight isolation.
- This should be the strongest supernatural-feeling zone without needing a visible enemy.

**Readability rule**
- The alarm point must be readable from several steps away.
- Do not hide the interaction on a generic wall or low-detail corner.

### 6) Back trash area / utility nook
**Purpose**
- Hosts `Take Out Trash`.
- Provides the dirtiest, least comfortable corner in the first store.
- Gives the map one tiny employees-only transition without becoming a full backroom maze.

**Build notes**
- Put an `EMPLOYEES ONLY` door in the rear-right corner.
- The route can be a short nook or threshold rather than a full room.
- Players should understand this is "out back" in one glance.
- Keep the space readable enough that carrying out trash feels fast, not fussy.

**Key props**
- black trash bags
- utility shelves
- mop bucket
- plastic bin
- concrete wall/floor treatment
- exterior dumpster or trash cage just beyond the back door if space allows

**Task coverage**
- `Take Out Trash` node at the back door / bag pickup point

**Mood**
- The most unpleasant normal space in the store.
- Dirty, underlit, and mechanical.

**Readability rule**
- The task should clearly read as taking a bag out back, not as interacting with random clutter.

## Blackout beat map

### Strongest blackout zones
1. **Freezer section**
   - Cold residual light + hum + door silhouettes
   - Best place for players to feel exposed but still oriented
2. **Back trash area**
   - Weakest visibility, strongest dread
   - Good for silhouette-only navigation
3. **Center aisles**
   - Medium threat through shelf shadowing
   - Still readable via aisle signs and overhead fixture silhouettes

### Safest blackout anchors
- Checkout lane
- Front windows / vestibule
- Exit sign paths

### Blackout art rule
Even in the strongest blackout zone, players should still identify:
- where the floor path is
- where the nearest doorway/opening is
- whether a task prompt exists but is disabled

## Mimic readability + scare priority
Use these as the preferred emotional targets for content staging. Engineering may choose any eligible active node, but the space should support these outcomes.

1. **Check Freezer**
   - Best balance of clarity and dread
   - Isolated enough to feel wrong, readable enough to understand fast
2. **Restock Shelf** on rear aisle shelf
   - Good because it looks routine until it punishes the player
3. **Take Out Trash** at back door
   - Strong scare location, but only if the interaction anchor is very clean
4. **Return Cart** outside front
   - Very readable, lower scare, good fallback
5. **Clean Spill** near front queue
   - Highest clarity, lowest scare; use as a backup readability case, not the signature horror beat

## Zone priority for first Studio blockout
1. Front glass wall, doors, and exterior apron
2. One checkout lane with clear register silhouette
3. Three short gondola aisles with readable headers
4. Freezer wall with visible alarm panel
5. Back trash door + utility nook
6. Cart corral and loose carts
7. Lighting pass and signage pass

## Non-goals for Sprint 1 map
- No full parking lot
- No giant stockroom maze
- No multi-lane supermarket sprawl
- No heavy environmental storytelling that hides task readability
- No extra rooms that do not support the six MVP tasks