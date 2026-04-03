# Backlog

## Sprint 3 alpha gate blockers — cleared on 2026-04-03

### QA-S3-01 — Capture 2-player `Security Alarm` proof
- Status: Closed
- Completion note:
  - appended evidence now shows both players saw the alarm, one player resolved it for the team, duplicate follow-up did not double-resolve, fail still applied one shared `12s` timer penalty, and register unlock stayed deferred until resolve/fail

### QA-S3-02 — Capture missing shop proof for `insufficient_cash`
- Status: Closed
- Completion note:
  - appended evidence now shows the exact denial copy `Not enough Cash. Finish another shift.`, distinct `insufficient_cash` deny reason, blocked purchase, and stable cash/ownership/equipped state after denial

### QA-S3-03 — Capture Sprint 3 shop/results visual proof
- Status: Closed
- Completion note:
  - appended evidence now shows the equipped Sprint 3 preview/results state and a passing phone-sized command-backed layout/readability proof after the minimal UI-only hotfix in `project/src/StarterGui/Sprint3UI.client.lua`

## High-value follow-up, non-blocking

### QA-S3-04 — Expand analytics evidence for broader Sprint 3 funnel events
- Status: Open
- Why it matters: the focused Sprint 3 proof does not itself show `shift_started`, `first_task_completed`, `results_shown`, `shift_success`, or `shift_failure`.
- Completion note:
  - attach proof only if producer wants a stricter KPI-closeout pass after the alpha gate is green

### TECH-S3-01 — Remove the Rojo `Remotes.model.json` warning
- Status: Open
- Why it matters: build is green, but the warning is still noisy and should be cleaned up.
- Completion note:
  - remove the top-level `Name` field / align file naming with current Rojo expectations

## Parking lot
- roaming manager NPC
- revive mechanic
- seasonal event framework
- extra stores
- daily quests
