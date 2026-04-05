# Sprint 6 Plan — Visual Identity + Environment Art Foundation

## Sprint status
- Planned
- Baseline assumption: Sprint 5 is Ready and tagged
- This sprint must preserve the Sprint 5 playable baseline

## Sprint goal
Replace the most visible graybox / primitive look in the player-facing critical path with a reusable visual foundation that makes the game feel intentional, branded, and worth replaying.

## Product thesis
Gameplay is now proven enough that presentation has become a product risk.
Sprint 6 should not try to beautify the entire game at once.
It should create one polished visual vertical slice and the reusable rules needed to scale that quality to the rest of the experience later.

## Visual pillars
1. **Retail first, horror second**
   - The store must read as a believable supermarket before it becomes uncanny.
2. **Readable on phones**
   - Visual detail cannot bury objectives, prompts, or alerts.
3. **Modular, not bespoke**
   - Prefer a reusable shelf / counter / cooler / signage kit over one-off hero pieces.
4. **Normal but wrong**
   - The horror tone should come from lighting, absence, asymmetry, and wrongness, not gore.
5. **Cheap to render**
   - Lighting, decals, and restrained effects should carry more weight than heavy particles or dense unique meshes.

## In scope
1. **Art Direction Lock**
   - final style statement
   - palette tokens
   - material rules
   - signage language
   - prop-density rules
   - UI skin direction
   - event visual language for blackout and mimic

2. **Reusable Environment Kit Foundation**
   - shelf variants
   - checkout counter kit
   - freezer / cooler kit
   - wall / floor / ceiling treatment
   - carts, baskets, pallets, boxes, caution props, signage
   - decal / label pack

3. **Visual Vertical Slice**
   - lobby / entrance
   - one hero aisle
   - checkout zone
   - freezer section
   - stockroom corner
   - nearby connecting spaces needed so these zones do not feel cut off

4. **Lighting + Atmosphere States**
   - normal shift look
   - blackout look
   - mimic cue look
   - round-end success / failure emphasis where appropriate

5. **HUD / UI Skin Refresh**
   - preserve current layout hierarchy
   - reskin panels, typography, iconography, alerts, and round-end summary
   - keep phone-safe readability as a hard requirement

6. **Interaction Feedback Polish**
   - task complete feedback
   - close-register unlock cue
   - blackout recovery cue
   - mimic node cue
   - round-end summary treatment

7. **Store Visual Identity Pack**
   - icon / thumbnail direction
   - hero capture shot list
   - visual notes for release surfaces

## Out of scope
- new map
- new round event or enemy type
- revive or teamwork system expansion
- economy rebalance
- new progression track
- subscriptions, dev products, or monetization overhaul
- full-store bespoke prop pass
- photorealistic rendering target
- heavy VFX spam or cinematic-only lighting setups that damage gameplay readability

## Acceptance criteria
- The critical path zones no longer read as obvious graybox from normal player camera positions
- The visual slice follows one consistent art language across architecture, props, signage, lighting, and UI
- Blackout, mimic, and round-end are visually distinguishable at a glance in runtime proof
- Task prompts, objective state, and alerts remain readable on phone-sized UI
- Existing gameplay interaction points remain stable after the art pass
- Build, smoke, and basic 1-player / 2-player runtime regression remain green
- QA has before / after captures for the slice zones and live evidence for the key state changes

## Risk notes
- If custom imported assets slow the sprint, ship a strong Studio-material + decal + modular-part pass first
- Prefer replacing the player's eye-level experience over polishing unreachable corners
- Do not move or rename runtime-critical nodes without explicit engineering coordination
- Limit particle usage and flashing patterns to what supports readability and comfort

## Deliverables
- updated art direction docs
- reusable kit and asset list
- implemented vertical slice
- UI skin pass
- lighting state pass
- QA evidence with before / after captures
- backlog notes for follow-on full-map polish
