# Content handoff

Use this file when engineering or production needs content, UI text, map beats, or thumbnail/store-page deliverables.

## Objective
Deliver the Sprint 7 content package for the full-store visual rollout: reusable signage, repeated prop/decal dressing, and an honest store-presence asset pack that matches the final in-game build.

## Protect first
- Protect the Sprint 6 Ready baseline.
- Stay inside a modular, shippable art scope.
- Do not invent new gameplay or event content to justify the art pass.
- Keep phone-safe readability and honest public capture above decorative ambition.

## Read first
- `project/prompts/MAIN_SPRINT7_SEQUENCE.md`
- `project/prompts/CONTENT_SPRINT7_FULL_STORE_ART_AND_CAPTURE.md`
- `project/docs/GDD.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT7-PLAN.md`
- `project/docs/FULL-STORE-ART-ROLLOUT-S7.md`
- `project/docs/PERFORMANCE-BUDGET-S7.md`
- `project/docs/STORE-PRESENCE-ASSETS-S7.md`
- `project/docs/HANDOFF-ENGINEERING.md`

## Files to edit
- content-facing source assets and content docs needed for Sprint 7
- store-presence image exports / shot logs / proof files
- any content checklist docs needed to complete the rollout
- `project/src/ReplicatedStorage/Shared/StoreSignage.lua`
- `project/src/ReplicatedStorage/Shared/VisualTheme.lua`
- `project/src/Workspace/FallbackArena.server.lua`
- `project/docs/SPRINT7-CONTENT-PACK.md`
- `project/docs/proof/sprint7/README.md`
- `project/docs/proof/sprint7/SHOT-LOG.md`

## Sprint 7 lock summary
**Style sentence:** Closing Shift should now read as a fluorescent suburban supermarket that is modular, phone-legible, and subtly wrong—an ordinary late-night retail box where every player-traversed space shares the same signage grammar, material language, and lighting rhythm, and where the horror lands through contrast and disruption instead of bespoke hero clutter.

## Zone priorities for content execution
### Tier A — must look shipped
- lobby / entrance
- all main playable aisles
- checkout + queue
- freezer / cooler path
- stockroom corner / entered back-of-house space
- all transitions between those spaces

### Tier B — must support Tier A consistency
- secondary aisle edges
- visible background walls and ceiling runs
- visible staff-hall segments
- visible corners next to task nodes

### Tier C — only if hidden
- unseen fixture backsides
- sealed support rooms
- distant background views outside the real playable frame

## Content deliverables
### 1. Reusable signage / decal kit
Ship a repeated, modular set for:
- aisle numbers
- category headers
- checkout numbers
- staff-only signs
- hazard signs
- exit / back-door signs
- one sale-card family
- stockroom / notice-board flavor pieces

Do not create multiple competing sign systems.

### 2. Zone dressing pass
For each Tier A zone, content should provide:
- approved sign placement logic
- repeated prop family usage
- wall / floor / ceiling treatment support
- task-safe clutter placement
- at least one capture-safe angle

### 3. Public store-presence asset pack
Required outputs:
- one approved icon direction
- three final thumbnail candidates
- one update / social shot set
- shot log noting in-game zone and camera setup used for each final image

## Signage and copy grammar
### Aisle numbers
- One hanging aisle marker per aisle mouth.
- Large numeral, short secondary label.
- Keep all markers in one style family.

### Category headers
- One or two words maximum.
- Use practical supermarket nouns only.
- Good families: `SNACKS`, `FROZEN`, `DAIRY`, `CLEANING`, `HOUSEHOLD`, `CANNED`.

### Checkout numbers
- Big read from the front store.
- Same shape, scale, and placement family for every lane.

### Staff / hazard signs
Use direct wording only:
- `EMPLOYEES ONLY`
- `STOCKROOM`
- `FREEZER`
- `NO ENTRY`
- `WET FLOOR`
- `EXIT`
- `BACK DOOR`
- `NOTICE BOARD`

### Sale cards
- One family only.
- Short headline plus large price read.
- Accent color is consistent and reserved.
- Do not flood shelves with sale spam.

## Primitive-remnant policy for content
Must replace or shell in Tier A and readable Tier B:
- raw gray architecture
- primitive shelves / checkout / freezer blocks
- blank sign planes
- unlabeled cube crates and pallets in readable spaces
- placeholder threshold doors

Can remain only if hidden from play and capture:
- unseen fixture backsides
- sealed-room internals
- upper unseen faces
- fully occluded support geometry

## Transition support rules
### Lobby -> main floor
- Carry the same store identity into the entrance.
- Make checkout or the aisle structure readable from the threshold.
- Avoid a dead vestibule that feels disconnected from the store.

### Main floor -> freezer
- Use colder tint, cooler frames, and utility-floor cues.
- Keep signage and path readability strong.

### Main floor -> stockroom
- Use staff-only doors, utility materials, and operations signage.
- Keep the area sparse but authored.

### Global continuity
- Adjacent zones should feel like variants of one store, not unrelated mood boards.
- No public-facing shot should expose a raw style reset between connected spaces.

## Public asset direction
### Experience icon
- Square composition.
- Checkout or front-store identity first.
- Threat second.
- Must survive small-size read.

### Thumbnail set
1. **Store at 3AM**
   - clear supermarket read
   - signage visible
   - honest Tier A geometry
2. **Blackout**
   - same store under emergency conditions
   - route and silhouette readability preserved
3. **Mimic tension**
   - uncanny wrongness in a real task zone
   - still clearly this game

### Update / social shots
Priority order:
1. before / after visual-upgrade comparison
2. full-store checkout or hero-aisle proof shot
3. blackout readability shot
4. mimic readability shot

## Capture constraints
- Capture from the real shipped build or exact release candidate.
- Do not invent non-playable one-off scenes for the store page.
- Use completed Tier A spaces only.
- Keep framing honest to what a player can actually find in the game.
- Do not rely on paint-over, fake post, or impossible lighting.
- Record the zone and camera setup for every final shot.

## Proof package expected from content
### Environment / rollout proof
- [ ] before / after pair for lobby / entrance
- [ ] before / after pair for main aisle coverage
- [ ] before / after pair for checkout / queue
- [ ] before / after pair for freezer / cooler path
- [ ] before / after pair for stockroom corner
- [ ] at least one transition continuity frame

### Store-presence proof
- [ ] icon candidate sheet
- [ ] final Thumbnail A
- [ ] final Thumbnail B
- [ ] final Thumbnail C
- [ ] update / social shot set
- [ ] mobile-safe crop review
- [ ] shot log with source zones / camera setups

## Current Sprint 7 content execution status
### Source-side rollout landed
- Reusable signage grammar is now centralized in `project/src/ReplicatedStorage/Shared/StoreSignage.lua`.
- Sprint 7 rollout/capture metadata is now centralized in `project/src/ReplicatedStorage/Shared/VisualTheme.lua`.
- `project/src/Workspace/FallbackArena.server.lua` now carries a broader full-store continuity pass instead of only a narrow polished slice: more aisle coverage, hanging aisle markers, checkout support signage, freezer threshold framing, stockroom threshold framing, route arrows, and added capture anchors.

### Honest capture package status
- The shot-plan/proof structure is prepared in `project/docs/SPRINT7-CONTENT-PACK.md` and `project/docs/proof/sprint7/SHOT-LOG.md`.
- No Sprint 7 public screenshots are claimed as exported yet from this content pass.
- QA should only mark store-presence proof complete once the real build images are captured and attached to the Sprint 7 proof folder.

## Content done condition
Content is done with Sprint 7 when:
- Tier A spaces have a consistent repeated language,
- Tier B supports Tier A without obvious placeholder drift,
- visible primitive leftovers are gone or hidden,
- signage and sale-card systems are unified,
- the public asset pack matches the real store,
- QA and production can approve the capture set without feeling misled.
