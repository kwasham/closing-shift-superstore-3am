# Art direction

## Visual tone
- Familiar suburban supermarket
- fluorescent lighting
- uneasy emptiness
- retail realism with subtle paranormal wrongness

## Asset constraints
- MVP should use simple, readable assets
- strong silhouettes and lighting contrast matter more than detail density
- avoid requiring a large custom animation pipeline early

## UI tone
- short verbs
- mobile readable
- practical with a slightly eerie edge

## Sprint 3 — alpha return loop presentation rules

### Security Alarm readability rules
- `Security Alarm` is a **front-of-store panic beat**, not a full-screen chaos layer.
- The alarm should pull attention to one readable destination: `security_panel_node` / `Security Panel`.
- Treat alarm presentation as the only Sprint 3 state that owns **red urgency**:
  - red pulse / red highlight is allowed here
  - brief siren-like audio sting is allowed here
  - do not reuse the same red flash language for blackout or mimic
- Keep the event distinct from other hazards:
  - **blackout** = loss of light / dimness / visibility pressure
  - **mimic** = local wrongness / suspicious interactable / uncanny beat
  - **security alarm** = loud, clear, front-of-store emergency reset
- The alarm should feel urgent but fair:
  - one alert line
  - one world target
  - one clear action
  - one clear outcome
- Do not stack extra warning banners, lore text, or tutorial paragraphs on top of the alarm.
- If a world indicator is used, it should reinforce the front-panel location rather than add another destination.

### Shop and results readability rules
Mandatory information should always beat flavor.

#### Shop card hierarchy
Each shop item should clearly show, in this order:
1. display name
2. price or level gate state
3. slot identity (`NameplateStyle` or `LanyardColor`) only if needed for clarity
4. readable preview
5. short flavor line

#### Results hierarchy
Results should prioritize:
1. round outcome
2. `Cash earned`
3. `XP earned`
4. `Employee Rank`
5. local equipped cosmetic preview
6. optional CTA into shop

#### Decorative versus mandatory
Mandatory:
- `Cash`
- `Level` / `Employee Rank`
- XP progress or XP total relevant to next level
- item state (`Buy`, `Requires Level`, `Owned — Equip`, `Equipped`)
- local cosmetic preview that QA can verify

Decorative only:
- flavor lines
- subtle striping / trim
- tiny icons
- soft background texture

If space is tight, decorative elements should disappear before mandatory information does.

### Reward-surface discipline
- Sprint 3 reward surfaces must explain the return loop in one glance: earn `Cash`, earn `XP`, unlock cosmetics, buy/equip cosmetics.
- Do not present Sprint 3 like a full battle pass, inventory wall, or seasonal reward track.
- Show only the currencies and progression that already exist in the locked contract:
  - `Cash`
  - `XP`
  - `Level` / `Employee Rank`
- Use one primary action at a time on reward surfaces.
  - Example: after results, the primary next step may be `Open Shop`.
  - Do not compete with multiple equal-weight buttons.
- Cosmetics should be shown through simple 2D UI treatment:
  - `NameplateStyle` = frame/border/plate treatment
  - `LanyardColor` = strap/swatch treatment
- Results should show the **local player's** equipped cosmetics clearly enough that QA can confirm persistence without needing 3D accessories.
- Do not overload results with extra reward callouts, fake rarity bursts, or unrelated unlock messaging.
- If no unlock threshold changed, do not invent a larger celebration state.

### Phone readability constraints
Sprint 3 shop/results/readout surfaces must remain readable on phone-sized screens.

#### Layout target
- Use the proven phone-safe baseline from runtime evidence as the minimum readability target:
  - panel width target: `260px`
  - inner text width target: `236px`
- Critical copy must survive that width without clipping.
- Auto-growing vertical layouts are preferred over fixed-height text containers.

#### Copy budget
- Alert lines: target one line; allow wrap only if the layout grows cleanly.
- Button/state labels: keep to one short line.
- Flavor lines: maximum two lines.
- Helper/explainer text: maximum two short lines on a given surface.
- Do not place multiple helper paragraphs on the same shop or results screen.

#### Composition rules
- Keep one dominant header per surface.
- Avoid stacking more than two banners/notices at once.
- Do not place shop clutter on top of results clutter; if both exist in sequence, results should resolve first, then hand off to shop.
- Preserve strong contrast between text and background; fluorescent-store atmosphere should never reduce UI legibility.
- Any preview treatment must read with flat color, simple borders, and text labels alone; finished custom art is a bonus, not a requirement.

### Sprint 3 item visual guidance
- `NameplateStyle` variants should differ through border shape, trim, laminate wear, and color blocking that reads in a small card.
- `LanyardColor` variants should differ through strong strap color and clip/swatch treatment that remains visible in a compact preview.
- Every cosmetic should be identifiable in the lobby preview and the post-round local results card at a glance.
- If an item cannot be distinguished in a simple 2D mockup, it is too subtle for Sprint 3.
