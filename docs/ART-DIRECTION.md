# Art Direction

## Sprint 1 visual goal
Build a compact late-night supermarket that feels immediately familiar, slightly wrong, and always readable on a phone screen. The first pass should sell fluorescent dread and clear task navigation before it tries to sell deep environmental detail.

## Visual pillars
1. **Ordinary retail first, horror second**
   - The store should read as a believable small supermarket in one glance.
   - Horror comes from emptiness, lighting failure, hum, and isolation instead of complex monster visuals.
2. **Readable landmarks over decoration**
   - Players should instantly identify the front doors, checkout, aisles, freezer wall, back trash door, and cart return.
   - Every major zone needs a strong silhouette and simple signage.
3. **Cold fluorescent unease**
   - The default store mood is overbright, washed out, and slightly sickly.
   - The space should feel open enough to navigate, but empty enough to feel wrong at 3AM.
4. **Task clarity beats clutter**
   - Interactable spots must sit in clean readable pockets.
   - Players should not have to hunt through dense props to find a task node.
5. **Compact map, tense travel**
   - The farthest Sprint 1 task route should feel short enough for solo play.
   - The store should support pressure from time and events, not from getting lost.

## Lighting mood

### Base lighting
- Use cool white fluorescent lighting with a slight green-blue cast.
- Keep overall brightness high enough that shelves, floor decals, and doorway silhouettes are readable on mobile.
- Avoid warm cozy lighting. The store should feel sterile, late, and tired.

### Brightness hierarchy
- **Brightest:** checkout lane and front entrance
- **Mid:** center aisles and shelf endcaps
- **Darkest:** freezer wall, back trash area, and corners beyond direct ceiling lights
- **Exterior:** dim parking-lot spill with storefront light reflecting through front glass

### Blackout mood rules
- Blackout should feel alarming, but never fully blind the player.
- Keep emergency readability through:
  - exit sign glow
  - weak storefront window spill
  - freezer door strips or residual cold light
  - faint ambient fill so paths and silhouettes still read
- Blackout is a readability event, not a navigation trap.
- Do not rely on heavy strobe or rapid flashing that could hurt comfort or clarity.

### Fixture guidance
- Use repeating fluorescent ceiling fixtures in a simple grid.
- Let 1 to 2 fixtures flicker occasionally in the freezer/back half of the store.
- Keep the checkout area steadier than the rear zones so players retain an anchor point.

## Material and color rules

### Core palette
- **Floors:** off-white or pale gray tile with subtle grime
- **Shelving:** desaturated beige, gray, or dull retail metal
- **Walls:** flat white, cream, or light institutional gray
- **Checkout:** darker gray counter with small red accents only where needed
- **Freezer area:** colder blue-cyan tint, but still low saturation
- **Back/trash area:** dirty gray-green, concrete, black bags, worn plastic bins
- **Exterior:** dark asphalt, faded curb paint, metal cart corral

### Accent color rules
- Reserve stronger color for wayfinding and task recognition:
  - red = exit / warning / register closed indicator
  - yellow = sale tags / caution signage / spill support props
  - cyan-blue = freezer alarm emphasis
- Do not fill shelves with rainbow-bright packaging in the first pass.
- Bright packaging should appear in small patches, not as full-scene noise.

### Surface finish
- Favor matte and lightly worn materials.
- Keep reflections low so prompts and silhouettes stay readable.
- Use dirt and wear sparingly; this is a normal store on a bad night, not a ruined building.

## Prop density guidance

| Zone | Density target | Guidance |
| --- | --- | --- |
| Entrance / vestibule | Medium | Doors, mats, posters, one promo bin, clear walking lane |
| Checkout lane | Medium-high | Counter, bag rack, impulse shelves, queue markers, but keep register silhouette clean |
| Center aisles | Medium | 3 short gondolas max, readable endcaps, no maze feeling |
| Freezer wall | Medium-low | Strong doors/panels first, only light surrounding clutter |
| Back trash area | Low-medium | Bags, bins, mop bucket, utility shelves, leave task route readable |
| Exterior / cart return | Low | Corral, 2 to 4 carts, curb, bollards, maybe one trash can |

### Density rules for interactables
- Keep at least a **3-stud clean pocket** around each task prompt anchor.
- Do not bury interactable objects behind hanging signs, tall clutter, or busy decals.
- Large props should frame tasks, not hide them.
- If a prop does not improve silhouette, navigation, or mood, cut it for Sprint 1.

## Silhouette and readability notes
- The store should read through **big shapes first**:
  - front glass wall and doors
  - checkout counter
  - aisle gondolas
  - freezer door wall
  - employees-only back door
  - cart corral outside
- Limit the map to **3 short shelf aisles** so players can understand the plan instantly.
- Use hanging aisle markers or endcap headers large enough to read from mid-store.
- Restock locations should be readable from aisle mouths through obvious half-empty shelf gaps.
- Spill spots should use dark glossy decals with a clear edge and not blend into tile grout.
- The freezer interaction should live on a visible alarm panel or handle cluster, not on a generic wall patch.
- The register should be visually unique:
  - only checkout counter with a clear terminal
  - visible `LANE 1` / `REGISTER` signage
  - optional red closed indicator before unlock

## Mobile readability constraints
- Prompt copy should stay at **1 short sentence**.
- Target **2 lines max** for any world prompt or alert.
- Avoid punctuation-heavy or lore-heavy text.
- Key HUD/event text should remain readable over bright floors and white shelves; prefer dark translucent backing.
- Important signs should use **1 to 3 words**.
- Use title case or clear all-caps signage sparingly; too much all-caps becomes noise.
- Do not stack multiple decals, posters, and signs directly behind prompt anchors.
- The first-time player should be able to identify the next objective in under 3 seconds.

## Atmosphere rules
- Audio and light carry most of the horror tone.
- The store should feel empty, humming, and watched, not overtly supernatural all the time.
- Use small wrong details:
  - one cart left out front
  - one freezer door slightly brighter or noisier
  - a back corner that feels underlit
  - a checkout lane that looks too still
- Save the strongest mood shift for blackout and mimic tension.
- Never let atmosphere reduce task comprehension.

## Sprint 1 art priority
1. Landmark silhouettes
2. Lighting hierarchy
3. Clean task readability
4. Signage and decals
5. Ambient clutter and polish