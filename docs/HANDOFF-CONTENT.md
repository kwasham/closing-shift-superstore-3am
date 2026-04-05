# Content handoff — Sprint 6 visual identity pack

Use this file as the content brief for Sprint 6 visual identity execution, capture support, and public-facing visual proof.

## Objective
Deliver the authored visual identity for the Sprint 6 slice so players, QA, and store-page surfaces immediately read **supermarket at 3AM** instead of generic graybox horror.

Content should execute the locked art direction without inventing new gameplay scope.

## Read first
- `project/docs/SPRINT6-PLAN.md`
- `project/docs/ART-BIBLE-S6.md`
- `project/docs/ENVIRONMENT-KIT-S6.md`
- `project/docs/HERO-SHOT-LIST-S6.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`

## Scope lock
In scope:
- lobby / entrance
- checkout zone
- one hero aisle
- freezer section
- stockroom corner
- signage pack and decal language for those spaces
- HUD / UI skin visual references
- event-state visual identity references for normal / blackout / mimic / round-end
- before / after capture support
- hero-shot and thumbnail direction

Out of scope:
- new map areas
- new gameplay mechanics
- lore-heavy environmental storytelling that muddies readability
- bespoke hero art dependency that blocks the sprint

## Final style statement
**Closing Shift: Superstore 3AM is stylized retail horror: an ordinary late-night supermarket built from clean modular forms, readable materials, and fluorescent lighting that becomes subtly wrong under pressure.**

## Locked priority order
1. **lobby / entrance**
2. **checkout zone**
3. **one hero aisle**
4. **freezer section**
5. **stockroom corner**

## Content rules
- Retail first, horror second.
- Phone readability beats micro-detail.
- Prefer reusable kits over one-off hero set dressing.
- Horror should come from emptiness, wrongness, and lighting contrast, not gore or shock props.
- Studio-first with optional imports is the policy; do not assume an import pipeline is available.

## Required content deliverables
### 1. Signage and decal language pack
Provide or define:
- store branding focal element for lobby / entrance
- aisle numerals and category header system
- sale / price card system with one-accent-color discipline
- checkout lane / register support signage
- freezer warning / cooler labeling
- employee-only, hazard, payroll, and policy signage for stockroom flavor
- shelf-price strips, box labels, receipt clutter, scanner / terminal surface accents

### Sprint 6 execution package in this pass
Use `project/docs/SPRINT6-ENVIRONMENT-UI-ART-PASS.md` as the concrete implementation guide.

Locked authored calls made for content execution:
- repeatable brand mark = `SUPERSTORE` + `3AM` tag + optional `OPEN LATE` support line
- hero aisle = **Aisle 05 — Snacks + Soda**
- reusable sign-copy pack source = `project/src/ReplicatedStorage/Shared/StoreSignage.lua`
- reusable UI token source = `project/src/ReplicatedStorage/Shared/VisualTheme.lua`
- live HUD skin support path = `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua`
- task-node / event-color support path = `project/src/StarterPlayer/StarterPlayerScripts/ClientEffects.client.lua`
- text-managed fallback slice support path = `project/src/Workspace/FallbackArena.server.lua`

Dependency note:
- no external mesh, texture, or decal import is required by this pass
- optional imports remain unlocked only after the Studio-first version is approved

### 2. Zone-authored set dressing for the five priority spaces
Content should author the minimum visual density that makes each zone feel intentional from normal player camera height.

### 3. UI skin reference package
Provide visual references or mock-level direction for:
- HUD shell
- timer block
- objective card styling
- alert card variants
- payout / round-end receipt treatment
- interaction feedback feel

### 4. Proof and capture package
Prepare matching before / after camera spots and hero-shot compositions for QA and release-facing use.

## Zone-by-zone brief
### 1. Lobby / entrance
**Purpose:** first impression, branding, and immediate fantasy read.

Must include:
- one memorable branded focal point
- authored floor and wall treatment
- threshold framing that reads as supermarket entry, not warehouse spawn
- enough signage to teach the store language immediately

Avoid:
- empty gray foyer
- clutter that hides the first route into the store

### 2. Checkout zone
**Purpose:** operational heart of the store and strongest gameplay focal point.

Must include:
- authored checkout counter language
- bagging / register framing
- lane identity and queue support
- readable price / lane / store-system signage
- the close-register objective should look important before the player is told it is important

Avoid:
- generic desk cubes
- prop piles that muddy counter readability

### 3. One hero aisle
**Purpose:** prove the reusable shelf kit, category signage, and store identity at gameplay scale.

Must include:
- modular shelf bay language
- one clear category identity
- price strips and repeatable product-facing silhouettes
- an endcap or aisle-top element that reads in thumbnails and mid-distance shots

Avoid:
- clutter that narrows the lane or hides tasks
- random assortment with no category read

### 4. Freezer section
**Purpose:** distinct material and color break that still belongs to the same store.

Must include:
- glass / cool metal read
- cold-zone lighting feel
- restrained `powder_blue` accent use
- freezer warning or cooler labeling that supports the zone identity

Avoid:
- warm muddy lighting
- identical material treatment to the hero aisle

### 5. Stockroom corner
**Purpose:** utility, employee-only access, and slight unease.

Must include:
- industrial door or threshold language
- pallet / taped-box / utility prop family
- employee-only / policy / hazard signage
- a rawer floor and wall treatment than the public sales floor

Avoid:
- decorative hero clutter
- unreadable darkness

## Palette and signage rules for content
| Token / rule | Use it for | Avoid using it for |
| --- | --- | --- |
| `fluorescent_white` | baseline fixtures, neutral bright highlights | danger and mimic emphasis |
| `tile_gray` | main floor neutrality and architecture base | promotional callouts |
| `powder_blue` | freezer accents and cold-zone identity | checkout focal points |
| `safety_red` | urgent warnings, hazards, emergency support | everyday sales signage |
| `receipt_cream` | receipt / payroll surfaces and paper props | ambient lighting |
| `sodium_amber` | stockroom warmth and caution support | normal sales-floor dominant tone |
| `mimic_violet` | local mimic callout only | normal environment dressing |
| `night_blue` | blackout depth and dark UI shell support | primary text on its own |
| `payroll_green` *(UI-only derived accent)* | success stamps and payout accents | world signage or environment light |

## Typography and language direction
- Big signs should be bold, simple, and legible at a distance.
- Category language should feel like grocery retail, not stylized fantasy lore.
- Employee-only and hazard signs should feel institutional and practical.
- Sale cards get one accent color each, not multicolor event-poster energy.
- Keep copy short enough to read quickly from camera distance or on phone.

## Event-state visual brief
### Normal
- quiet fluorescent retail
- readable neutral signage
- low drama, tired late-night mood

### Blackout
- fast loss of store light
- emergency / spill light supports silhouettes and navigation
- no visual chaos that makes the store illegible

### Mimic
- one local uncanny cue around the affected task node
- `mimic_violet` used sparingly
- should feel incorrect, not magical or cosmic

### Round end
- success = receipt / payroll relief with `receipt_cream` + `payroll_green`
- failure = warning-weighted summary using `sodium_amber` + restrained `safety_red`

## UI treatment brief
- Theme is **security terminal + receipt printer**.
- Panels should look like store equipment and payroll printouts.
- Preserve layout hierarchy and touch targets.
- Alerts need three readable families: normal, danger / blackout, and mimic.
- Round-end summary should feel like a printed result slip, not a fantasy reward chest.

## Hero-shot and thumbnail direction
Use the Sprint 6 shot list as the base and lock the following intent:

### Required shots
1. **Icon candidate**
   - close register foreground
   - player silhouette or hands near checkout
   - aisle or freezer tension in background
   - clear title-space area

2. **Thumbnail A — Closing shift tension**
   - wide checkout + aisle view
   - readable store branding
   - one uncanny clue in the distance

3. **Thumbnail B — Blackout moment**
   - same store identity preserved under emergency-light mood
   - blackout must still read as this specific supermarket

4. **Thumbnail C — Freezer dread**
   - cool-toned freezer area
   - strong silhouette and contrast
   - no overbusy clutter

5. **Update / social shot**
   - explicit before / after reveal showing graybox-to-authored improvement

### Capture rules
- No shot should depend on HUD for meaning.
- Foreground, midground, and background should all help sell supermarket identity.
- Avoid generic horror-hallway compositions.
- Keep signs, shelf language, and checkout identity visible whenever possible.

## Before / after plus live proof direction
Prepare for QA and production:
- one locked before / after camera setup per priority zone
- one live proof setup each for blackout, mimic, and round-end
- at least one proof shot where the same frame clearly shows the Sprint 6 uplift over the old primitive look
- use the exact five-zone camera intents listed in `project/docs/SPRINT6-ENVIRONMENT-UI-ART-PASS.md` so QA, content, and release surfaces are comparing like-for-like frames

## Coordination rules
- Do not rename or move gameplay-critical nodes without engineering coordination.
- Decorative art should sit around the gameplay path, not inside it.
- If optional imports are used, document IDs and fallback replacements.
- If time is tight, finish materials, silhouettes, signage, and focal props before chasing bespoke detail.

## Acceptance criteria
- Content can execute the slice with no style ambiguity left.
- The five priority zones each have a clear authored identity.
- Signage, palette, and UI references are specific enough for implementation.
- Hero-shot and before / after capture direction is ready for QA and release surfaces.
- The result still reads cleanly on phone and does not require an import pipeline to succeed.
- The authored slice package is concrete enough that engineering and QA can point to exact sign copy, zone identity, UI surface hooks, and proof angles without inventing missing content direction.
