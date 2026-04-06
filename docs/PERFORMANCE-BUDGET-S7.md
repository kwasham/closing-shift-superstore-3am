# Sprint 7 Performance Budget and Guardrails

## Purpose
Prevent the full-store art rollout from quietly undoing the stable Sprint 6 baseline.

## Testing stance
- Device Emulator is useful for layout / aspect-ratio checks
- live client / Studio runtime proof is still required for final comfort and readability judgment
- any visual upgrade that creates a recurring interaction hitch, blocked prompt, or major readability loss fails the sprint goal

## Budget principles
1. **Reuse before bespoke**
   - reuse the Sprint 6 modular kit wherever possible
2. **Materials beat geometry**
   - prefer material, tint, decal, and silhouette changes before adding dense unique meshes
3. **Lighting discipline**
   - use a strong base lighting setup with selective accents
   - blackout and mimic states should mostly transform existing lighting, not stack endless extra lights
4. **Readable clutter only**
   - props should add story and scale, not noise
5. **Clean out dead graybox**
   - remove or hide obsolete placeholder parts once replacements are in place

## Internal working guardrails
### Lights
- keep always-on accent lights sparse in any one player view
- event-only emphasis lights should be localized and short-lived
- avoid layered light spam in the same aisle or fixture bank

### Materials / textures
- prefer shared materials and recolors over many near-duplicate texture sets
- use tinting and material variation strategically rather than authoring many duplicate assets
- document any imported texture or mesh dependency clearly

### Props
- dense props belong at focal points, not across every shelf bay
- keep floor clutter low enough that players can still instantly read routes and prompts
- never let prop dressing create false interaction targets near real task nodes

### Decals / signage
- signage should be readable first, decorative second
- keep text / icon systems consistent across the store
- do not overuse attention colors that compete with gameplay alerts

## Fallback rules
If a zone looks better but starts hurting play clarity, cut in this order:
1. micro-props
2. extra decals
3. non-essential accent lights
4. optional effect layers
Do not cut:
- wayfinding signs
- prompt readability
- core event readability
- safe traversal space

## QA proof requirements
- build and smoke stay green
- phone-size HUD / prompt readability remains green
- 1-player and 2-player sanity remain green
- blackout and mimic still read clearly after rollout
- any performance exception is documented with the exact zone and mitigation plan
