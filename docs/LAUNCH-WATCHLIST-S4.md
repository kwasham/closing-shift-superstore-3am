# Launch Watchlist — Sprint 4

## Purpose
This is the minimum Milestone 4 watchlist.
It exists to answer one question quickly and honestly:

**If fresh players enter this build, do they understand the shift and does the launch package describe the real game truthfully?**

This is **not** a dashboard wishlist. Broader analytics views are follow-up work if the required proof already exists.

## First-session funnel questions
1. Does a fresh player start a real task in the first shift without asking where to go?
2. After the first completed task, does that player understand that tasks build **`Shift Cash`** during the run?
3. When the round ends, can that player tell what got added to **`Saved Cash`** without somebody explaining it?
4. Does the player understand that `Cash` buys cosmetics only and does not unlock gameplay power?
5. If a player joins mid-round, do they understand they are waiting for the next shift instead of assuming the game is bugged?
6. Do the title, icon, thumbnails, and descriptions set expectations that match the actual one-store, short-session build?

## Economy / progression clarity checks
- `Shift Cash` goes up when tasks are completed.
- The clear / timeout projection reads as a future outcome, not the current saved balance.
- The round-end `Saved Cash added` line matches the actual persistent-balance change.
- Shop spend still uses persistent `Cash` only.
- XP / level language does not imply gameplay power or hidden pay multipliers.
- No player-facing launch surface still uses unexplained `Banked` wording.

## Must-have proof before Milestone 4 can be called ready

### 1) Structural / build proof
- `bash scripts/check.sh` passed
- `bash scripts/build.sh` passed
- structural smoke passed
- any remaining non-blocking tooling warning documented truthfully

### 2) Runtime regression proof
- 1-player success path verified
- 1-player failure path verified
- payout lands in persistent `Cash`
- blackout still behaves correctly
- false task / mimic still behaves correctly
- security alarm still behaves correctly
- late join remains excluded correctly
- persistence / shop spend-equip sanity verified

### 3) Live client readability proof
Need actual client-visible proof for:
- tutorial / first-playable HUD readability
- active HUD readability with `Shift Cash` vs `Saved Cash`
- late-join wait-state readability
- results-screen readability

Headless probes and layout math may support this category, but they do **not** replace it.

### 4) Publish-surface completeness
- title and tagline locked
- short-description direction locked
- long-description direction locked
- icon brief complete
- three thumbnail beats complete
- release-note bullets complete
- genre / mood positioning documented
- content-maturity guidance documented

### 5) Release discipline
- release checklist completed
- rollback reference known
- known issues documented
- no blocking mismatch remains between docs, store-page direction, and the actual build

## No-go triggers
Do **not** call Milestone 4 ready if any of these appear:
- a fresh-player note still asks what `Banked` means or where the payout went after the Sprint 4 wording pass
- the `Saved Cash added` result does not match the actual saved-balance change and the discrepancy is unexplained
- a phone-sized client view still clips or hides tutorial, payout, late-join, or results text
- a late joiner can reasonably mistake the wait state for active participation
- the publish surface promises extra maps, roaming enemies, combat, live events, badges, or monetization scope that are not in the build
- any known Sev 1 / Sev 2 gameplay, save, payout, or progression issue remains open

## Release-day operator spot checks
- verify the live build still uses the locked `Shift Cash` / `Saved Cash` wording
- verify one real results flow from task completion through saved-balance landing
- verify one late-join client view on the actual build
- verify one phone-width HUD / results capture on the actual build
- verify store-page assets and release notes do not overpromise the current feature set
- verify non-blocking issues are written down before ship/no-ship is called

## Non-blocking follow-up
These are useful after Milestone 4, but they are not blockers for the launch-candidate decision if the proof above exists:
- broader analytics dashboards
- more detailed funnel instrumentation
- richer post-launch KPI cuts

## Suggested proof sources
- `project/docs/RUNTIME-EVIDENCE.md`
- `project/docs/QA.md`
- `project/docs/RELEASE-CHECKLIST-S4.md`
- local structured logs
- captured screenshots / clips from actual client runs
- human session notes from fresh-player observation
