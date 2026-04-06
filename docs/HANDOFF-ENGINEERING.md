# Engineering handoff

Use this file when design has a concrete implementation brief for engineering.

## Objective
Execute Sprint 7 as a full-store visual rollout plus store-presence support pass that scales the accepted Sprint 6 slice across the rest of the player-visible store without changing gameplay scope or destabilizing the runtime baseline.

## Protect first
- Protect the Sprint 6 Ready baseline.
- Do not introduce new gameplay systems, event mechanics, economy tuning, or map-expansion work.
- Prioritize player-visible consistency, phone readability, and runtime safety over bespoke polish.

## Read first
- `project/prompts/MAIN_SPRINT7_SEQUENCE.md`
- `project/prompts/ENGINEER_SPRINT7_ART_ROLLOUT_AND_PERFORMANCE.md`
- `project/docs/GDD.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT7-PLAN.md`
- `project/docs/FULL-STORE-ART-ROLLOUT-S7.md`
- `project/docs/PERFORMANCE-BUDGET-S7.md`
- `project/docs/STORE-PRESENCE-ASSETS-S7.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Files to edit
- runtime/source files needed to land the Sprint 7 rollout safely
- `project/docs/RUNTIME-EVIDENCE.md`
- any Sprint 7 proof docs or checklists required by the implementation pass

## Sprint 7 lock summary
**Style sentence:** Closing Shift should now read as a fluorescent suburban supermarket that is modular, phone-legible, and subtly wrong—an ordinary late-night retail box where every player-traversed space shares the same signage grammar, material language, and lighting rhythm, and where the horror lands through contrast and disruption instead of bespoke hero clutter.

## Zone rollout table
| Tier | Zone | Required Sprint 7 outcome | Acceptable simplification | Proof expectation |
| --- | --- | --- | --- | --- |
| A | Lobby / entrance | Must read as the same product as the store interior, with clear store identity and no graybox threshold seam | Simple prop count is fine if signs, materials, and lighting continuity are present | before / after pair + public-capture-safe angle |
| A | Main playable aisles | All traversed aisles must use approved floor / wall / ceiling / shelf language and readable department markers | Repeated modular dressing is preferred over unique aisle art | before / after pairs across representative aisle coverage |
| A | Checkout + queue | Checkout lanes must read instantly from the front store via counter silhouette, numbering, queue language, and front-store signage | Limit clutter if needed; clarity matters more than density | before / after pair + icon / thumbnail candidate angle |
| A | Freezer / cooler path | Freezer must be a clear colder variant of the same store, not a raw placeholder room | Keep prop count light if needed; prioritize cooler frames, signs, flooring, and readable path | before / after pair + blackout-safe proof angle |
| A | Stockroom corner / entered back-of-house | Must look operational and authored with staff-only identity and utility materials | Lower visual density than sales floor is acceptable | before / after pair + transition proof |
| A | Transitions between all Tier A zones | No doorway or turn may expose a raw style reset or obvious placeholder seam | Minimal dressing is acceptable if continuity holds | at least one continuity shot per transition type |
| B | Secondary aisle edges | Must feel finished from normal player sightlines | Simplified dressing allowed away from task space | included in Tier A continuity frames |
| B | Sightline walls / ceiling runs | Must support the full-store illusion and stop the half-graybox read | Repeated material treatment is fine | visible in before / after sweeps |
| B | Visible staff-hall segments | Must match the stockroom support language | Light detail pass is acceptable | visible in transition or stockroom proof |
| B | Task-adjacent corners | Must not look raw beside interactable nodes | Keep clutter low around prompts | visible in task-readable proof |
| C | Hidden fixture backs / sealed support spaces / distant background views | Can stay simple only if they are hidden from normal play and capture | Hidden primitives are acceptable here | no public or QA hero frame may expose them |

## Signage / decal rules
### Aisle markers
- One hanging aisle sign per aisle mouth.
- Large numeral first, short secondary label second.
- Keep placement consistent across the store.

### Category headers
- Use short, phone-readable retail nouns.
- One or two words max in the visible headline.
- Mount over the correct shelf run or department edge.

### Checkout numbering
- Large numerals above or immediately behind each lane.
- Every checkout sign uses the same family and placement logic.

### Staff / hazard signs
Use direct wording only:
- `EMPLOYEES ONLY`
- `STOCKROOM`
- `FREEZER`
- `NO ENTRY`
- `WET FLOOR`
- `EXIT`
- `BACK DOOR`

### Sale-card system
- One repeated sale-card family only.
- Accent color must stay reserved and consistent.
- Decorative sale signage cannot compete with task prompts or round alerts.

## Must-replace primitive matrix
| Primitive / placeholder form | Tier A | Tier B visible sightlines | Tier C hidden / non-traversed |
| --- | --- | --- | --- |
| Raw gray floors | Must replace | Must replace if visible from normal routes | Accept only if hidden |
| Raw gray walls | Must replace | Must replace if visible from normal routes | Accept only if hidden |
| Raw gray ceilings / no fixture rhythm | Must replace | Must replace if clearly visible | Accept only if hidden |
| Primitive shelf blocks | Must replace | Must replace if exposed near task routes | Accept only if unseen backsides |
| Primitive checkout blocks | Must replace | n/a | Not acceptable in captureable space |
| Primitive freezer cubes | Must replace | Must replace if visible from store path | Accept only if fully hidden |
| Placeholder doors at playable thresholds | Must replace | Must replace if readable by players | Accept only behind sealed space |
| Unlabeled cube crates / pallets in readable space | Must replace | Replace or hide if visible from play | Accept only if hidden |
| Blank sign panels / temp text markers | Must replace | Must replace | Never acceptable in public capture |

## Hidden-remnant rule
A remnant is only acceptable if all of the following are true:
1. it is outside normal player traversal,
2. it does not appear in Tier A or Tier B sightlines,
3. it does not appear in before / after proof,
4. it does not appear in icon / thumbnail / update-shot capture.

If any one of those fails, replace or hide it this sprint.

## Lighting continuity rules
- Keep one readable fluorescent baseline across the store.
- Lobby may be slightly warmer than the main floor, but it must still feel connected.
- Freezer may be colder than the main floor, but prompt and route readability must stay intact.
- Stockroom may be slightly dimmer and more industrial, but it cannot read as a separate game.
- Blackout and mimic states should primarily transform the established store lighting rather than add stacks of new temporary lights.
- Checkout, freezer, stockroom, exits, and teammate silhouettes must remain readable during blackout and mimic proof.

## Performance guardrails
### Reuse and asset scope
- Prefer approved modular shelf, checkout, freezer, pallet, and signage families.
- Default target: no new one-off hero meshes are required to finish Sprint 7.
- If a new imported mesh family is introduced, it must either repeat across multiple views or unblock a locked public-capture need; do not add one-off vanity assets.
- Prefer materials, tint, and decal passes before dense custom geometry.

### Lights
- Keep always-on non-ceiling accent lights to **2 or fewer** in any normal Tier A gameplay frame.
- Event-only emphasis lights should be localized and short-lived.
- Use **1 localized extra event-light cluster max** at a read point; prefer toggling or recoloring existing fixtures.
- Do not stack overlapping decorative lights in the same aisle or fixture bank.

### Props / clutter
- Dense clutter belongs only at focal points.
- Task lanes, queue lanes, and prompt space stay clean.
- Props cannot create false interaction reads near real nodes.
- Keep floor clutter out of the main walk lane and out of the immediate prompt approach zone.

### Decals / signage
- Signage is readable first, decorative second.
- Keep text systems consistent store-wide.
- Use **one aisle number + one category header read per aisle mouth** as the default target, not stacked sign spam.
- Use **one sale-card family only** across the store.
- Avoid attention colors that compete with blackout / mimic / alert states.

### Runtime safety rule
If an art improvement introduces recurring hitching, blocked prompts, unreadable HUD/prompt text, or unclear blackout/mimic reads, cut the art detail before shipping.
## Fallback order if time compresses
1. materials / silhouette cleanup
2. signage / wayfinding
3. lighting continuity
4. medium prop density
5. optional micro-clutter

## Public capture constraints
- Only capture completed Tier A zones.
- Do not hide unresolved Tier A seams and present the result as full-store completion.
- Capture from the real shipped build or the exact build candidate.
- Use only real in-game lighting states that players can actually see.
- No overpaint or fake post-processing that the live game does not deliver.
- Blackout and mimic capture must still preserve route and prompt readability.

## QA-ready proof checklist
### Before / after proof
- [ ] Lobby / entrance before / after
- [ ] Main aisle before / after
- [ ] Checkout / queue before / after
- [ ] Freezer / cooler path before / after
- [ ] Stockroom corner before / after
- [ ] At least one continuity shot proving adjacent zones read as one store

### Readability proof
- [ ] Active-shift frame in a completed Tier A zone with readable HUD and prompt
- [ ] Blackout frame showing route and prompt readability
- [ ] Mimic frame showing a distinct read from blackout
- [ ] Phone-sized review that confirms HUD / prompt readability remains intact

### Runtime / safety proof
- [ ] Build green
- [ ] Smoke green
- [ ] 1-player sanity green after rollout
- [ ] 2-player sanity green after rollout
- [ ] Any exception documented by exact zone and mitigation

## Engineering done condition
Engineering is done with its side of Sprint 7 when:
- Tier A rollout is complete,
- Tier B visible consistency is complete,
- Tier C remnants are hidden from play and capture,
- signage grammar is implemented consistently,
- blackout and mimic readability remain clear,
- performance guardrails hold,
- QA can judge the store as one coherent shipped space rather than a polished slice plus leftovers.

## 2026-04-05 engineering implementation snapshot
### Landed source changes
- Added `project/src/ReplicatedStorage/Shared/StoreRollout.lua` to centralize Sprint 7 zone order, capture hooks, and runtime grouping names.
- Expanded `project/src/ReplicatedStorage/Shared/StoreSignage.lua` to a locked Sprint 7 signage grammar: eight aisle markers, four checkout lane markers, direct staff signs, and one repeated sale-card family.
- Extended `project/src/ReplicatedStorage/Shared/VisualTheme.lua` with Sprint 7 rollout metadata plus low-cost world-state styling for signage / fixture banks across `normal`, `blackout`, `mimic`, `round_success`, and `round_failure`.
- Rebuilt `project/src/Workspace/FallbackArena.server.lua` into a fuller fallback store shell with Tier A coverage, Tier B sightline support, capture hooks, runtime-safe group references, and placeholder masking where safe.
- Updated both lighting controllers so the wider store art groups preserve visual-state continuity without stacking extra effect layers.
- Reconciled the drifted runtime bootstrap enough to keep proof support healthy: richer `Constants.lua`, `Config.lua`, `ProfileStore.lua`, `ShiftService.lua`, and `Remotes.model.json` now match the already-landed HUD / shop / proof expectations closely enough for buildable sanity.

### Command-backed proof now green
- `bash scripts/check.sh`
- `bash scripts/build.sh`
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua`
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint7_art_rollout_probe.lua`
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/round_bootstrap_proof.lua`
- `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint7_two_player_sanity.lua`

### QA focus after this handoff
- Judge live player-visible continuity and capture honesty from the real build using the Tier A / transition shot list.
- Specifically verify blackout and mimic readability in the widened store, not only the original Sprint 6 slice angles.
- Watch for any remaining Tier B seam that appears only in motion or in wider store-presence framing.
