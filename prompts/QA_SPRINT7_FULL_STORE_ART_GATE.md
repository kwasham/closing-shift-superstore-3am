# QA Worker — Sprint 7 Full-Store Art Gate

## Mission
Verify that Sprint 7 turns the accepted Sprint 6 slice into a genuinely consistent full-store presentation without breaking readability or the stable gameplay baseline.

## Required proof areas
1. **Build and structure sanity**
   - `bash scripts/check.sh`
   - `bash scripts/build.sh`
   - relevant smoke / proof script if available

2. **Before / after coverage**
   - lobby / entrance
   - remaining main aisles
   - checkout zone
   - freezer path
   - stockroom / visible back-of-house
   - at least one continuity sweep showing the store reads as one product

3. **Live runtime visual evidence**
   - normal shift across multiple zones
   - blackout readability outside the original Sprint 6 slice
   - mimic cue readability in the wider store
   - round-end summary still readable after the broader art pass

4. **Readability and gameplay safety**
   - phone-size HUD during active shift
   - prompt / objective readability in dressed spaces
   - no path blockage or obvious task-node burial from new props
   - 1-player and 2-player runtime sanity

5. **Public asset honesty**
   - icon / thumbnail candidates match the live build
   - captures use real spaces and believable compositions
   - no misleading overpromise relative to current fidelity

## Ready rule
Only clear Sprint 7 if:
- player-traversed spaces no longer feel half-placeholder,
- signage and wayfinding are readable,
- the store-page asset pack matches the real game,
- phone HUD / prompts remain legible,
- build / smoke / runtime sanity stay green.

## Non-blocking findings
- optional external-device spot checks beyond the core proof set
- deeper background dressing opportunities
- extra capture variants that are nice to have but not gate-critical

## Files to update
- `project/docs/QA.md`
- `project/docs/BACKLOG.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Final output
Return a clear verdict:
- **Ready** or **Not Ready**
- exact remaining blockers, if any
- separate subjective wishes from true blockers
