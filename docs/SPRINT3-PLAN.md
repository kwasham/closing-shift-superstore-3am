# Sprint 3 Plan — Alpha Return Loop

## Recommended sprint name
**Sprint 3 — Alpha Return Loop**

## Why this sprint now
Sprint 1 proved the shift loop. Sprint 2 proved that a first-time player can read and survive the experience without coaching. The next highest-value move is to turn the slice into a more honest alpha by giving players a reason to come back after one successful shift.

This sprint should add the minimum viable return loop:
- one additional round event that creates a new co-op decision
- persistent progression that grows across sessions
- a simple cosmetic spend/equip loop that gives saved `Cash` a visible use
- analytics instrumentation and a harder QA gate so the team can measure what happens next instead of guessing

## Sprint goal
Ship an alpha build where a player can:
- finish a shift
- earn persistent progress and see it clearly on the results flow
- spend saved `Cash` on a simple cosmetic
- equip that cosmetic and see it represented in the lobby/results layer
- experience a third event without destabilizing the proven Sprint 1/2 baseline
- generate meaningful analytics evidence for onboarding, shift outcome, shop use, and return-loop behavior

## Locked scope
### 1) New event — `Security Alarm`
Add one extra round event with a distinct fantasy from blackout and mimic.

**Design intent**
- shared urgency
- front-of-store movement
- readable in solo and co-op
- no NPCs
- no damage
- no death chain

**Spec target**
- max once per round
- eligible only while the round is live
- cannot overlap with blackout
- cannot start while a mimic node is currently active
- fires before `Close Register` is available
- highlights a dedicated `security_panel_node`
- gives players **15 seconds** to reset the alarm
- reset interaction hold duration target: **2.0s**
- success: event ends cleanly, no further penalty
- failure: shared timer penalty target **-12s**
- no direct personal cash penalty
- no revive/stamina mechanics added

### 2) Progression v1 — `Employee Rank`
Add lightweight persistent progression that does **not** change raw gameplay balance.

**Spec target**
- saved fields for:
  - `XP`
  - `Level`
  - `ShiftsPlayed`
  - `ShiftsCleared`
  - `OwnedCosmetics`
  - `EquippedCosmetics`
  - `ProfileVersion`
- level progression should be shallow and readable for alpha
- progression should not grant speed, stamina, health, or payout multipliers in Sprint 3
- progression should show on:
  - end-of-round summary
  - lobby/shop UI
  - late-join / waiting state where appropriate

**Initial XP target**
- normal task completion: small per-task XP
- `Close Register`: slightly higher XP
- round clear bonus: shared XP bonus
- round fail: smaller consolation XP
- `Security Alarm` reset: small resolver XP bonus
- mimic does not remove saved XP

### 3) Cosmetic shop v1
Turn saved `Cash` into a visible but low-risk spend loop.

**Spec target**
- lobby-only shop access
- no mid-round purchase flow
- use existing soft currency `Cash`
- exactly **2 cosmetic slots** for Sprint 3:
  - `NameplateStyle`
  - `LanyardColor`
- exactly **6 sellable items** total at first ship:
  - 3 nameplate styles
  - 3 lanyard colors
- item data includes:
  - id
  - display name
  - slot
  - price
  - required level
  - short flavor copy
- states required:
  - locked by level
  - purchasable
  - owned
  - equipped
- equip should persist across sessions
- visuals must be real enough that QA can verify them without imagination

### 4) Analytics and measurement
Add enough instrumentation to answer whether Sprint 3 improves return behavior.

**Minimum event coverage**
- onboarding shown / completed
- shift started
- first task completed
- shift success / failure
- blackout seen
- mimic triggered / expired
- security alarm seen / reset / failed
- shop opened
- purchase succeeded
- item equipped

**Implementation target**
- event names documented in one place
- structured debug logging available for runtime proof
- dashboard lag is acceptable, but local evidence must prove the code path fired

### 5) QA hardening
Upgrade the QA gate from “playable” to “alpha-safe”.

Required QA focus:
- persistence across leave/rejoin
- purchase/equip persistence
- no-cash / low-level purchase denial
- security alarm behavior in solo and co-op
- no regression to blackout, mimic, payout, tutorial, or late-join state
- mobile readability for shop / results / waiting screens
- analytics log evidence for key funnel steps

## Explicitly out of scope
- roaming manager NPC
- second map / new store
- revive or stamina
- combat or chase systems
- Robux monetization rollout
- subscriptions
- global leaderboards
- season pass / battle pass
- daily quests
- inventory beyond the 2 cosmetic slots
- major rebalance of Sprint 1/2 core timings unless needed for a bug fix

## Suggested design defaults
These are the default numbers/design targets unless design finds a better tuned version.

### XP defaults
- normal task: **+2 XP**
- `Close Register`: **+4 XP**
- shift success bonus: **+10 XP**
- shift failure consolation: **+4 XP**
- security alarm reset: **+4 XP** to the resolver

### Level thresholds
- Level 1: 0 XP
- Level 2: 20 XP
- Level 3: 45 XP
- Level 4: 75 XP
- Level 5: 110 XP
- Level 6: 150 XP

### Shop starter catalog
**NameplateStyle**
- `clean_shift` — $40 — level 1
- `retro_plastic` — $80 — level 3
- `neon_night` — $120 — level 5

**LanyardColor**
- `blue_id` — $50 — level 1
- `red_id` — $75 — level 2
- `gold_id` — $100 — level 4

## Success criteria
Sprint 3 is ready when:
1. `Security Alarm` is live, distinct, and does not regress blackout/mimic behavior.
2. A player can earn XP, level up, and keep that progress after rejoin.
3. A player can buy and equip at least one cosmetic item with saved `Cash`, and that ownership/equip state persists.
4. Shop denial states are clear for insufficient funds and insufficient level.
5. Results UI clearly communicates cash earned, XP earned, current level, and any new unlock/equip relevance.
6. QA has real runtime evidence for solo and 2-player shop/event/progression behavior.
7. Regression checks for Sprint 1 and Sprint 2 remain green.
8. Analytics/log evidence exists for the key funnel and economy events listed above.

## Recommended worker order
1. `design` locks the event/progression/shop spec and instrumentation contract.
2. `engineer` implements progression, persistence, shop flow, security alarm, and instrumentation.
3. `content` runs in parallel after design lands, delivering copy, catalog flavor, visual states, and presentation guidance.
4. `qa` runs an alpha gate with persistence + shop + event proof.
5. `main` updates `project/docs/SPRINT.md`, marks Milestone 3 status, and proposes Sprint 4.

## File ownership recommendation
- `main` owns `project/docs/SPRINT.md`
- `design` owns `project/docs/GDD.md`, `project/docs/DECISIONS.md`, `project/docs/HANDOFF-ENGINEERING.md`, `project/docs/KPI-CANDIDATES-S3.md`
- `engineer` owns `project/src/**`, `project/scripts/**`, and any instrumentation docs/code comments
- `content` owns `project/docs/ART-DIRECTION.md`, `project/docs/HANDOFF-CONTENT.md`, `project/docs/SHOP-CATALOG-S3.md`
- `qa` owns `project/docs/QA.md`, `project/docs/TEST-PLAN-SMOKE.md`, and QA follow-ups in `project/docs/BACKLOG.md`

## Risks to control
- shop/progression scope expanding into a full inventory system
- data migration mistakes breaking existing saved `Cash`
- UI clutter on phone-sized screens after adding XP/shop surfaces
- new event overlap creating unreadable stack states with blackout/mimic
- analytics work becoming dashboard-chasing instead of proof-driven
- cosmetic work depending on heavy art production before the systems are validated

## Producer call
Keep Sprint 3 focused on a **lightweight return loop**.
Do not let the team jump to heavy monetization, NPC horror, or multi-map scope before persistence, shop clarity, and measurement are solid.
