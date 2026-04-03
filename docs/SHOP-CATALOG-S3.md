# SHOP CATALOG — SPRINT 3

## Locked scope
This file locks the Sprint 3 paid starter catalog for the alpha return loop.

Sprint 3 shop scope remains exactly:
- 2 slots: `NameplateStyle`, `LanyardColor`
- 6 paid items total
- non-playing shop use only
- 2D-readable QA verification in lobby/results surfaces

Default always-owned reference items:
- `nameplate_standard_issue`
- `lanyard_gray_clip`

## Starter catalog
| itemId | Display name | Slot | Price (`Cash`) | Required level | Flavor line | Readable visual intent | QA-visible representation note |
|---|---|---|---:|---:|---|---|---|
| `clean_shift` | Clean Shift | `NameplateStyle` | 40 | 1 | Fresh laminated badge for a dependable closer. | Crisp white-and-slate badge face with a tidy laminate border; the cleanest, most standard-upgraded look in the set. | Lobby/results preview should show a noticeably cleaner plate frame than `nameplate_standard_issue`, with sharp edges and no wear marks needed to read the upgrade. |
| `retro_plastic` | Retro Plastic | `NameplateStyle` | 80 | 3 | Old store plastic with worn late-night charm. | Creamy off-white plastic plate with slightly aged trim and warmer color blocking so it reads older from a small card. | Lobby/results preview should visibly differ from `Clean Shift` through warmer aged tones and a more worn-looking border treatment, even if rendered as simple 2D frame art. |
| `neon_night` | Neon Night | `NameplateStyle` | 120 | 5 | Electric edge trim that reads from across the lobby. | Dark badge base with bright neon edge trim so the frame pops instantly in a compact UI preview. | Lobby/results preview must show the strongest contrast in the nameplate slot; the border should remain obviously brighter than the other two styles without requiring animated glow. |
| `blue_id` | Blue ID | `LanyardColor` | 50 | 1 | Calm blue strap for routine night shifts. | Solid cool-blue strap/swatch treatment with a simple clip accent that reads cleanly beside the default gray. | Lobby/results preview should show a clearly blue strap or swatch area; QA must be able to tell it from gray at a glance without zooming. |
| `red_id` | Red ID | `LanyardColor` | 75 | 2 | Loud red strap that stands out fast. | Strong red strap/swatch treatment designed to be the fastest-read lanyard color in the set. | Lobby/results preview should immediately read as red even on a dark background; it should be visibly louder than `Blue ID` and the gray default. |
| `gold_id` | Gold ID | `LanyardColor` | 100 | 4 | Gold trim for proven overnight staff. | Warm gold/yellow strap treatment with a slightly more premium clip/swatch feel while staying flat and readable. | Lobby/results preview should read as gold/yellow, not beige; QA should be able to separate it from red and blue through hue alone in a simple 2D swatch. |

## Catalog presentation notes
- Keep display names and flavor lines exactly as listed above.
- The preview language must stay readable in a small mobile card before any high-fidelity art exists.
- `NameplateStyle` differences should come from plate frame/border treatment first.
- `LanyardColor` differences should come from strap color first.
- Every paid item must remain distinguishable against the default reference item in both the lobby preview and the local post-round results card.

## QA lock notes
QA should be able to verify each item without imagination by checking:
1. correct display name
2. correct price
3. correct required level
4. correct slot
5. visible 2D difference from the default item in that slot
6. persistence of the equipped representation after rejoin
