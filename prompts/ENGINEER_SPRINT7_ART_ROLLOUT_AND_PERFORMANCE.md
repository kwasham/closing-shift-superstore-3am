# Engineer Worker — Sprint 7 Art Rollout and Performance

## Mission
Support the full-store art rollout in live runtime without destabilizing the accepted Sprint 6 gameplay and presentation baseline.

## You own
1. runtime-safe integration points for the wider art rollout,
2. cleanup of obsolete visible graybox support where safe,
3. signage / grouping helpers content needs,
4. lighting and state continuity across the full store,
5. performance and readability protection,
6. regression proof after the wider art pass.

## Implementation targets
- preserve or improve the visual-state system for:
  - normal shift
  - blackout
  - mimic emphasis
  - round-end summary states
- add any safe grouping, tagging, or theme hooks content needs for the wider rollout
- remove or hide obsolete placeholder structures when replacements are verified
- keep task prompts, task hitboxes, register logic, and event readability stable
- support consistent signage and zone organization where runtime structure helps
- ensure phone-safe HUD / prompt readability remains intact after the rollout
- keep build / smoke / proof scripts healthy

## Constraints
- no new mechanics
- no event rebalance
- no risky path rewrites unless required by the art rollout
- prefer low-cost presentation choices over expensive effect layering
- if an art asset or grouping is missing, fail gracefully rather than breaking the round

## QA-facing proof requirements
Collect or enable proof for:
- full-store normal-play readability
- blackout and mimic readability in non-slice zones
- 1-player and 2-player runtime sanity after the wider rollout
- before / after sweep support
- build + smoke still green
- phone-size HUD / prompt sanity still green

## Files you will likely touch
- runtime source under `project/src/**`
- any shared theme / config / grouping modules you add
- `project/default.project.json` if needed
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/BACKLOG.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Definition of done
The wider visual rollout is integrated safely, the runtime remains stable, and QA can verify the game looks consistently upgraded rather than selectively polished.
