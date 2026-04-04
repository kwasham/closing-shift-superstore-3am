# Closing Shift: Superstore 3AM — GDD

## One-line pitch
A 1–6 player co-op Roblox horror job sim where players close a supermarket at 3AM, complete store tasks, survive escalating paranormal events, and spend their paycheck on cosmetics while climbing Employee Rank.

## Design pillars
1. **Instantly readable** — a player should understand the fantasy in under 10 seconds.
2. **Short tense rounds** — 8–10 minute sessions with rising pressure.
3. **Co-op chaos** — small mistakes create funny or scary moments with friends.
4. **Replay loop** — finish shift, earn payout, unlock more style and efficiency.
5. **Scope discipline** — one map, a handful of tasks, and two or three event types before any major expansion.

## Target session
- Players: 1–6
- Round length: 8–10 minutes
- Intermission: 15–20 seconds
- Goal: complete tasks and survive until shift end

## MVP systems
- Lobby + one playable grocery store
- Task system
  - restock shelves
  - clean spills
  - take out trash
  - return carts
  - check freezer
  - close register
- Round manager
- Basic event system
  - blackout
  - mimic / false task
- End-of-round payout
- One currency
- Light cosmetic shop
- HUD and round alerts
- Smoke test path

## Failure / tension model
- Players are under time pressure.
- Some tasks or events create risk.
- Failure should feel tense, not punishing enough to kill replayability.

## MVP monetization boundaries
Acceptable:
- cosmetics
- emotes
- flashlight skins
- private server
- extra loadout slots
- optional revive as a limited dev product

Avoid at MVP:
- heavy pay-to-win combat boosts
- multi-currency confusion
- deep stat grinds

## Future expansions
- new store types
- roaming manager enemy
- revive loop
- seasonal events
- deeper social progression

## Milestone 4 launch-candidate contract

### Player-facing currency and payout language
- Persistent profile currency is **`Saved Cash`**.
- In-round earnings before shift end are **`Shift Cash`**.
- `Cash` by itself is only acceptable on surfaces that show persistent currency only, such as shop prices, shop balance, or profile totals. Any surface that compares current-shift earnings against the persistent balance must spell out **`Saved Cash`**.
- Remove standalone **`Banked`** wording from launch-facing HUD, tutorial, late-join, and results surfaces.
- Active-shift payout preview must use outcome-first phrasing instead of unexplained shorthand:
  - `Shift Cash: $X`
  - `If you clear: +$Y`
  - `If time runs out: +$Z`
  - optional `False task penalty: -$P`
- Round-end payout summary must preserve the existing Sprint 1–3 economy rules and use:
  - `Shift Cash: $X`
  - success branch `Clear bonus: +$35`
  - failure branch `Timeout pay (60%): $Z`
  - optional `False task penalty: -$P`
  - `Saved Cash added: +$A`

### First-10-minute clarity rules
- Mandatory opening/tutorial wording:
  - round-start hint: `Clock in. Follow the glow to your first task.`
  - goal tutorial: `Finish the task list before the timer hits zero.`
  - in-round earnings tutorial: `Tasks add Shift Cash. Register unlocks last.`
  - late-join pinned alert stays `Shift in progress. Wait for the next one.`
- Late-join support copy must make two facts obvious without extra explanation:
  - the current shift started without that player
  - that player joins the next round instead of earning from the active one
- Allowed layout changes for Sprint 4:
  - auto-size and wrap the existing HUD / alert / objective / results text
  - increase results-card height or allow vertical scrolling if copy wraps
  - reorder existing payout lines so the `Saved Cash` landing is obvious
- Explicitly out of scope for Sprint 4 clarity work:
  - new tutorial systems or extra tutorial steps beyond the existing sequence
  - new HUD panels, popups, tabs, or economy explainer modals
  - any payout, XP, timer, quota, shop-price, or progression rebalance unless a confirmed blocker forces it

### Publish surface contract
- **Recommended title:** `Closing Shift: Superstore 3AM`
- **Recommended tagline:** `Close the store. Survive the shift.`
- **Short description direction:** `1–6 players close a haunted supermarket at 3AM: finish tasks, survive blackout, false-task, and security-alarm disruptions, then cash out for cosmetics.`
- **Long description direction:**
  1. Lead with the co-op overnight supermarket fantasy: restock shelves, clean spills, take out trash, return carts, check the freezer, and close the register.
  2. Call out the real disruption set only: blackout, false tasks, and security alarms.
  3. Explain the real reward loop only: finish shifts to add `Saved Cash` and XP, then spend `Cash` on cosmetic nameplates and lanyards.
  4. Position the game as short replayable 8–10 minute rounds for 1–6 players.
  5. Do **not** promise extra maps, roaming enemies, combat, live-event content, matchmaking, referral rewards, or monetization expansion. Sprint 5 soft launch messaging may mention only the locked **Daily First Shift Bonus**, the three locked **launch badges**, and the round-end **Invite Friends** CTA.
- **Icon brief:** a readable fluorescent superstore-at-3AM image with checkout / aisle readability first, late-night dread second, and no monster close-up, combat pose, or extra-location promise.
- **Three thumbnail beats:**
  1. a co-op work shot with obvious supermarket tasks and timer pressure
  2. a disruption shot centered on blackout or false-task tension inside the same store
  3. a progression / payoff shot showing post-shift cosmetics or results readability without implying deeper inventory scope
- **Genre / mood guidance:** co-op horror job sim, late-night retail tension, short-session replayability, social panic and confusion over gore or chase-combat fantasy.
- **Content-maturity disclosure notes:** mild horror tension, darkness, sudden alarms / blackout states, and paranormal fake-out moments; no graphic gore or explicit violence focus.
- **Release-note headline bullets:**
  - clearer `Shift Cash` vs `Saved Cash` wording
  - clearer late-join and results wording
  - hardened phone-sized readability on launch-facing UI
  - launch-candidate hardening and low-risk build cleanup

### Launch proof bar
- Milestone 4 is not ready on headless proof alone. The team needs actual client-visible evidence for tutorial/start readability, active-HUD readability, late-join readability, and results readability.
- Broader analytics dashboards are follow-up work, not a Milestone 4 blocker, as long as the required runtime proof, client proof, release checklist, and watchlist evidence exist.

## Sprint 5 soft launch retention and distribution contract

### Scope lock
- Sprint 5 is limited to soft-launch retention and distribution surfaces only:
  - **Daily First Shift Bonus**
  - **launch badges**
  - **round-end Invite Friends CTA with graceful fallback**
  - **analytics taxonomy plus local debug logging**
  - **config-first tuning hooks**
  - **launch / store / update / badge / share copy**
- Sprint 5 does **not** add new maps, enemies, combat, social hubs, referral rewards, matchmaking, monetization expansion, tutorial systems, or new in-round UI frameworks.
- Sprint 1–4 gameplay, payout math, task quotas, shop catalog pricing, XP thresholds, and event timings stay intact unless this contract explicitly says otherwise.

### Daily First Shift Bonus
- Player-facing feature name is locked to **`Daily First Shift Bonus`**.
- Award: **`+$25 Saved Cash`**.
- Award timing: evaluate at the normal round-end payout moment, immediately after the existing shift payout is calculated.
- Eligibility:
  - player was in the round-start active roster
  - player is still present when payout is awarded
  - player has not already claimed the bonus for the current reset day
- Outcome rule:
  - the bonus can be awarded on either **success** or **failure**
  - the bonus is **not** part of `Shift Cash`
  - the bonus grants **no XP**
  - the bonus does **not** change success bonus, timeout multiplier, mimic penalty, or task reward math
- Reset rule:
  - reset uses the **UTC calendar day** only
  - reset key format is **`YYYY-MM-DD`** in UTC
  - reset moment is **00:00 UTC**
  - do not use client-local midnight or region-local rollover for Sprint 5
- Results copy:
  - when awarded, add the exact line **`Daily First Shift Bonus: +$25 Saved Cash`** under the normal results payout lines
  - when not awarded because it was already claimed that UTC day, show **no placeholder line**
- Late-join / leave rule:
  - late joiners never receive the bonus for the active shift
  - a player who leaves before payout receives no shift payout and no daily bonus from that round

### Launch badges
- Sprint 5 launch badges are **Roblox badges**, not a new in-game progression track.
- Badges grant **no Cash, no Saved Cash, no XP, and no gameplay advantage**.
- Locked badge list:
  1. **`first_shift`** — display name **`First Shift`**
     - criteria: finish **1** shift on the round-start roster and reach round-end payout
     - badge description copy: **`Finish your first full shift.`**
  2. **`shift_cleared`** — display name **`Store Closed`**
     - criteria: clear **1** shift before time runs out on the round-start roster
     - badge description copy: **`Clear a shift before time runs out.`**
  3. **`three_am_regular`** — display name **`3AM Regular`**
     - criteria: claim the **Daily First Shift Bonus on 3 different UTC days**
     - badge description copy: **`Claim the Daily First Shift Bonus on 3 different UTC days.`**
- Badge award rules:
  - each badge is awarded once per account
  - evaluate badge unlocks at round end after the daily-bonus persistence write for that round
  - if multiple badges unlock in one round, display them in this order:
    1. `First Shift`
    2. `Store Closed`
    3. `3AM Regular`
- Results / toast copy:
  - each unlocked badge line uses the exact format **`Badge unlocked: <BadgeName>`**
  - keep badge messaging on the existing results surface or existing alert style; do not create a new modal badge system in Sprint 5

### Round-end Invite Friends CTA
- Feature purpose: increase distribution after the round ends without interrupting the live shift.
- Surface rule:
  - show the CTA on the existing round-end/results surface only
  - show it for round-start roster players who are still present at results time
  - allowed on both success and failure results
  - do not show it during `Playing`, intermission, late-join wait state, or shop-only lobby browsing
- Primary CTA copy:
  - success helper line: **`Good shift. Bring a crew back in.`**
  - failure helper line: **`Bring backup for the next shift.`**
  - button label: **`Invite Friends`**
- Graceful fallback rule:
  - if the platform invite/share prompt is unavailable, disabled, or errors, keep the CTA surface visible and replace the helper line with **`Invites aren’t available here. Use the Roblox game page or platform share menu.`**
  - fallback must not hard error, open a broken blank panel, or block the results screen
  - Sprint 5 does **not** add referral codes, invite rewards, friend lists, chat share compose, or persistent social UI
- Reward rule:
  - the CTA gives **no currency, no XP, and no badge credit**

### Analytics taxonomy and local debug logging
- Sprint 5 analytics must use the existing `AnalyticsService.emit(...)` path so the normal local debug output remains the same:
  - console format stays **`[analytics] <event_name> <json>`**
  - local debug history stays accessible through the existing recent-event buffer
- Naming rules:
  - event names are lower-case `snake_case`
  - payload keys are lower-case `snake_case`
  - player-bound events include `user_id`
  - round-end events include `round_id`
  - results-related events use `round_outcome` with only `success` or `failure`
- Locked Sprint 5 event list:
  1. **`daily_first_shift_bonus_awarded`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `shift_cash`, `base_saved_cash_added`, `bonus_cash`, `total_saved_cash_added`, `reset_key_utc`
  2. **`daily_first_shift_bonus_skipped`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `shift_cash`, `base_saved_cash_added`, `reset_key_utc`, `skip_reason`
     - allowed `skip_reason` values for Sprint 5: `already_claimed_today`, `feature_disabled`
  3. **`launch_badge_awarded`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `badge_id`, `badge_name`, `award_source`
     - locked `award_source` value for Sprint 5: `round_end_results`
  4. **`launch_badge_award_failed`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `badge_id`, `failure_reason`
     - allowed `failure_reason` values for Sprint 5: `service_error`, `feature_disabled`
  5. **`round_end_share_cta_shown`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `cta_variant`, `invite_supported`
     - locked `cta_variant` values: `success`, `failure`
  6. **`round_end_share_cta_pressed`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `cta_variant`, `invite_supported`
  7. **`round_end_share_cta_fallback_shown`**
     - required fields: `user_id`, `round_id`, `round_outcome`, `fallback_reason`
     - allowed `fallback_reason` values for Sprint 5: `platform_unsupported`, `policy_blocked`, `prompt_error`
- Do **not** rename older Sprint 1–4 events in Sprint 5.

### Config-first tuning hooks
- Put Sprint 5 tuning values behind one local config surface instead of scattering magic numbers across UI and server code.
- Locked tunables for Sprint 5:
  - `soft_launch_enabled = true`
  - `daily_first_shift_bonus_enabled = true`
  - `daily_first_shift_bonus_cash = 25`
  - `daily_first_shift_bonus_reset_hour_utc = 0`
  - `launch_badges_enabled = true`
  - `three_am_regular_days_required = 3`
  - `share_cta_enabled = true`
  - `share_cta_show_on_success = true`
  - `share_cta_show_on_failure = true`
  - `analytics_debug_logging_enabled = true` in Studio / local proof, allowed `false` in live if the normal analytics emit path still exists
- Not tunable in Sprint 5:
  - success bonus amount
  - timeout multiplier
  - task rewards
  - shop prices / level locks
  - XP thresholds
  - invite rewards
  - extra badge list beyond the three locked launch badges
- Sprint 5 does **not** add remote config, live-ops dashboard controls, or A/B test plumbing.

### Soft launch copy contract

#### Launch / store / update copy
- Store title and tagline stay:
  - **`Closing Shift: Superstore 3AM`**
  - **`Close the store. Survive the shift.`**
- Soft launch store/update summary line:
  - **`Soft launch: claim a Daily First Shift Bonus, unlock launch badges, and invite friends from the results screen.`**
- Soft launch release-note bullets:
  - **`Daily First Shift Bonus: your first completed shift each UTC day adds +$25 Saved Cash.`**
  - **`Launch badges: First Shift, Store Closed, and 3AM Regular.`**
  - **`Round-end Invite Friends button with fallback messaging on unsupported platforms.`**
- Publish-surface promise guardrail:
  - do not promise referral rewards, party systems, guilds, extra stores, combat, roaming enemies, or limited-time events as part of Sprint 5

#### Daily bonus / badge / share copy
- Daily bonus line: **`Daily First Shift Bonus: +$25 Saved Cash`**
- Badge line format: **`Badge unlocked: <BadgeName>`**
- Success share helper line: **`Good shift. Bring a crew back in.`**
- Failure share helper line: **`Bring backup for the next shift.`**
- Fallback share helper line: **`Invites aren’t available here. Use the Roblox game page or platform share menu.`**
- Share button label: **`Invite Friends`**

## Open questions
- exact revive design
- how punishing mimic tasks should be
- whether stamina exists in MVP or later
