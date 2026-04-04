# Sprint 4 Plan — Launch Candidate Hardening

## Recommended sprint name
**Sprint 4 — Launch Candidate Hardening**

## Why this sprint now
Sprint 1 proved the core shift. Sprint 2 proved that a first-time player can understand the slice. Sprint 3 proved the return loop with progression, shop, and a third event.

The highest-value move now is not more feature surface. It is turning the current build into an honest launch candidate:
- remove the last copy / terminology confusion
- harden the release baseline
- prepare the publish surface
- package the release notes and launch watchlist
- make the go / no-go decision from real client evidence

This sprint should produce the smallest believable Milestone 4 release candidate for a soft launch or limited external test.

## Sprint goal
Ship a launch candidate where:
- payout and saved-currency language is understandable without coaching
- the first 10 minutes are readable on phone-sized screens
- the publish surface is ready with icon / thumbnail / description guidance
- the release checklist is complete enough for a real go / no-go call
- no critical regressions exist in the ready Sprint 1–3 baseline

## Locked scope

### 1) Launch-facing clarity cleanup
Resolve the remaining wording and readability friction around:
- `Banked` / projected round payout / saved `Cash`
- results screen copy
- tutorial intro copy
- late-join waiting-state copy
- alert text only where existing text still causes hesitation

Design and engineering may make minor hierarchy or layout adjustments if needed, but this is a clarity pass, not a new UI system.

### 2) Publish surface package
Prepare the release-facing package for the experience:
- final naming / tagline recommendation
- one icon brief
- three primary thumbnail briefs
- short description
- long description
- release-notes copy
- genre / mood positioning recommendation
- content-maturity disclosure notes aligned to the actual gameplay

This sprint should leave the team with a truthful store-page package that matches the real experience.

### 3) Launch candidate hardening
Protect the existing build while removing obvious ship blockers:
- critical bug pass focused on Sev 1 / Sev 2 issues
- build + smoke stability
- targeted regression proof for save / payout / shop / late join
- device/client readability pass
- low-risk cleanup of the non-blocking `Remotes.model.json` warning only if it does not threaten the stable baseline
- low-risk `serve.sh` / Rojo workflow notes only if they improve operator reliability

### 4) Launch watchlist and release checklist
Turn the ready sprint stack into something the team can safely monitor and judge:
- launch watchlist with the few KPIs/events that matter first
- no-go triggers
- release checklist
- rollback / known-issues discipline
- QA gate that distinguishes:
  - structural/build proof
  - runtime regression proof
  - client-facing readability proof
  - publish-surface completeness
  - device/performance sanity

## Explicitly out of scope
- new round events
- new maps or store zones
- new progression systems
- Robux monetization rollout
- subscriptions
- badges / referrals / invite features
- daily quests
- deeper inventory systems
- combat / chase / roaming manager systems
- major economic rebalance unless required by a confirmed launch-blocking bug

## Success criteria
Sprint 4 is ready when:
1. A new tester can understand payout, saved `Cash`, and results wording without live clarification.
2. The tutorial, late-join state, HUD, and results flow remain readable on phone-sized screens.
3. No known Sev 1 / Sev 2 gameplay, save-data, or progression regressions remain open.
4. A release-facing package exists for icon, thumbnails, title/tagline, short description, long description, and release notes.
5. Genre / mood positioning and content-maturity guidance are documented.
6. `check.sh`, `build.sh`, and structural smoke are green, and real client evidence exists for the launch-facing clarity changes.
7. QA can complete a real release checklist and make an honest Ready / Not Ready call for Milestone 4.

## Recommended worker order
1. `design` locks the launch-facing copy, first-10-minute friction review, publish-surface contract, and launch watchlist.
2. `engineer` implements only the targeted hardening / wording / layout changes and low-risk tooling cleanup.
3. `content` runs in parallel after design lands, delivering store-page copy, thumbnail/icon briefs, and release notes.
4. `qa` runs a launch-candidate gate and completes the release checklist.
5. `main` updates `project/docs/SPRINT.md`, marks Milestone 4 status, and either calls the release candidate ready or leaves a narrow blocker list.

## File ownership recommendation
- `main` owns `project/docs/SPRINT.md`
- `design` owns `project/docs/GDD.md`, `project/docs/DECISIONS.md`, `project/docs/HANDOFF-ENGINEERING.md`, `project/docs/LAUNCH-WATCHLIST-S4.md`
- `engineer` owns `project/src/**`, `project/scripts/**`, and low-risk build/tooling adjustments
- `content` owns `project/docs/ART-DIRECTION.md`, `project/docs/HANDOFF-CONTENT.md`, `project/docs/STORE-PAGE-BRIEF-S4.md`, `project/docs/RELEASE_NOTES.md`
- `qa` owns `project/docs/QA.md`, `project/docs/TEST-PLAN-SMOKE.md`, `project/docs/BACKLOG.md`, and `project/docs/RELEASE-CHECKLIST-S4.md`

## Risks to control
- drifting into “just one more feature” instead of hardening
- copy changes that accidentally misrepresent real payout logic
- store-page marketing promising content that is not actually in the build
- non-critical tooling cleanup destabilizing the current baseline
- device-emulator proof being mistaken for real client/performance proof
- launch checklists becoming vague instead of forcing honest go / no-go decisions

## Producer call
Treat Sprint 4 as a **launch-candidate hardening sprint**.
Do not expand scope into new content systems.
The only acceptable changes are the ones that make the current experience clearer, safer to ship, and easier to evaluate honestly.
