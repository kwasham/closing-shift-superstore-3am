# Art direction — Sprint 6 lock

## Final art-style statement
**Closing Shift: Superstore 3AM is stylized retail horror: an ordinary late-night supermarket built from clean modular forms, readable materials, and fluorescent lighting that becomes subtly wrong under pressure.**

## Sprint 6 scope boundary
Sprint 6 is a visual identity and environment art foundation pass only.

In scope:
- lobby / entrance
- checkout zone
- one hero aisle
- freezer section
- stockroom corner
- normal / blackout / mimic / round-end lighting states
- HUD / UI skin refresh
- interaction feedback polish
- before / after and hero-shot proof direction

Out of scope:
- new gameplay systems
- new map or layout expansion
- economy or progression changes
- combat or enemy additions
- matchmaking changes
- full-store bespoke art pass

## Critical-path polish order
1. **lobby / entrance**
2. **checkout zone**
3. **one hero aisle**
4. **freezer section**
5. **stockroom corner**

This order is locked for Sprint 6 and matches first-impression value, gameplay readability, and thumbnail usefulness.

## Visual pillars
1. **Retail first, horror second**
2. **Readable on phones**
3. **Modular, not bespoke**
4. **Normal but wrong**
5. **Cheap to render**

## Primitive graybox exit criteria
The following may not remain as plain primitive graybox in the polished slice unless there is a deliberate performance reason documented in handoff:
- first-view lobby walls, floor, desk, and brand focal point
- checkout counters, bagging surfaces, queue definition, scanner/register framing
- hero aisle shelf silhouettes, endcaps, category signage, price-strip surfaces
- freezer case framing, doors/glass reads, trim, and floor/wall transition
- stockroom door frame, pallets, taped boxes, hazard / employee-only language
- HUD panels that still read like debug boxes instead of store hardware / receipt UI

Background spaces outside the five priority zones may stay lower density if they inherit the same material and signage rules and do not break the illusion.

## Palette tokens
| Token | Primary use | Allowed zones / surfaces | Do not use for |
| --- | --- | --- | --- |
| `fluorescent_white` | baseline store light and highlight contrast | ceiling fixtures, normal-shift light balance, neutral UI text highlights | danger cards, mimic cues |
| `tile_gray` | floor and neutral architecture base | sales floor tile, neutral wall/floor breakup, low-drama shell surfaces | call-to-action accents |
| `powder_blue` | cold retail accent | freezer / cooler trim, cold-zone signage accents, freezer-adjacent UI tags if needed | checkout focal accents, hazard language |
| `safety_red` | urgent warning accent | danger alerts, hazard striping, emergency signage, failure-support accents | everyday category signs, large ambient color washes |
| `receipt_cream` | payroll / receipt surface language | summary cards, payout surfaces, secondary UI cards, paper ephemera | blackout ambient light, mimic cues |
| `sodium_amber` | stockroom warmth and warning warmth | stockroom practical light, caution-adjacent warmth, failure support tone | normal sales-floor dominant lighting |
| `mimic_violet` | localized uncanny wrongness | active mimic node cue, mimic alert accent, subtle local wrongness lighting | base environment palette, store branding |
| `night_blue` | shadow support and blackout structure | blackout fill, dark UI shell, nighttime depth, silhouette support | readable primary text on its own |
| `payroll_green` *(UI-only derived accent)* | success confirmation | payout arrows, success stamps, round-end positive accents only | environment lighting, signage, mimic or danger states |

## Material rules by zone family
| Zone family | Required material language | Must avoid |
| --- | --- | --- |
| Architecture baseline | commercial tile or sealed concrete, painted block/panel walls, ceiling grid with fluorescent fixtures | decorative mall finishes, ornate trim, glossy luxury retail styling |
| Lobby / entrance | clean commercial floor, brand wall/sign, simple service desk or frontage, readable threshold framing | empty gray foyer, generic horror warehouse look |
| Checkout zone | laminate + metal edging, scanner accents, bagging surfaces, queue definition, register framing | floating primitives with no checkout identity |
| Hero aisle | coated metal shelves, repeatable trim accents, consistent price strips, category header system | clutter piles that hide lane readability |
| Freezer section | cool metal, glass-front cases, interior glow, colder floor/wall treatment, powder-blue accent restraint | same material read as the main aisle, muddy warm lighting |
| Stockroom corner | rawer surfaces, pallets, taped boxes, industrial door frame, employee-only and hazard language, sodium-amber support warmth | decorative hero props, dense junk piles, pitch-black unreadability |
| Small props | cardboard, bottles, cans, baskets, carts, caution props, labels, posters, clipboards, receipt rolls | one-off novelty props that break store identity |

## Signage and typography rules
### Signage hierarchy
1. large aisle numerals / section markers
2. category headers
3. sale / pricing signs
4. employee-only / hazard signs
5. small shelf labels and policy posters

### Signage language
- Signage must read like a real supermarket first.
- Use bold, blocky, highly legible typography with clear silhouettes.
- Wayfinding and warning signs should favor uppercase or strong title-case treatments that read from distance.
- Sale cards get **one** accent color at a time; do not create rainbow promotional clutter.
- Back-of-house signage uses employee-only, hazard, payroll, or policy language rather than lore-heavy horror messaging.
- Emergency and blackout-support signs must remain readable when ambient lighting drops.

### Brand rule
The store needs one repeatable visual identity cue in the lobby / entrance that can also support thumbnails and hero shots. Keep it simple enough to reproduce with Studio geometry + decals.

### Sprint 6 authored identity lock
- The repeatable store mark for the slice is `SUPERSTORE` with a small `3AM` corner tag and optional `OPEN LATE` support line.
- The single hero aisle for Sprint 6 is locked to **Aisle 05 — Snacks + Soda**.
- The concrete zone, signage, small-prop, UI, and capture package for this pass is documented in `project/docs/SPRINT6-ENVIRONMENT-UI-ART-PASS.md`.

### Priority-zone identity notes
- **Lobby / entrance:** brand wall, threshold strip, basket/cart read, immediate supermarket language.
- **Checkout zone:** lane identity, bagging/scanner surfaces, queue framing, register importance at a glance.
- **Hero aisle:** aisle numeral + category header + price-strip rhythm + endcap read.
- **Freezer section:** glass/cooler framing, cold glow, restrained `powder_blue`, freezer warning language.
- **Stockroom corner:** employee-only threshold, taped boxes/pallets, payroll/policy signage, warmer `sodium_amber` support.

## UI skin direction
### Core theme
**Security terminal + receipt printer**.

### Rules
- Preserve current information hierarchy and button placement.
- Panels should feel like store hardware and payroll printouts, not sci-fi HUD glass.
- Dark shell surfaces should use `night_blue` or muted charcoal support tones.
- Inner cards, summaries, and payout surfaces should use `receipt_cream` with strong dark text.
- Use `safety_red` only for danger or failure weighting.
- Use `mimic_violet` only on mimic-specific warnings or node callouts.
- Use `payroll_green` only on success / payout confirmation.
- Icons should be simple, flat, and legible at small sizes.
- Short verbs win over flavor-heavy phrasing.
- Phone readability is mandatory: no thin type, low-contrast labels, or busy patterned panel fills.

### Sprint 6 UI surface treatment
- Outer HUD shell reads like mounted store equipment, not floating glass.
- Primary information sits on a `receipt_cream` inner card with strong dark text.
- Alerts collapse into one bottom card with clear family color cues for tutorial, blackout, mimic, success, and failure.
- Task-node feedback uses practical readable colors first, then local event accents for blackout and mimic.
- Source-backed token hooks live in `project/src/ReplicatedStorage/Shared/VisualTheme.lua`.

## Lighting and event visual rules
### Normal shift
- cool fluorescent top light
- neutral readable contrast
- clear signage visibility
- calm, tired, ordinary late-night mood

### Blackout
- store light falls out quickly
- emergency / spill light and limited practical sources preserve navigation
- interaction loss must be visible without turning the map into full darkness
- use `night_blue` structure with restrained `safety_red` or `sodium_amber` support accents where justified
- no strobe spam and no comfort-hostile flashing

### Mimic
- cue is local to the affected node
- use `mimic_violet` sparingly as the wrong-color accent
- a subtle flicker, impossible emphasis, or wrong-lit highlight is acceptable
- do not recolor the whole store purple
- cue must still read without audio

### Round end
- **success**: receipt / payroll framing with `receipt_cream` base and `payroll_green` positive accents
- **failure**: warning-weighted framing with `sodium_amber` support and restrained `safety_red`
- result state should read immediately from the first card and screen center, even on phone

## Feedback polish rules
- task-complete feedback should feel crisp and practical, like store equipment acknowledging progress
- close-register completion gets the strongest success feedback in the playable slice
- blackout recovery cue should feel like systems returning, not magical relief
- mimic trigger feedback should feel incorrect and punitive without obscuring the HUD

## Asset-source policy
Sprint 6 follows **Studio-first with optional imports**.
- Shipping success may rely entirely on Studio-built modular parts, Roblox materials, decals, and simple team-owned assets.
- Imported meshes / textures are optional only if they do not slow the sprint or become a dependency.
- Reuse one shelf / counter / cooler / signage language across the slice before requesting bespoke hero art.

## Performance and readability guardrails
- Prefer materials, decals, silhouette cleanup, and lighting grouping before adding unique mesh density.
- Zero particles are required for success.
- If flicker is used, keep it localized, brief, and readable rather than sustained or full-screen.
- Do not bury prompts, interactables, or task silhouettes in prop clutter.
- Maintain clear movement lanes in the hero aisle and checkout path.
- Background zones can remain lower density if the critical path feels authored and consistent.

## Hero-shot and proof direction
### Required visual proof
- before / after capture for each of the five priority zones from matching camera positions
- live proof for normal, blackout, mimic, and round-end readability
- at least one shot that clearly shows the move away from primitive graybox

### Thumbnail / icon direction
- favor checkout, aisle depth, freezer tension, and readable store branding
- compositions must still say supermarket at 3AM, not generic horror hallway
- keep one clean title-space area available in the icon candidate
- use the matched five-zone camera plan in `project/docs/SPRINT6-ENVIRONMENT-UI-ART-PASS.md` for before / after proof consistency
