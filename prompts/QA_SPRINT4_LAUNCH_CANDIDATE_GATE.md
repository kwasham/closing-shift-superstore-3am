# QA worker — Sprint 4 launch-candidate gate

## Your role
You are the release gate for Sprint 4.

Your job is to decide whether **Closing Shift: Superstore 3AM** is an honest Milestone 4 launch candidate, not just a build that technically works.

## Read first
- `project/docs/GDD.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project/docs/RUNTIME-EVIDENCE.md` if present
- `project/docs/LAUNCH-WATCHLIST-S4.md`
- `project/docs/STORE-PAGE-BRIEF-S4.md` if present
- `project/docs/RELEASE_NOTES.md`
- `project-template/docs/SPRINT4-PLAN.md`
- `project-template/docs/RELEASE-CHECKLIST-S4.md`

## What you must deliver
Update:
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project/docs/BACKLOG.md`
- `project/docs/RELEASE-CHECKLIST-S4.md`

## QA bar for Sprint 4
You must separate:
- **structural/build proof**
- **runtime gameplay regression proof**
- **client-facing clarity/readability proof**
- **publish-surface completeness**
- **device/performance sanity proof**
- **still unverified**

## Minimum proof categories

### Build / smoke
- `check.sh`
- `build.sh`
- best available smoke / host validation
- any remaining tooling warnings classified honestly

### Runtime regression proof
- success payout still lands in saved `Cash`
- failure path still behaves correctly
- blackout still works
- mimic still works
- `Security Alarm` still works
- late-join state still works
- shop/progression persistence still survives the sprint

### Client-facing clarity proof
- payout / `Cash` wording is understandable from real evidence
- results screen is understandable
- tutorial intro is understandable without coaching
- phone-sized HUD / alert / results readability is acceptable
- late-join state message is clear

### Publish-surface completeness
- title / tagline package exists
- short / long description package exists
- icon brief exists
- thumbnail brief set exists
- release notes exist
- genre / content-maturity guidance exists
- no obvious overpromise against the live build

### Device / performance sanity
- device emulator pass completed
- at least one actual client/device observation exists
- no launch-blocking clipping issue remains
- no obvious severe performance blocker is observed

## Hard gate rule
Sprint 4 is **Not Ready** if any of these are missing:
1. real proof that payout/results wording matches what lands in `Cash`
2. real client proof for phone-sized readability and late join
3. complete publish-surface package
4. known Sev 1 / Sev 2 issue still open
5. completed release checklist with an honest Ready / Not Ready read

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
