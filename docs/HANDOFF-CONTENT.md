# Content handoff — Sprint 3 alpha return loop

Use this file when engineering or production needs the exact player-facing copy and presentation notes for Sprint 3's event/shop/reward layer.

## Objective
Deliver the content package for Sprint 3's locked alpha return loop only:
- `Security Alarm` presentation
- progression / rewards copy
- shop state copy
- phone-safe presentation discipline for shop/results surfaces

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/SPRINT3-PLAN.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/SHOP-CATALOG-S3.md`

## Files changed
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/SHOP-CATALOG-S3.md`

## Security Alarm — exact copy package

### Exact ids and strings
| Surface | Exact copy / id |
|---|---|
| Start alert id | `security_alarm_active` |
| Start alert text | `Security Alarm. Reset the front panel.` |
| Start cue id | `security_alarm_start` |
| Panel object text | `Security Panel` |
| Panel action text while active | `Reset Alarm` |
| Success alert id | `security_alarm_reset` |
| Success alert text | `Alarm reset. Keep closing.` |
| Success cue id | `security_alarm_reset` |
| Fail alert id | `security_alarm_failed` |
| Fail alert text | `Alarm missed. Lost 12 seconds.` |
| Fail cue id | `security_alarm_fail` |

### Presentation notes
- Alarm presentation should read as a **single urgent job** at the front of the store.
- Favor a red urgency treatment, short siren sting, and a clear panel highlight.
- Keep the distinction readable:
  - blackout = darkness pressure
  - mimic = suspicious/localized wrongness
  - security alarm = loud front-panel emergency
- No extra tutorial paragraph should ride on top of the active alarm alert.

## Progression and rewards — exact copy

### Plain-language rule
Use this exact sentence anywhere the system needs a one-line explanation:
- `Cash buys cosmetics. XP raises Employee Rank. Rank unlocks cosmetics only.`

### Results / header labels
| Surface | Exact copy |
|---|---|
| Header rank label | `Employee Rank` |
| Results cash label | `Cash earned` |
| Results XP label | `XP earned` |
| Results level label | `Employee Rank` |
| XP progress label | `XP to next level` |
| Shop CTA | `Open Shop` |

### One-line return-loop copy
Use this when a short motivation line is needed on lobby/results/shop surfaces:
- `Finish shifts. Raise Employee Rank. Buy a better night-shift look.`

## Shop states and denials — exact copy

### Primary action / state copy
| State | Exact copy |
|---|---|
| Buy button | `Buy for $<price>` |
| Locked by level | `Requires Level <level>` |
| Owned passive label | `Owned` |
| Owned primary action | `Owned — Equip` |
| Equipped | `Equipped` |

### Purchase denial copy
| Denial case | Exact copy |
|---|---|
| Insufficient level | `Employee Rank too low. Reach Level <level>.` |
| Insufficient funds | `Not enough Cash. Finish another shift.` |

### Label usage notes
- If a passive badge is needed on owned items, use `Owned`.
- If the owned item is actionable, the primary action remains `Owned — Equip`.
- For locked items, use `Requires Level <level>` as the visible gate label rather than longer explanatory copy on the card.
- `Equipped` should read as a final state, not a clickable purchase action.

## Presentation discipline notes for engineering / UI
- Prioritize the locked copy above over alternate phrasings so QA can verify exact text.
- On shop cards, state/action text must stay visible even if the flavor line wraps.
- Results should show `Cash earned`, `XP earned`, and `Employee Rank` before any cosmetic flavor or CTA.
- Cosmetic verification should remain 2D-first and readable without custom accessory art.

## Acceptance criteria
- `Security Alarm` uses the exact ids/text above.
- Shop state labels and denial copy match the locked strings above.
- The cash/XP explanation stays consistent with the design contract.
- Results/shop surfaces remain phone-readable and do not bury mandatory state text under flavor or decoration.
