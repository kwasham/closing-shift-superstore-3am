# Sprint 7 Shot Log — Full-Store Art Rollout + Store Presence

## Capture rule
Every shot below must come from the real build or exact release candidate. No paint-over, impossible lighting, or non-playable one-off staging.

## Environment rollout proof
| Proof item | Zone | Preferred anchor / setup | What must read | Status |
| --- | --- | --- | --- | --- |
| Before / After A1 | Lobby / entrance | `LobbyCaptureAnchor` + `EntranceWideCaptureAnchor` | `SUPERSTORE`, threshold into front store, exit clarity | Pending live capture |
| Before / After A2 | Main aisle coverage | `HeroAisleCaptureAnchor` + `ContinuityCaptureAnchor` | repeated aisle markers, category headers, clean route width | Pending live capture |
| Before / After A3 | Checkout / queue | `CheckoutCaptureAnchor` | lane numbers, `CASH OUT`, queue rails, prompt-safe approach | Pending live capture |
| Before / After A4 | Freezer / cooler path | `FreezerCaptureAnchor` | colder threshold, cooler doors, `FREEZER`/`FROZEN` read | Pending live capture |
| Before / After A5 | Stockroom corner | `StockroomCaptureAnchor` | `EMPLOYEES ONLY`, `STOCKROOM`, notice-board / operations read | Pending live capture |
| Continuity C1 | Lobby -> main floor | `EntranceWideCaptureAnchor` | one consistent product read, no raw seam | Pending live capture |
| Continuity C2 | Main floor -> freezer | `ContinuityCaptureAnchor` then freezer frame | colder variant of same store, route still clear | Pending live capture |
| Continuity C3 | Main floor -> stockroom | `ContinuityCaptureAnchor` then stockroom frame | staff-only shift without style reset | Pending live capture |

## Store-presence pack
| Asset | Preferred anchor / setup | What must read | Status |
| --- | --- | --- | --- |
| Icon candidate | `StorePageIconAnchor` | checkout/front-store identity first, threat second | Pending live capture |
| Thumbnail A — Store at 3AM | `EntranceWideCaptureAnchor` | recognizable supermarket, signage visible, honest geometry | Pending live capture |
| Thumbnail B — Blackout | `BlackoutCheckoutCaptureAnchor` | same store under blackout with route readability intact | Pending live capture |
| Thumbnail C — Mimic tension | `MimicAisleCaptureAnchor` | uncanny task-zone wrongness, still clearly this game | Pending live capture |
| Update / social shot 1 | `UpdateCompareAnchor` | before / after comparison | Pending live capture |
| Update / social shot 2 | `ContinuityCaptureAnchor` | full-store continuity proof | Pending live capture |

## Mobile-safe crop review
| Asset | Crop check | Notes | Status |
| --- | --- | --- | --- |
| Icon | square small-size read | checkout silhouette and brand must survive | Pending |
| Thumbnail A | 16:9 + tighter center crop | aisle markers should not get cropped out | Pending |
| Thumbnail B | 16:9 + darker crop review | blackout must stay legible, not muddy | Pending |
| Thumbnail C | 16:9 + center-right crop | mimic subject cannot become unreadable noise | Pending |

## Captured Sprint 7 proof set

### Tier A before / after pairs
- Lobby / entrance
  - before: `before_lobby.png`
  - after: `after_lobby.png`
- Main aisle coverage
  - before: `before_main_aisle.png`
  - after: `after_main_aisle.png`
- Checkout / queue
  - before: `before_checkout.png`
  - after: `after_checkout.png`
- Freezer / cooler path
  - before: `before_freezer.png`
  - after: `after_freezer.png`
- Stockroom corner
  - before: `before_stockroom.png`
  - after: `after_stockroom.png`

### Continuity
- `continuity_front.png`
  - current continuity export is the widened front-floor sweep used to show lobby / checkout / aisle adjacency in one read.

### Distinct public asset set from the live build
- Icon candidate
  - `icon_candidate.png`
- `Store at 3AM` thumbnail
  - semantic export: `thumbnail_store_at_3am.png`
  - compatibility export: `thumbnail_candidate_01.png`
- `Blackout` thumbnail
  - semantic export: `thumbnail_blackout.png`
  - compatibility export: `thumbnail_candidate_02.png`
- `Mimic tension` thumbnail
  - semantic export: `thumbnail_mimic_tension.png`
  - compatibility export: `thumbnail_candidate_03.png`
- Update / social shots
  - `update_shot_01.png`
  - `social_shot_01.png`

### Crop review
- `crop_review_icon.png`
- `crop_review_thumb_store_at_3am.png`
- `crop_review_thumb_blackout.png`
- `crop_review_thumb_mimic_tension.png`
- `crop_review_update_shot.png`
- compatibility copies:
  - `crop_review_thumb_01.png`
  - `crop_review_thumb_02.png`
  - `crop_review_thumb_03.png`
- sheet:
  - `crop_review_sheet.png`

### Live readability captures
- Active shift HUD / prompt readability
  - `live_active_shift.png`
- Blackout readability
  - `live_blackout.png`
- Mimic readability
  - `live_mimic.png`
- Additional widened-store normal-shift live zone frame
  - `live_normal_checkout.png`
- Widened-store round-end summary readability
  - `live_round_end_summary.png`
- Phone-sized widened-store active-shift readability
  - `live_active_phone.png`

## Command-backed note
This shot log began as source/capture-hook prep in the content pass. The file references above are the actual exported Sprint 7 proof captures now present under `project/docs/proof/sprint7/`.
