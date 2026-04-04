# Sprint 3 KPI candidates

Use this document to keep Sprint 3 analytics scoped and consistent.

## Primary product questions
1. Do players who finish one shift have a clearer reason to start another one?
2. Do players understand how saved `Cash`, XP, level, and cosmetics relate to each other?
3. Does the new `Security Alarm` add urgency without causing avoidable frustration?
4. Do players open the shop and successfully make at least one purchase/equip action after a successful shift?

## Candidate KPIs
### Retention / progression
- first-session shift completion rate
- first-session second-round start rate
- percentage of players who gain XP in session
- percentage of players who level up in session
- percentage of players who return with a persisted profile

### Economy / shop
- shop-open rate after shift results
- purchase conversion rate among players with enough `Cash`
- equip rate after purchase
- insufficient-funds denial count
- insufficient-level denial count

### Event readability
- security alarm resolve rate
- security alarm fail rate
- average time-to-reset alarm
- mimic trigger rate
- blackout completion / frustration notes from QA

## Funnel candidates
### Onboarding funnel
1. `onboarding_shown`
2. `onboarding_completed`
3. `shift_started`
4. `first_task_completed`
5. `shift_success` or `shift_failure`

### Return-loop funnel
1. `results_shown`
2. `shop_opened`
3. `purchase_succeeded`
4. `item_equipped`
5. `second_shift_started`

## Logging rule
If Creator Dashboard propagation is delayed, the sprint can still pass if:
- event names are documented,
- code paths are implemented,
- local structured log evidence exists,
- QA can map evidence to the intended funnel steps.
