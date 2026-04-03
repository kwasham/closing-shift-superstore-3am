# Design worker — Sprint 3 alpha return loop spec

## Your role
You are the design owner for **Closing Shift: Superstore 3AM** Sprint 3.

Your job is to lock a **small but real return loop** that fits the already-ready Sprint 1/2 baseline.

## Read first
- `project/docs/GDD.md`
- `project/docs/ROADMAP.md`
- `project/docs/SPRINT.md`
- `project/docs/DECISIONS.md`
- `project/docs/BACKLOG.md`
- `project-template/docs/SPRINT3-PLAN.md`
- `project-template/docs/KPI-CANDIDATES-S3.md`

## What you must deliver
Update:
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/KPI-CANDIDATES-S3.md`

## Scope you are locking
### 1) New event
Lock the full design spec for **`Security Alarm`**.

You must specify:
- exact eligibility window
- exact once-per-round rule
- overlap rules against blackout, mimic, and `Close Register`
- exact timer, hold duration, and failure penalty
- exact player-facing alert/cue language
- exact resolve/fail states
- node naming contract and state model

Default target unless you have a stronger reason:
- 15s response window
- 2.0s hold
- -12s shared timer on fail
- no cash penalty
- no damage

### 2) Progression v1
Lock a lightweight persistent progression loop.

You must specify:
- exact saved fields
- exact XP earn sources
- exact level thresholds
- where level is displayed
- what progression affects and does not affect
- how existing `Cash` and new XP/Level should be explained together

Hard rule:
- no gameplay buffs that change movement, stamina, health, or payout multipliers in Sprint 3

### 3) Cosmetic shop v1
Lock the first shop contract.

You must specify:
- exact slot names
- exact 6 starter items
- price
- level requirement
- ownership / equip rules
- purchase denial rules
- where items are visible enough for QA to verify
- exact UI copy for insufficient funds / insufficient level / equipped / owned

Hard rule:
- use soft currency `Cash`
- lobby-only purchase flow
- no Robux monetization in Sprint 3

### 4) Instrumentation contract
Document the event names and minimal fields engineering must log.

You must specify:
- funnel steps
- custom/economy event names where relevant
- what “enough proof” looks like if dashboard data lags
- the minimum analytics/log contract QA should expect

## Design constraints
- keep total scope shippable in one sprint
- preserve the ready Sprint 1/2 feel
- prefer readable systems over deep systems
- do not add any feature that needs a roaming NPC or a second map
- do not use “figure it out later” language on payout, XP, level, or shop denial states

## Output format
Return:
1. concise summary
2. exact files changed
3. locked numbers/rules
4. biggest engineering implications
5. explicit statement on whether engineering is unblocked

## Success bar
Engineering should be able to implement without asking for:
- event overlap clarification
- shop/state clarification
- saved-data clarification
- analytics naming clarification
