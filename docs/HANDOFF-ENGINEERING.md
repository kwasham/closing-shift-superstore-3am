# Engineering handoff — Sprint 6 visual direction lock

Use this file as the implementation brief for the Sprint 6 visual identity and environment art foundation pass.

## Objective
Replace the most visible primitive / graybox read in the player-facing critical path with a reusable visual foundation that makes the game feel branded and intentional **without changing core gameplay behavior**.

Engineering is responsible for making the visual rules shippable in runtime while protecting the Sprint 5 Ready baseline.

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
- lighting states for normal / blackout / mimic / round-end
- HUD / UI skin refresh
- interaction feedback polish
- before / after and live proof support

Out of scope:
- new gameplay systems
- layout expansion beyond the connecting space needed to make the slice coherent
- economy or progression changes
- combat, matchmaking, or map-count changes
- full-store bespoke art pass

## Non-negotiable baseline rules
- Preserve the Sprint 5 Ready playable path.
- Do not move, rename, or delete runtime-critical nodes without explicit coordination.
- Collision, interaction range, and task readability must survive every art replacement.
- Studio-first with optional imports is the asset-source rule.
- Phone readability wins over visual flourish.

## Locked zone priority
1. **lobby / entrance**
2. **checkout zone**
3. **one hero aisle**
4. **freezer section**
5. **stockroom corner**

If time gets tight, finish higher-priority zones to a stronger level rather than spreading a half-pass across the whole map.

## Palette and material implementation table
| Token / rule | Primary runtime use | Allowed locations | Engineering note |
| --- | --- | --- | --- |
| `fluorescent_white` | default store lighting and neutral highlight contrast | normal-shift fixtures, neutral highlight edges, readable UI highlight text | keep this as the main sales-floor light identity |
| `tile_gray` | neutral architecture base | floor tile, neutral wall / floor breakup, non-focal shell surfaces | supports readability; should not become muddy or overly dark |
| `powder_blue` | cold-zone accent | freezer / cooler trim, freezer signage accents, cold-zone UI tags if needed | reserve for freezer identity so the zone reads instantly |
| `safety_red` | danger accent | hazard striping, urgent alerts, emergency language, failure support accents | do not let it dominate normal store surfaces |
| `receipt_cream` | receipt / payroll surface language | summary cards, payout surfaces, card interiors, paper props | use to separate UI content from dark shell framing |
| `sodium_amber` | practical warm warning support | stockroom warmth, caution-adjacent lighting, failure support tone | not a main-floor dominant color |
| `mimic_violet` | localized mimic cue | active mimic node visual, mimic-specific alert accent, wrong-lit local emphasis | never a store-wide wash |
| `night_blue` | blackout structure and dark shell support | blackout fill, dark UI shell, shadow depth | preserve enough contrast for silhouettes and text |
| `payroll_green` *(UI-only derived accent)* | success confirmation | payout arrows, checks, success stamps, positive round-end accents | keep this out of environment lighting and signage |
| Architecture baseline | commercial tile / sealed concrete, painted block or panels, fluorescent ceiling grid | all sprint-6 zones | use repeatable modular surfaces before bespoke geo |
| Fixture baseline | coated metal shelves, laminate + metal checkout, glass + cool metal freezers | checkout / aisle / freezer families | kit reuse matters more than one-off prop heroics |

## Lighting-state intent by mode
| Mode | Visual intent | Runtime rule | Must remain readable |
| --- | --- | --- | --- |
| Normal | cool fluorescent, ordinary late-night supermarket | stable top-light read, clear signs, readable neutral contrast | tasks, signs, prompts, safe movement |
| Blackout | power loss with emergency support | main store light drops quickly; emergency / spill light preserves orientation; no full darkness soft-lock | routes, silhouettes, prompts that must visibly disable or recover |
| Mimic | local wrongness around one affected node | one localized uncanny cue with `mimic_violet`, slight wrong emphasis or brief flicker | the targeted node, nearby space, HUD alert |
| Round-end success | payroll relief and completion clarity | `receipt_cream` result surfaces with restrained `payroll_green` accents | payout, outcome, next action |
| Round-end failure | warning-weighted summary | `sodium_amber` support with restrained `safety_red` emphasis | failure cause, retry / continue action |

## UI component treatment list
| Component | Treatment | Color behavior | Readability rule |
| --- | --- | --- | --- |
| HUD shell / frame | security-terminal outer shell | dark shell with `night_blue` support | no decorative noise behind text |
| Timer | bold digital focal element | bright neutral on dark shell; danger escalation may use restrained red support | readable at a glance on phone |
| Objective list | receipt / task-card hybrid | `receipt_cream` or high-contrast neutral interior with dark text | completed vs pending states must separate instantly |
| Cash / payout display | receipt / payroll flavor | `receipt_cream` base with `payroll_green` only for positive confirmation | cash total cannot blend into shell |
| Alerts — normal | concise store-system message card | neutral or `receipt_cream` support | short verb-led text |
| Alerts — danger / blackout | urgent store warning | `safety_red` accent on dark or neutral card | urgent but not visually noisy |
| Alerts — mimic | false-task warning | `mimic_violet` accent only on mimic-specific card | visually distinct from blackout |
| Interaction prompt | short practical verb | high-contrast label, minimal ornament | must remain legible over world art |
| Round-end summary | printed receipt / payroll stub | success uses `payroll_green`; failure uses `sodium_amber` + restrained `safety_red` | first card tells the outcome immediately |
| Task-complete feedback | crisp equipment acknowledgment | neutral / positive accent, not full-screen celebration | must not block active play |

## Must-fix primitive replacement matrix
| Zone / surface | Current graybox risk | Minimum replacement required this sprint | Preserve |
| --- | --- | --- | --- |
| Lobby / entrance floor and walls | first impression still reads prototype | commercial floor material, authored wall treatment, trim breakup, branded focal sign | spawn flow, sightline into store |
| Lobby / entrance desk / frontage | plain block surfaces with no store identity | simple service/front desk language, readable counter silhouette, branded or policy signage | interaction clearance and player path |
| Checkout counters | cubes with no authored retail language | laminate + metal-edged counter kit, scanner/register framing, bagging surface accents | close-register logic, prompt position, counter collision |
| Queue / checkout support props | lane reads unfinished | queue definition, bags, basket touchpoints, price / lane signage | movement lane width |
| Hero aisle shelf bays | blank primitives hide product identity | modular shelf kit with price strips, category header, repeatable product-facing silhouettes | path width and node readability |
| Hero aisle endcap | empty or generic block | endcap shelf or sign topper that sells category identity | camera sightline and player route |
| Freezer cases and threshold | same look as main aisle | cool metal + glass read, interior glow, powder-blue accent restraint, freezer threshold framing | freezer task node placement |
| Stockroom door / corner | back-of-house has no authored utility read | industrial door frame, hazard / employee-only language, pallets / taped boxes, rawer floor treatment | stockroom access and navigation |
| Small prop families across slice | primitive clutter with no system | reusable baskets, carts, caution props, labels, boxes, receipt clutter, posters | prompt visibility and collision sanity |
| HUD panels | debug-box read | security-terminal + receipt-printer skin while preserving layout hierarchy | all existing HUD information flow |

## Implementation rules
- Prefer modular family replacements over one-off hero meshes.
- Untouched background zones may stay low density if they inherit the same palette and material language.
- Replace eye-level surfaces before polishing unreachable corners.
- Separate decorative props from gameplay-critical nodes in organization and naming.
- Document any imported asset IDs if optional imports are used.

## Performance guardrails
- Shipping success cannot depend on imported assets.
- Prefer decals, materials, and silhouette upgrades before adding unique geometry density.
- Zero particles are required for success.
- If particles are used, keep them limited to small accent support and never core readability.
- Blackout should use controlled light-group state changes, not spammy flashing or comfort-hostile strobing.
- Mimic should use one localized effect cluster per active node, not a store-wide treatment.
- Avoid decorative clutter that blocks player movement, prompt visibility, or camera readability.
- Keep the slice performant by finishing the five zones well instead of lightly touching the entire map.

## QA proof checklist
Engineering is not done until QA can capture or verify the following:
- [ ] before / after comparison for lobby / entrance from the same camera angle
- [ ] before / after comparison for checkout zone from the same camera angle
- [ ] before / after comparison for hero aisle from the same camera angle
- [ ] before / after comparison for freezer section from the same camera angle
- [ ] before / after comparison for stockroom corner from the same camera angle
- [ ] normal-shift look reads as a believable supermarket from player camera height
- [ ] blackout look is visually distinct at a glance and does not destroy navigation readability
- [ ] mimic cue is visible at the affected node without audio-only dependence
- [ ] round-end success and failure are visually distinct from each other
- [ ] HUD remains readable on phone-sized layout during normal, blackout, mimic, and round-end states
- [ ] close-register, freezer-check, and other existing task hooks still work after art replacement
- [ ] no runtime-critical node moved or renamed without corresponding engineering coordination

## Acceptance criteria
- The five priority zones no longer read as obvious primitive graybox from normal player camera positions.
- The store, signage, UI, and event states follow one consistent visual language.
- Blackout, mimic, and round-end are distinguishable instantly in runtime proof.
- Existing gameplay interactions remain stable.
- Engineering hands QA a build or proof path with the above checklist unblocked.

## Engineer implementation status — 2026-04-05 retry
- Shared lighting presets now exist in `project/src/ReplicatedStorage/Shared/LightingPresets.lua` for `normal`, `blackout`, `mimic`, `round_success`, and `round_failure`.
- Client lighting state application now lives in `project/src/StarterPlayer/StarterPlayerScripts/LightingController.client.lua` and responds to the existing round / alert event path without adding new remotes.
- `project/src/StarterPlayer/StarterPlayerScripts/HUD.client.lua` now has local fallback aliases for round-state, payout, and task-id constants so the Sprint 6 HUD skin remains runtime-safe even when broader shared-runtime constants drift.
- `project/src/Workspace/FallbackArena.server.lua` now exposes source-backed Sprint 6 art-swap / capture hooks under `FallbackArtSlice/Sprint6ArtHooks`, plus zone attributes for lobby, checkout, hero aisle, freezer, and stockroom replacements.
- Proof support now includes `project/scripts/sprint6_visual_probe.lua` and stronger smoke coverage for the Sprint 6 visual runtime files.

## Confirmed runtime-source risks
- **Confirmed:** `project/src/ReplicatedStorage/Shared/Constants.lua` still does not match the richer shape expected by several dormant or partially-landed runtime consumers (`TaskRegistry`, `TaskService`, `RoundResultsService`, shop/meta UI code). This retry only hardened the Sprint 6 HUD path locally; it did **not** reconcile the whole gameplay/runtime constants contract.
- **Confirmed:** the active bootstrap path still points at the simpler `Round/ShiftService.start()` server loop, while other round/task modules in source expect a more advanced round/task/event orchestration contract. That drift pre-dates this visual retry.
- **Unconfirmed from this host:** full live task / close-register / 1-player / 2-player interaction proof for the current mixed runtime still needs human or Studio-backed validation beyond structural smoke/probe coverage.
