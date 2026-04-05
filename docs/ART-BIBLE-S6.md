# Sprint 6 Art Bible — Closing Shift

## Core style statement
**Stylized retail horror**: an ordinary late-night supermarket rendered with clean modular forms, readable materials, and fluorescent lighting that becomes subtly wrong under pressure.

## Emotional target
- baseline feeling: tired, quiet, ordinary
- rising tension: empty, overlit, slightly off
- threat feeling: familiar space turning incorrect
- payoff feeling: relief, payroll, survival, store finally still

## Pillars
1. **Clear silhouettes**
   - shelves, counters, coolers, carts, and caution props must read instantly from a distance
2. **Everyday detail over clutter noise**
   - believable signage, labels, and stock cues matter more than dense random objects
3. **Controlled unease**
   - horror comes from contrast, absence, flicker, and impossible emphasis
4. **Phone-safe presentation**
   - high contrast, limited visual noise behind UI, readable sign shapes

## Palette tokens
- `fluorescent_white` — primary store light, soft greenish white
- `tile_gray` — floor base, lightly dirty neutral
- `powder_blue` — freezer and cooler accent
- `safety_red` — alerts, emergency accents, hazard signage
- `receipt_cream` — UI paper / payroll accent
- `sodium_amber` — stockroom warmth / warning warmth
- `mimic_violet` — localized wrongness color, used sparingly
- `night_blue` — shadow and blackout support tone

## Material rules
### Architecture
- floor: commercial tile or sealed concrete depending on zone
- walls: painted block, panel, or simple commercial drywall treatment
- ceiling: grid + fluorescent fixtures, not decorative ceilings

### Retail fixtures
- shelves: coated metal with repeatable trim accents
- checkout: laminate + metal edging + scanner accents
- freezer / cooler: glass, cool metal, interior light glow
- stockroom: rawer surfaces, pallets, taped boxes, industrial doors

### Small props
- cardboard, plastic bottles, baskets, price strips, caution signs, clipboards, bags, employee posters
- keep prop families consistent in color and material language

## Signage language
- big aisle markers
- endcap pricing signs
- sale cards with one accent color rule
- employee-only and hazard strip treatment for back-of-house
- emergency / blackout support signage should still read when lighting drops

## UI skin direction
- theme: **security terminal + receipt printer**, not generic sci-fi
- panels should feel like store hardware and payroll screens, not debug windows
- typography should be bold and readable, with one clear display treatment and one body treatment
- icons should be simple and legible at small sizes
- alerts should feel urgent without becoming visually noisy

## Event visual language
### Normal shift
- cool fluorescent top light
- readable aisle signage
- calm neutral contrast

### Blackout
- store light falls out fast
- emergency and spillover light do the work
- interaction loss is visible without making navigation impossible
- no strobe spam

### Mimic
- cue is local and uncanny
- use a wrong-color accent, subtle flicker, or impossible emphasis around the affected node
- cue must be visible without requiring audio only

### Round end
- success leans payroll green / receipt cream
- failure leans warning amber / muted red

## Prop-density guidance
- hero slice zones: medium-high density
- supporting spaces adjacent to hero slice: medium density
- untouched background zones: low density but material-consistent
- avoid prop piles that interfere with movement or task readability

## Asset-source policy
- allowed first: Studio-built modular parts, materials, decals, simple meshes already under team control
- optional: imported meshes / textures if they do not block the sprint and are documented
- avoid dependency on a large external art pipeline for Sprint 6 success

## Visual anti-goals
- photoreal supermarket simulation
- grimy gore-heavy horror
- neon-overload aesthetics
- UI that sacrifices readability for style
- particle-heavy presentation that hurts runtime comfort or clarity
