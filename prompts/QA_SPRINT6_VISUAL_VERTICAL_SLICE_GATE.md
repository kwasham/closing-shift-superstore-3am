# QA Worker — Sprint 6 Visual Vertical Slice Gate

## Mission
Verify that Sprint 6 creates a real player-facing visual lift without regressing the Ready gameplay baseline.

## Required proof areas
1. **Build and structure sanity**
   - `bash scripts/check.sh`
   - `bash scripts/build.sh`
   - relevant smoke / proof script if available

2. **Before / after visual evidence**
   - lobby / entrance
   - checkout zone
   - hero aisle
   - freezer section
   - stockroom corner

3. **Live runtime visual evidence**
   - normal shift look
   - blackout look
   - mimic cue look
   - round-end summary look

4. **Readability proof**
   - phone-sized HUD during active shift
   - phone-sized HUD during alert state
   - prompt / objective readability inside the dressed zones

5. **Regression sanity**
   - 1-player playable sanity
   - 2-player playable sanity
   - no obvious task interaction breakage from new art dressing
   - no critical clipping or blocked paths in the polished slice

## Ready rule
Only clear Sprint 6 if:
- the critical-path slice no longer looks like raw graybox,
- the art direction is consistent enough to read as one game,
- blackout and mimic remain readable in live play,
- phone UI remains legible,
- build / smoke / runtime sanity stay green.

## Non-blocking findings
- untouched non-slice spaces that remain simpler
- minor prop polish opportunities outside the critical path
- extra thumbnail improvements that do not affect gameplay readability

## Files to update
- `project/docs/QA.md`
- `project/docs/BACKLOG.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Final output
Return a clear verdict:
- **Ready** or **Not Ready**
- list the exact remaining blockers, if any
- separate subjective polish wishes from true launch / baseline blockers
