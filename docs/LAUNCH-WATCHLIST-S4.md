# Launch Watchlist — Sprint 4

## Purpose
This is the minimum watchlist for Milestone 4. It is not a giant dashboard wishlist.
It exists to answer one question:

**If we put this build in front of fresh players, what will tell us quickly whether the launch candidate is healthy?**

## First 72-hour questions
1. Are players getting through the first 10 minutes without confusion?
2. Are players understanding payout, saved `Cash`, XP, and results flow?
3. Are players hitting major runtime blockers on mobile-sized layouts?
4. Are the new Sprint 3 systems still behaving after the Sprint 4 hardening pass?
5. Are the publish surfaces setting accurate expectations?

## Must-watch evidence
### First-session funnel
- session started
- onboarding shown
- onboarding completed
- first task completed
- first shift success / failure
- results viewed
- second shift started in the same session, if available

### Economy / progression clarity
- payout credited to saved `Cash`
- shop opened after a round
- purchase succeeded
- equip succeeded
- XP earned
- level-up occurred or near-level-up proof
- no unexplained discrepancy between round result language and saved values

### Runtime stability
- no save-data corruption
- no payout loss
- no broken late-join state
- no broken blackout / mimic / security alarm regression
- no obvious UI clipping blocker on phone-sized play

### Device / client sanity
- phone-sized HUD readability in live play
- results screen readability in live play
- shop readability in live play
- at least one actual client/device observation in addition to emulator checks

## No-go triggers
Do **not** call Milestone 4 ready if any of the following appear:
- payout text suggests one value but `Cash` lands differently and the discrepancy is unexplained
- save data is lost, reset, or incorrectly migrated
- late-join clients initialize into a broken or misleading state
- phone-sized UI blocks core play or understanding
- known Sev 1 / Sev 2 issue remains open
- publish-surface copy materially overpromises the experience

## Release-day operator checks
Before a release candidate is called ready:
- structural checks green
- live runtime proof captured
- release checklist completed
- rollback tag known
- known issues documented
- launch-facing copy approved
- publish surface package complete

## Suggested proof sources
- `project/docs/RUNTIME-EVIDENCE.md`
- `project/docs/QA.md`
- `project/docs/RELEASE-CHECKLIST-S4.md`
- local structured logs
- captured screenshots / clips from actual client runs

## Notes
If external analytics lag, local evidence still counts for the go / no-go call.
The watchlist is meant to keep the team honest, not to block progress on missing dashboard screenshots.
