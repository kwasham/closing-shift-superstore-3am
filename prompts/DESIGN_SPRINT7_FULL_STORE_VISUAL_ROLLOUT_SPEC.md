# Design Worker — Sprint 7 Full-Store Visual Rollout Spec

## Mission
Turn the accepted Sprint 6 visual slice into a store-wide production spec that engineering, content, and QA can execute without style drift.

## You own
1. rollout priority tiers,
2. store-wide signage / wayfinding language,
3. final consistency rules for the remaining spaces,
4. public-facing icon / thumbnail direction,
5. performance-aware art boundaries.

## Required decisions
- exact Sprint 7 style sentence for the whole experience now that the slice is proven
- Tier A / Tier B / Tier C zone definitions
- what remaining primitive forms must disappear this sprint
- what kinds of primitive remnants are acceptable only if hidden
- signage grammar:
  - aisle numbers,
  - category headers,
  - checkout numbering,
  - staff / hazard language,
  - sale card rules
- transition rules between lobby, main floor, freezer, and stockroom
- public asset direction:
  - icon composition,
  - thumbnail set,
  - update / social shot priorities
- performance guardrails for lights, clutter, decals, and imported assets
- fallback order if the full-store pass runs tight
- QA proof checklist and pass/fail standard

## Constraints
- do not introduce new gameplay systems
- preserve phone-safe readability
- prefer modular reuse over one-off hero art
- keep the live build honest to the public-facing assets
- do not make Sprint 7 depend on a giant custom asset pipeline

## Files to update
- `project/docs/GDD.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/DECISIONS.md`
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/BACKLOG.md`

## Engineering handoff must include
- zone rollout table
- signage / decal rules
- must-replace primitive matrix
- lighting continuity rules
- performance guardrails
- public capture constraints
- QA-ready proof checklist

## Definition of done
Engineering and content should both be unblocked after your handoff with no ambiguity about what “full-store visual rollout” means.
