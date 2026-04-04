# Engineer worker — Sprint 4 hardening and release implementation

## Your role
You are implementing Sprint 4 for **Closing Shift: Superstore 3AM**.

Build the smallest believable launch-candidate hardening pass without regressing the ready Sprint 1–3 baseline.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/LAUNCH-WATCHLIST-S4.md`
- `project/docs/QA.md`
- `project/docs/TEST-PLAN-SMOKE.md`
- `project-template/docs/SPRINT4-PLAN.md`
- `project-template/docs/RELEASE-CHECKLIST-S4.md`

## File ownership
You own:
- `project/src/**`
- `project/scripts/**`
- low-risk tooling/config adjustments required by the sprint

Do not edit content-owned or QA-owned docs except where command output or engineering evidence must be appended by process.

## Implementation target

### Build these changes
1. integrate the locked copy / wording cleanup across:
   - tutorial / onboarding
   - HUD / results language
   - late-join waiting state
   - any alert strings specifically called out by design
2. make any small layout adjustments required to keep the above readable on phone-sized screens
3. fix confirmed Sev 1 / Sev 2 launch blockers found in the current baseline
4. clean the non-blocking `Remotes.model.json` Rojo warning only if the fix is safe, quick, and does not threaten the stable baseline
5. update smoke or supporting scripts only if needed for release proof

### Preserve these systems
- 15s intermission
- 9-minute round
- blackout behavior
- mimic behavior
- `Security Alarm`
- XP / Level
- shop purchase / equip persistence
- `Close Register` gating
- current save-data behavior
- phone-safe UI improvements from earlier sprints

## Engineering expectations
### Data and regression safety
- no save-data wipe
- no payout regression
- no shop/progression regression
- no late-join regression
- if terminology changes, the real values shown to players must still match the actual underlying logic

### Tooling discipline
- do not chase non-blocking warnings if the fix becomes risky
- if the Rojo warning remains, document the exact remaining state honestly
- do not refactor stable code just to make this sprint feel larger

### Runtime clarity proof
- results screen after a successful round must show the clarified payout terminology
- failure results must also remain understandable
- late-join wait state must still initialize correctly
- phone-sized HUD/results state must remain readable after the text pass

## Required command pass
Run and report exact results for:
- `bash scripts/check.sh`
- `bash scripts/build.sh`
- the best available smoke/runtime path on the host
- `bash scripts/serve.sh` only if you touch the Rojo workflow or use it for proof

## Required runtime/client evidence
Capture or explicitly note status for:
- success results path with clarified payout wording
- failure results path with clarified payout wording
- saved `Cash` landing correctly after results
- late-join wait state on a real client path if available
- phone-sized readability after copy/layout changes
- spot-check that shop/progression persistence still behaves

## Output format
Return:
1. concise summary
2. exact files changed
3. commands run with exact outputs
4. runtime/client evidence captured
5. tooling cleanup results
6. known gaps or blockers
7. whether QA is unblocked

## Guardrails
- do not add Sprint 5 features
- do not add new monetization
- do not add new events or maps
- do not rewrite stable systems for style
