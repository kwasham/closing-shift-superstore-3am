# Engineer worker — Sprint 3 alpha return loop implementation

## Your role
You are implementing Sprint 3 for **Closing Shift: Superstore 3AM**.

Build the smallest believable alpha return loop without regressing Sprint 1 or Sprint 2.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/KPI-CANDIDATES-S3.md`
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project-template/docs/SPRINT3-PLAN.md`

## File ownership
You own:
- `project/src/**`
- `project/scripts/**`
- code comments or local engineering notes needed to explain implementation

Do not edit content-owned or QA-owned docs except where command output or engineering evidence must be appended by process.

## Implementation target
### Build these systems
1. `Security Alarm` event
2. persistent XP / Level profile extension
3. shop purchase/equip flow
4. cosmetic representation for the 2 defined slots
5. analytics/log instrumentation for the locked Sprint 3 events
6. any HUD/results/shop updates required to make the above understandable

### Preserve these systems
- 15s intermission
- 9-minute round
- current blackout behavior
- current mimic behavior
- `Close Register` gating
- current payout rules unless design explicitly changed them
- phone-safe HUD behavior from Sprint 2

## Engineering expectations
### Data safety
- handle saved-profile versioning safely
- preserve existing `Cash`
- define sensible defaults for new fields
- avoid data wipes from schema expansion

### Shop behavior
- server-authoritative purchases and equips
- deny invalid purchases cleanly
- do not trust the client for price, level, or ownership
- make equip persistence real

### Runtime clarity
- shop states must be externally visible enough for QA
- results UI must show cash + XP + level coherently
- late join must remain stable even if shop/progression data exists

### Instrumentation
- centralize event names/constants if practical
- emit structured local log/debug evidence
- if you wire official analytics calls, keep them wrapped so local verification is still possible when dashboards lag

## Required command pass
Run and report exact results for:
- `bash scripts/check.sh`
- `bash scripts/build.sh`
- the best available smoke/runtime path on the host
- any additional targeted validation you use for persistence/shop/event proof

## Required runtime evidence
Capture or explicitly note status for:
- solo `Security Alarm` success and failure
- 2-player `Security Alarm` behavior
- XP earn + level-up path
- purchase success path
- insufficient funds denial
- insufficient level denial
- equip persistence after rejoin
- no regression on blackout/mimic/late join/results

## Output format
Return:
1. concise summary
2. exact files changed
3. commands run with exact outputs
4. runtime evidence captured
5. instrumentation/log evidence captured
6. known gaps or blockers
7. whether QA is unblocked

## Guardrails
- do not sneak in Sprint 4 features
- do not add Robux monetization
- do not add a second event beyond `Security Alarm`
- do not change core round timings unless required by a bug fix and clearly documented
