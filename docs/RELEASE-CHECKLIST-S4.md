# Release Checklist — Sprint 4

## Build and tooling
- [ ] `bash scripts/check.sh` passed
- [ ] `bash scripts/build.sh` passed
- [ ] structural smoke passed
- [ ] non-blocking tooling warnings reviewed and documented
- [ ] rollback tag / commit recorded

## Runtime critical paths
- [ ] 1-player success path verified
- [ ] 1-player failure path verified
- [ ] payout lands in saved `Cash`
- [ ] blackout still behaves correctly
- [ ] mimic still behaves correctly
- [ ] security alarm still behaves correctly
- [ ] late join remains correct
- [ ] persistence spot-check passed

## Copy and readability
- [ ] payout / `Cash` wording is understandable
- [ ] tutorial intro is understandable without coaching
- [ ] late-join wait-state copy is understandable
- [ ] results screen is readable on phone-sized layout
- [ ] HUD / alert state is readable on phone-sized layout

## Publish surface package
- [ ] title / tagline finalized
- [ ] short description finalized
- [ ] long description finalized
- [ ] icon brief complete
- [ ] thumbnail brief set complete
- [ ] release notes drafted
- [ ] genre / mood guidance documented
- [ ] content-maturity guidance documented

## Device / client sanity
- [ ] device emulator pass completed
- [ ] at least one actual client/device observation captured
- [ ] no launch-blocking clipping issue remains
- [ ] no obvious severe performance blocker observed

## Known issues
- [ ] non-blocking issues documented in backlog
- [ ] open issues do not invalidate Milestone 4

## Final QA call
- [ ] QA verdict recorded
- [ ] Milestone 4 Ready / Not Ready recorded in `project/docs/SPRINT.md`
