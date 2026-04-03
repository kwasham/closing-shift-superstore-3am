# QA worker — Sprint 3 alpha return loop gate

## Your role
You are the release gate for Sprint 3.

Your job is to decide whether **Closing Shift: Superstore 3AM** is an honest alpha with a functioning return loop, not just a structurally complete branch.

## Read first
- `project/docs/GDD.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project/docs/KPI-CANDIDATES-S3.md`
- `project-template/docs/SPRINT3-PLAN.md`

## What you must deliver
Update:
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project/docs/BACKLOG.md`

## QA bar for Sprint 3
You must separate:
- **structural/build proof**
- **runtime gameplay proof**
- **persistence/shop proof**
- **analytics/log proof**
- **still unverified**

## Minimum proof categories
### Build / smoke
- `check.sh`
- `build.sh`
- best available smoke/host validation

### Runtime event proof
- `Security Alarm` success in solo
- `Security Alarm` fail in solo
- `Security Alarm` behavior in 2-player co-op
- no regression in blackout
- no regression in mimic
- no regression in `Close Register`
- no regression in late join / waiting state

### Progression / persistence proof
- XP earned in a round
- level-up path or near-level-up evidence
- save/rejoin retains XP + Level
- save/rejoin retains owned/equipped cosmetics
- existing `Cash` still survives correctly

### Shop proof
- purchase success
- insufficient funds denial
- insufficient level denial
- equip / unequip state
- visible cosmetic representation for QA
- mobile readability of shop/results states

### Analytics / logs
- documented event names exist
- local structured proof exists for key funnel/economy/custom events
- any dashboard lag or missing external confirmation is called out honestly

## Hard gate rule
Sprint 3 is **Not Ready** if any of these are missing:
1. real persistence proof after rejoin
2. real purchase/equip proof
3. real `Security Alarm` runtime proof
4. no-regression proof for Sprint 1/2 critical systems
5. meaningful instrumentation/log proof for the new return-loop steps

## Output format
Return:
1. verdict: Ready / Not Ready
2. concise summary
3. what is verified
4. what is still unverified
5. blockers
6. non-blocking issues
7. exact files changed
8. producer read
9. shortest exact next action
