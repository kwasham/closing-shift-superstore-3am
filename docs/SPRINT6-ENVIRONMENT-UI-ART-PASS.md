# Sprint 6 Environment + UI Art Pass

## Purpose
Turn the locked Sprint 6 style direction into a concrete, reusable content package that gets the playable slice off obvious graybox without changing gameplay rules.

## Scope freeze
This pass only covers:
- lobby / entrance
- checkout zone
- one hero aisle
- freezer section
- stockroom corner
- signage / decal language
- small-prop dressing
- HUD / UI visual treatment support
- hero-shot composition guidance
- before / after proof support

This pass does **not** authorize full-map beautification, gameplay-node movement, or bespoke hero art that blocks shipping.

## Shipping rule
Everything in this pass must be shippable with Studio-built geometry, Roblox materials, decals, and simple team-owned UI assets.
No external import is required for Sprint 6 success.
A text-managed fallback implementation of the authored slice now also exists in `project/src/Workspace/FallbackArena.server.lua` so the critical-path look is represented in source form, not only in docs.

## Locked authored decisions
### Store identity cue
Use a simple, repeatable in-world brand mark built from block text + rectangle tag:
- main wordmark: `SUPERSTORE`
- corner tag / receipt tab: `3AM`
- support line when needed: `OPEN LATE`

This is the branded focal point for the lobby / entrance and the repeatable cue for thumbnails, endcaps, and checkout signage.
It is deliberately simple enough to build from Studio geometry and decals with no external font dependency.

### Hero aisle lock
The single authored hero aisle for Sprint 6 is:
- **Aisle 05 — Snacks + Soda**

Why this aisle:
- strong silhouette variety from bottles, cans, cartons, and bagged snacks
- easy-to-read category language from normal camera height
- works in checkout-adjacent captures and mid-distance thumbnail framing
- supports repeatable shelf, price-strip, and endcap treatment

## Zone-by-zone art pass

### 1. Lobby / entrance
**Identity target:** first frame says supermarket, not warehouse spawn.

**Must read from camera height**
- `SUPERSTORE` + `3AM` focal sign on the main entrance-facing wall
- clean `tile_gray` floor treatment with one darker threshold strip at the entrance
- basket rack and cart corral immediately visible on one side of the entry path
- simple service / promo surface near the threshold
- one sale sign cluster that teaches the store's sign language instantly

**Replace or cover obvious primitives**
- plain wall block behind first camera angle
- blank floor plane at the threshold
- raw desk / podium surfaces in first view
- empty entrance corners that currently read as test space

**Small-prop family for this zone**
- baskets
- nested carts
- flyer holder / promo stack
- store-hours placard
- floor arrow or threshold stripe decal

**Readability guardrails**
- keep the main player route into the store visually open
- do not place tall props in the direct path from spawn to first task read
- keep one clean title-space angle for hero capture

### 2. Checkout zone
**Identity target:** operational heart of the store; register should feel important before tutorial copy says so.

**Must read from camera height**
- lane-number signage and register framing
- scanner / bagging / receipt-roll surface language
- queue definition using rails, floor decals, or repeated counter trim
- one strong `CASH OUT` or `REGISTER` read in the zone
- bag stand / impulse shelf silhouettes that still preserve prompt readability

**Replace or cover obvious primitives**
- desk-like cubes standing in for counters
- blank front counter faces
- empty queue space with no lane definition
- register area that lacks scanner / payment / bagging cues

**Small-prop family for this zone**
- bag bundles
- receipt rolls
- scanner plate accent
- gum / candy impulse trays
- lane closed / open placards
- counter wipe bottle or rag only if it does not clutter the prompt

**Readability guardrails**
- keep a clear sightline to the close-register prompt area
- no prop taller than the counter directly in front of the register interaction line
- lane dressing should sit to the side or below prompt height

### 3. Hero aisle — Aisle 05 Snacks + Soda
**Identity target:** prove the reusable shelf kit and category system at full gameplay scale.

**Must read from camera height**
- aisle-top numeral `05`
- category header `SNACKS + SODA`
- repeatable shelf bays with price strips and product silhouette rhythm
- one endcap with sale card + boxed overstock silhouette
- clear left/right shelf read without overcluttering the walking lane

**Replace or cover obvious primitives**
- single-color placeholder shelf masses
- empty shelf faces with no price-strip treatment
- aisle top with no numeral / category language
- bare endcap that does not help the shot composition

**Small-prop family for this zone**
- bottles / cartons / cans in grouped silhouette blocks
- bagged snack silhouettes
- shelf-edge price strips
- promo wobblers / sale cards used sparingly
- one restock box or flat only at shelf ends, never in the lane center

**Readability guardrails**
- preserve a clean movement lane through the aisle
- do not hide task prompts behind tall product silhouettes
- keep overstock to endcaps or shelf edges, not path center

### 4. Freezer section
**Identity target:** cold material break that still feels like the same store.

**Must read from camera height**
- glass / cooler-door framing
- restrained `powder_blue` trim or label accents
- interior cooler glow or bright cold contrast
- `FROZEN` and `KEEP DOOR CLOSED` signage
- colder wall / floor treatment than the hero aisle

**Replace or cover obvious primitives**
- solid blocks standing in for cooler cases
- warm-toned surfaces matching the regular aisle
- blank freezer faces with no frame / label treatment

**Small-prop family for this zone**
- frost / condensation warning decals
- freezer crate or milk-crate variant
- cold-zone caution sign or mat
- cooler label strip and maintenance tag

**Readability guardrails**
- keep door silhouettes readable and interaction space uncluttered
- avoid busy decals across large glass areas
- preserve contrast so players can still orient under blackout support lighting

### 5. Stockroom corner
**Identity target:** utility, staff-only access, slight dread.

**Must read from camera height**
- `EMPLOYEES ONLY` threshold language
- taped boxes + pallet stack silhouette
- payroll / safety / backstock posters or clip sheets
- warmer `sodium_amber` practical light support than the sales floor
- rougher floor / wall treatment than the public-facing spaces

**Replace or cover obvious primitives**
- blank utility walls
- plain cube stacks with no tape / label treatment
- generic doorway with no industrial or staff-only language

**Small-prop family for this zone**
- taped carton stacks
- pallet or dolly
- clipboard / checklist
- mop bucket or caution sign
- shrink-wrap or shipping arrows as decal language

**Readability guardrails**
- do not turn the corner into a junk pile
- keep navigation and task silhouettes readable in low light
- props should frame the corner, not fill the walkable center

## Reusable signage + decal pack
The following pack is concrete enough to build now with Studio decals or simple UI-to-texture workflows.
A mirrored config version also lives in `project/src/ReplicatedStorage/Shared/StoreSignage.lua`.

| Pack item | Copy / variant | Primary zone | Notes |
| --- | --- | --- | --- |
| Brand wordmark | `SUPERSTORE` + `3AM` tag | lobby, checkout, hero shots | main repeatable brand cue |
| Store-hours card | `OPEN LATE` | lobby | secondary branding beat |
| Aisle numerals | `01`–`06` | sales floor | bold block numerals only |
| Category headers | `PRODUCE`, `SNACKS + SODA`, `FROZEN`, `CLEANING`, `HOUSEHOLD` | hero aisle, adjacent slice | distance-readable, short copy |
| Sale cards | `NIGHT PRICE`, `SAVE NOW`, `2 FOR 1` | entrance, endcaps, checkout | one accent color at a time |
| Checkout signs | `REGISTER 1`, `REGISTER 2`, `CASH OUT`, `LANE CLOSED` | checkout | use strong contrast, minimal words |
| Shelf labels | price-strip bars, barcode tabs | hero aisle, checkout | low-profile repeat system |
| Freezer labels | `FROZEN`, `KEEP DOOR CLOSED`, `COLD STORAGE` | freezer | pair with powder-blue accent |
| Stockroom signs | `EMPLOYEES ONLY`, `BACKSTOCK`, `PAYROLL`, `SAFETY CHECK`, `RECEIVING` | stockroom | practical, institutional tone |
| Hazard decals | black/yellow stripe, floor arrow, wet-floor support | checkout, stockroom, threshold | use to frame space, not wallpaper it |
| Box / shipping decals | `THIS SIDE UP`, barcode, receiving tag | stockroom, endcaps | good for reusable box kit |
| Receipt clutter | receipt strip, terminal sticker, payment icons | checkout HUD tie-in | reinforces receipt/terminal theme |

## Small-prop pass rules
### Prop-density target by zone
- lobby / entrance: medium
- checkout zone: medium-high
- hero aisle: medium-high
- freezer section: medium
- stockroom corner: medium-high

### Placement rules
- keep a readable clearance bubble around interaction prompts
- prefer low-profile props below counter height or tight to walls
- use repeated families instead of one-off novelty items
- at least one negative-space lane should remain obvious in every priority zone
- if a prop does not improve silhouette, brand language, or retail believability, cut it

### Reusable prop families to build first
1. baskets + nested carts
2. taped carton stacks + labels
3. bag bundles + receipt rolls
4. shelf-edge price strips + sale cards
5. mop bucket + wet-floor sign
6. scanner plate + payment sticker + terminal clutter
7. pallet + dolly + shrink-wrap stack
8. cooler crate + maintenance tag

## HUD / UI visual treatment support
Source-aligned token support now lives in:
- `project/src/ReplicatedStorage/Shared/VisualTheme.lua`
- `project/src/ReplicatedStorage/Shared/StoreSignage.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- `project/src/StarterPlayer/StarterPlayerScripts/ClientEffects.client.lua`
- `project/src/Workspace/FallbackArena.server.lua`

### Core UI theme
**Security terminal + receipt printer**

### Panel anatomy
- outer shell: dark `night_blue` / charcoal equipment housing
- header strip: terminal identity band with fluorescent contrast
- inner card: `receipt_cream` paper surface for state, timer, pay, and objectives
- alert block: single strong card at the bottom, color-coded by state family

### Alert family lock
- default / tutorial: dark shell + fluorescent text
- blackout: `night_blue` shell with cool highlight edge
- mimic: localized `mimic_violet` accent, never full-screen purple wash
- success: `receipt_cream` + `payroll_green`
- failure: `sodium_amber` weighted with restrained `safety_red`

### Interaction feedback support
- available tasks remain bright and practical, not magical
- register-ready feedback uses warm payroll / checkout emphasis
- blackout feedback cools the task-node read without making it disappear
- mimic feedback uses violet wrongness, not blood-red gore language
- success / fail flashes should be quick stamps, not full-screen spectacle

### Engineering / QA implementation hooks
- keep touch targets and layout hierarchy unchanged
- use strong contrast; no low-opacity text over patterned cards
- alert styles must be identifiable from a screenshot with HUD cropped small
- prompt-adjacent task highlights must not hide interaction silhouettes

## Hero-shot and before / after proof plan
### Matched before / after cameras
Capture one locked angle per priority zone:
1. lobby / entrance — from spawn-facing threshold toward the brand wall
2. checkout zone — three-quarter view showing at least one register + lane sign
3. hero aisle — center-lane shot with aisle numeral and endcap visible
4. freezer section — angled shot showing cooler frame depth and cold accent
5. stockroom corner — doorway / threshold shot showing staff-only language and box stack silhouette

### Shot composition rules
- keep one primary identity read per frame: brand, checkout, aisle header, freezer frame, or staff-only threshold
- include foreground, midground, and background where possible
- avoid camera heights that only sell ceiling or empty floor
- preserve one clean negative-space area for title/logo on icon and thumbnail variants

### Hero-shot use notes
- **Icon:** checkout foreground + aisle/freezer tension behind it
- **Thumbnail A:** checkout wide with branded signage and one distant uncanny cue
- **Thumbnail B:** blackout version of the same store identity, still readable
- **Thumbnail C:** freezer dread shot with cool contrast and minimal clutter
- **Social before/after:** same frame, graybox versus authored zone treatment

## Dependency log
### Required for Sprint 6 success
- none beyond Studio geometry, materials, decals, and team-owned source files

### Optional imports
- none locked in this pass

If optional external meshes or textures are introduced later, they must be listed with asset IDs, fallback replacements, and the exact zone they affect before they become part of QA expectations.

## Done looks like this
A first-time player walking from entrance to checkout, through the hero aisle, past the freezer, and into the stockroom corner should feel one consistent authored supermarket identity at eye level, with readable signage, believable small props, and HUD treatment that looks like store equipment instead of debug UI.
