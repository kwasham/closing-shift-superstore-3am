# Decisions

## Decision log
- Use a text-first Rojo workflow instead of a Studio-only binary workflow.
- Keep MVP to one store map and one currency.
- Server owns round state, rewards, and dangerous events.
- Cosmetics come before strong power monetization.
- OpenClaw uses `main` as orchestrator plus worker agents for design, engineering, content, and QA.

## 2026-04-03 — Sprint 4 launch-candidate locks
- Player-facing economy terms are locked to `Shift Cash` for current-round earnings and `Saved Cash` for the persistent balance. Standalone `Banked` wording is removed from launch-facing HUD, tutorial, late-join, and results surfaces.
- `Clear` and `Timeout` cannot appear as unexplained standalone payout labels. Sprint 4 copy must use outcome-first phrasing such as `If you clear`, `If time runs out`, `Clear bonus`, and `Timeout pay (60%)`.
- Sprint 4 clarity work is limited to copy, ordering, wrap/auto-size, and other low-risk hierarchy changes on the existing HUD / results / late-join surfaces. No new UI system, no new gameplay tutorial system, and no economy-rule changes are allowed in this sprint.
- Publish-surface copy is locked to the current build: one supermarket, short co-op horror closing shifts, blackout + false task + security alarm disruptions, and cosmetic `Cash` spending. Do not promise roaming enemies, combat, extra maps, live events, badges, or monetization expansion.
- Milestone 4 readiness requires actual client-visible proof for tutorial/start readability, active HUD readability, late-join readability, and results readability. Headless or harness proof still counts for regression coverage, but it is not enough by itself for launch-facing clarity signoff.
- The `Remotes.model.json` Rojo warning may be cleaned up only by removing the ignored top-level `Name` field if the build stays stable. Any broader remote-folder or Rojo-structure refactor is deferred.

## 2026-04-03 — Sprint 5 soft launch locks
- Sprint 5 scope is locked to **soft launch retention and distribution** only: `Daily First Shift Bonus`, three launch badges, round-end `Invite Friends`, analytics/debug logging, config-first hooks, and the related store/update/results copy.
- `Daily First Shift Bonus` is locked to **`+$25 Saved Cash`**, awarded once per player per **UTC day** at normal round-end payout time for round-start roster players still present. It can award on either success or failure, gives **no XP**, and never changes `Shift Cash`, success bonus, timeout multiplier, or task reward math.
- Daily reset naming is locked to UTC reset keys in **`YYYY-MM-DD`** format at **00:00 UTC**. Sprint 5 does not use client-local midnight.
- Launch badges are locked to exactly three Roblox badges with no gameplay reward:
  - `first_shift` / `First Shift` = finish 1 shift
  - `shift_cleared` / `Store Closed` = clear 1 shift
  - `three_am_regular` / `3AM Regular` = claim the daily bonus on 3 different UTC days
- Badge unlock copy is locked to **`Badge unlocked: <BadgeName>`**. If multiple badges unlock in one round, display them in this order: `First Shift`, `Store Closed`, `3AM Regular`.
- Round-end share/distribution is locked to the existing results surface only. CTA button copy is **`Invite Friends`**. Helper copy is:
  - success: **`Good shift. Bring a crew back in.`**
  - failure: **`Bring backup for the next shift.`**
  - fallback: **`Invites aren’t available here. Use the Roblox game page or platform share menu.`**
- Sprint 5 invite/share adds **no reward, no badge credit, no referral code, no friend list, and no new social system**.
- Sprint 5 analytics naming is locked to lower-case `snake_case` events emitted through the existing `AnalyticsService.emit(...)` path so local debug logging keeps the existing **`[analytics] <event> <json>`** format. New Sprint 5 events are:
  - `daily_first_shift_bonus_awarded`
  - `daily_first_shift_bonus_skipped`
  - `launch_badge_awarded`
  - `launch_badge_award_failed`
  - `round_end_share_cta_shown`
  - `round_end_share_cta_pressed`
  - `round_end_share_cta_fallback_shown`
- Sprint 5 tuning must stay config-first and local. Allowed tunables are the bonus enable/value/reset hour, badge enable flags, the `3AM Regular` required-day count, share CTA enable/success/failure visibility, and analytics debug logging. Remote config and A/B plumbing are out of scope.
