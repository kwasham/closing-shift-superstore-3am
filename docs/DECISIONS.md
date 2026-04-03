# Decisions

## Decision log
- Use a text-first Rojo workflow instead of a Studio-only binary workflow.
- Keep MVP to one store map and one currency.
- Server owns round state, rewards, and dangerous events.
- Cosmetics come before strong power monetization.
- OpenClaw uses `main` as orchestrator plus worker agents for design, engineering, content, and QA.
- Sprint 1 round length is locked to **9 minutes** with **15 seconds** of intermission.
- Sprint 1 supports **1–6 players** and snapshots the active player roster at round start; mid-round joiners wait for the next shift.
- Sprint 1 uses player-count-based task quotas instead of a flat six-task round.
- **Close Register** is the final gated task and cannot be completed until every other quota is done.
- Task cash is banked during the round and paid out only when the round ends.
- Success payout is **100% of banked task value + $35 clear bonus** for each active player.
- Failure payout is **60% of banked task value**, rounded down, with no clear bonus.
- Blackout happens **once per round**, for **10 seconds**, at a random point between **300 and 240 seconds remaining**.
- During blackout, players may finish an interaction already in progress, but no new task interaction can begin until blackout ends.
- Mimic happens **at most once per round**, only between **180 and 135 seconds remaining**, never during blackout, and never on **Close Register**.
- Mimic punishment for Sprint 1 is **no progress + 8-second team time loss + $12 personal payout penalty + 8-second lockout on the trapped node**.
- Mimic expires harmlessly if ignored for **18 seconds**.
- Sprint 1 punishments should create tension through time pressure and payout dents, not revive/death loops, stamina drains, or hard fail chains.
- Solo fairness for Sprint 1 comes from lower task quotas, only one blackout, only one mimic, and guaranteed partial payout on failure.
- Engineering will generate the Sprint 1 task arena and task nodes from Rojo-managed server code/registry data at boot so round-critical interactables are not dependent on hand-placed Studio instances.
- Sprint 1 was marked **Ready** after command/build/smoke proof, headless Roblox-engine runtime validation for the core round logic, and the final late-join proof confirmed excluded mid-round joiners cannot participate and receive the correct wait-for-next-shift messaging.
