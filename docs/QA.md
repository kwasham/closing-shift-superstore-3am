# QA

## MVP acceptance criteria
- A round can start from a cold server state.
- At least one task can be completed and counted.
- The HUD reflects round state and progress.
- A blackout event can fire without breaking the round.
- End-of-round payout is visible.
- Smoke script can detect core services/modules without crashing.

## Sprint 6 visual vertical slice gate — 2026-04-05 evidence-only rerun
- Status: Ready
- What was checked:
  - Prompt requirements in `project/prompts/QA_SPRINT6_VISUAL_VERTICAL_SLICE_GATE.md`
  - Newly appended proof in `project/docs/RUNTIME-EVIDENCE.md`
  - Referenced capture files in `project/docs/proof/sprint6/`
  - Previously established green baseline accepted as already proven for this rerun:
    - `bash scripts/check.sh` — pass
    - `bash scripts/build.sh` — pass
    - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua` — pass
    - `run-in-roblox --place build/ClosingShift.rbxlx --script scripts/sprint6_visual_probe.lua` — pass
- Result:
  - The appended proof pack now covers all five required matched before / after pairs: lobby / entrance, checkout zone, hero aisle, freezer section, and stockroom corner.
  - The live capture set now covers active shift, blackout, mimic, round-end success, and round-end failure with readable HUD / prompt / summary states.
  - The five-zone slice reads as a real player-facing uplift over the prior graybox baseline and the visual language is consistent enough across signage, counters, shelving, freezer framing, stockroom dressing, lighting states, and HUD treatment to clear the Sprint 6 gate.
  - The newly documented HUD bootstrap fix is honest enough for this rerun: the proof pack is tied to source-backed client paths in `project/src/StarterGui/HUD.client.lua`, `project/src/StarterGui/ClientEffects.client.lua`, `project/src/StarterGui/LightingController.client.lua`, and `project/default.project.json`.
- Blockers:
  - None for Sprint 6 visual-slice acceptance.
- Risks:
  - Known broader runtime-source drift remains tracked separately and is not being reopened here because the new Sprint 6 proof pack is materially complete and not shown to be dishonest.
  - The mobile readability proof was captured from Studio mobile-view rather than external device hardware; that is acceptable for this sprint gate but still worth spot-checking later if broader runtime work resumes.
- Next fixes:
  - Treat remaining Sprint 6 work as non-blocking polish and release-surface follow-through, not gate blockers.
  - Keep the broader runtime/constants reconciliation on its own track outside Sprint 6 acceptance.

## Bug report template
- Area:
- Build / commit:
- Setup:
- Steps:
- Expected:
- Actual:
- Severity:
- Notes:
