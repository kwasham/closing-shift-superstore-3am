# Sprint 7 Content Pack — Full-Store Art Rollout + Store Presence

## Purpose
Turn the locked Sprint 7 visual spec into a concrete content package: one reusable signage family, one repeated store language across Tier A and visible Tier B, and an honest capture pack plan tied to the real build.

## What landed in content-facing source
- `project/src/ReplicatedStorage/Shared/StoreSignage.lua`
  - expanded aisle/header coverage to support repeated full-store rollout
  - locked one sale-card family, one checkout family, and direct operational signs
  - added zone-level must-read/capture notes for Lobby, Checkout, HeroAisle, Freezer, and Stockroom
- `project/src/ReplicatedStorage/Shared/VisualTheme.lua`
  - added Sprint 7 rollout metadata for Tier A / Tier B / Tier C and public-capture hook names
- `project/src/Workspace/FallbackArena.server.lua`
  - extended the text-managed fallback store from a narrow Sprint 6 slice toward a full-store continuity pass
  - added repeated aisle markers, more shelf coverage, threshold frames, signage, route arrows, sightline walls, and extra capture anchors

## Tier A rollout intent
### Lobby / entrance
- front wall carries `SUPERSTORE`, `3AM`, and `OPEN LATE`
- entrance now points players toward checkout instead of feeling like a dead vestibule
- exit wayfinding is present without overpowering the store identity
- capture-safe read: threshold toward the front store

### Checkout + queue
- register family is repeated and readable from the front-store angle
- `CASH OUT`, `BAG HERE`, and `LANE CLOSED` all use one system
- queue rails and floor arrows keep the space legible
- capture-safe read: front-store checkout hero frame

### Main playable aisles
- aisle coverage now reads as repeated store kit instead of one hero bay floating in graybox
- hanging aisle markers are used at aisle mouths
- category labels stay short: `SNACKS`, `CLEANING`, `HOUSEHOLD`, `CANNED`
- endcap sale card stays sparse and uses the single approved sale family
- capture-safe read: cross-aisle frame with multiple markers visible

### Freezer / cooler path
- colder threshold and floor treatment support the transition
- `FREEZER`, `FROZEN`, and `KEEP DOOR CLOSED` create a direct operational read
- route arrow keeps the path legible for blackout/store-presence capture
- capture-safe read: threshold into the cooler line with doors in frame

### Stockroom corner / entered back-of-house
- threshold now reads as staff-only and operational
- `EMPLOYEES ONLY`, `STOCKROOM`, `NOTICE BOARD`, `RECEIVING`, and `BACK DOOR` reinforce the zone without clutter
- hall/floor treatment stays sparser than the sales floor but authored
- capture-safe read: threshold into the pallet / board / back-door corner

## Tier B continuity notes
Visible Tier B continuity now depends on repeated support language, not one-off props:
- sightline walls use repeated color bands instead of flat empty slabs
- ceiling runs now repeat fluorescent fixture rhythm across more of the store footprint
- secondary aisle edges are implied through added shelf bays and extra aisle markers
- staff-hall sightline is established through the stockroom threshold/floor strip instead of a hard visual reset

## Reusable signage grammar
### Aisle markers
- one hanging marker family
- large numeral over one short category label
- no competing novelty sign styles

### Category headers
Approved short retail nouns used in source:
- `PRODUCE`
- `DAIRY`
- `SNACKS`
- `CLEANING`
- `HOUSEHOLD`
- `FROZEN`
- `CANNED`
- `PETS`

### Checkout family
- `REGISTER 1`
- `REGISTER 2`
- `REGISTER 3`
- `REGISTER 4`
- `CASH OUT`
- `BAG HERE`
- `LANE CLOSED`

### Staff / hazard family
- `EMPLOYEES ONLY`
- `STOCKROOM`
- `NOTICE BOARD`
- `RECEIVING`
- `BACK DOOR`
- `NO ENTRY`
- `FREEZER`
- `WET FLOOR`

### Sale-card family
- one family only
- current source copy: `NIGHT PRICE`, `SAVE NOW`, `2 FOR 1`
- keep usage sparse so prompts and event states stay stronger than merch spam

## Capture pack direction
Sprint 7 public surfaces should be framed from real playable angles only.

### Icon direction
- checkout/front-store read first
- store identity and lane rhythm must survive small-size crop
- threat stays secondary
- preferred anchor: `StorePageIconAnchor`

### Thumbnail directions
1. **Store at 3AM**
   - preferred anchor: `EntranceWideCaptureAnchor`
   - must show honest checkout + aisle structure
2. **Blackout**
   - preferred anchor: `BlackoutCheckoutCaptureAnchor`
   - same geometry, no fake cinematic relight
3. **Mimic tension**
   - preferred anchor: `MimicAisleCaptureAnchor`
   - real task zone, uncanny read, still clearly this store

### Update / social direction
- preferred anchors:
  - `UpdateCompareAnchor`
  - `ContinuityCaptureAnchor`
- priority order:
  1. before / after comparison
  2. full-store continuity proof
  3. blackout readability
  4. mimic readability

## Proof standard for QA
QA should expect the Sprint 7 proof pack to contain:
- before / after for Lobby
- before / after for main aisle coverage
- before / after for Checkout
- before / after for Freezer
- before / after for Stockroom
- at least one continuity frame proving connected zones still read as one store
- store-presence crop review for icon + 3 thumbnails + update shot

## Honesty note
This pass prepared the source-facing rollout and the capture hooks/shot plan.
No new Sprint 7 public screenshots are claimed in this document yet. Final exported images still need to be captured from the real build candidate and logged in `project/docs/proof/sprint7/SHOT-LOG.md`.
