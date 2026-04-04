# Engineering handoff

Use this file when design has a concrete implementation brief for engineering.

## Objective
Implement the Sprint 5 **soft launch retention and distribution** pass on top of the ready Sprint 1–4 baseline.

Focus only on:
- `Daily First Shift Bonus`
- three launch badges
- round-end `Invite Friends` CTA with graceful fallback
- Sprint 5 analytics events using the existing analytics/debug path
- config-first tuning hooks
- the exact locked results / store / update / badge / share copy

Do **not** expand into new gameplay systems, referral rewards, matchmaking, party systems, monetization expansion, new maps, new events, or broad UI rewrites.

## Read first
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/SPRINT.md`
- `project/docs/QA.md`
- `project/docs/RUNTIME-EVIDENCE.md`

## Preferred implementation surface
Use the existing modules and surfaces before creating anything new.

Likely target files:
- `project/src/ServerScriptService/Round/Config.lua`
- `project/src/ServerScriptService/Round/ShiftService.lua`
- `project/src/ServerScriptService/Round/PayoutService.lua`
- `project/src/ServerScriptService/Data/ProfileStore.lua`
- `project/src/ServerScriptService/Analytics/AnalyticsService.lua`
- `project/src/ReplicatedStorage/Shared/Constants.lua`
- `project/src/ReplicatedStorage/Shared/UIStrings.lua`
- `project/src/StarterGui/HUD.client.lua`
- `project/src/StarterGui/Sprint3UI.client.lua`
- `project/src/ReplicatedStorage/Remotes.model.json` only if the current result/profile replication path truly needs an extra low-risk payload route

Prefer extending the existing results/profile flow over inventing a new screen or a separate social/badge UI module.

## Hard no-change rules
Do not change:
- success bonus amount
- timeout-pay multiplier
- task reward numbers
- task quotas
- round duration / intermission duration
- blackout / mimic / security-alarm tuning
- shop prices / level requirements
- XP thresholds
- late-join participation rules
- active-roster payout rules
- map scope

Sprint 5 is a retention/distribution pass, not a systems rebalance.

## Locked implementation contract

### 1) Daily First Shift Bonus
- Feature name: **`Daily First Shift Bonus`**
- Amount: **`+$25 Saved Cash`**
- Award timing: evaluate at the normal round-end payout moment after the base round payout is calculated
- Eligibility:
  - player was in the round-start roster
  - player is still present at payout time
  - player has not already claimed the bonus for the current UTC reset day
- Reset rule:
  - use UTC only
  - reset key format: **`YYYY-MM-DD`**
  - reset time: **00:00 UTC**
- Outcome rule:
  - can award on success or failure
  - not part of `Shift Cash`
  - grants no XP
  - does not modify payout formulas
- Results copy when awarded:
  - **`Daily First Shift Bonus: +$25 Saved Cash`**
- If not awarded because it was already claimed today:
  - show no placeholder line

### 2) Launch badges
- Use Roblox badges.
- No badge grants currency, XP, or power.
- Locked badge list:
  - `first_shift` / `First Shift` = finish 1 shift and reach round-end payout
  - `shift_cleared` / `Store Closed` = clear 1 shift before timeout
  - `three_am_regular` / `3AM Regular` = claim the daily bonus on 3 different UTC days
- Award once only per account.
- Evaluate badge grants after the daily-bonus persistence write for that round.
- Results/badge copy format:
  - **`Badge unlocked: <BadgeName>`**
- If multiple badges unlock in one round, display them in this order:
  1. `First Shift`
  2. `Store Closed`
  3. `3AM Regular`

### 3) Results payload contract
Engineering may choose the internal profile field names, but the data sent to the existing results/profile UI should make these values directly available:
- `outcome`
- `shiftCash`
- `baseSavedCashAdded`
- `dailyFirstShiftBonusCash`
- `totalSavedCashAdded`
- `xpEarned`
- `levelAfter`
- `cashTotal`
- `xpTotal`
- `unlockedBadges` as an ordered array of `{ badgeId, badgeName }`

Keep this on the existing profile/results replication path if possible. Do not build a second results system.

### 4) Round-end Invite Friends CTA
- Surface: existing results screen only
- Show for round-start roster players still present at results
- Show on both success and failure
- Copy:
  - success helper line: **`Good shift. Bring a crew back in.`**
  - failure helper line: **`Bring backup for the next shift.`**
  - button: **`Invite Friends`**
  - fallback helper line: **`Invites aren’t available here. Use the Roblox game page or platform share menu.`**
- Graceful fallback:
  - if the native invite/share prompt is unavailable, blocked, or errors, keep the results UI usable and switch to the fallback helper copy
  - do not throw a blocking error state
- No referral rewards, no badge tie-in, no extra economy reward

### 5) Analytics + local debug logging
Use the existing analytics path. The current local debug print contract already exists:
- **`[analytics] <event_name> <json>`**

Do not create a separate Sprint 5 logging system. Route new events through `AnalyticsService.emit(...)` so proof can continue to use the recent-events buffer and standard console output.

Locked Sprint 5 events and minimum payload fields:

1. `daily_first_shift_bonus_awarded`
   - `user_id`, `round_id`, `round_outcome`, `shift_cash`, `base_saved_cash_added`, `bonus_cash`, `total_saved_cash_added`, `reset_key_utc`
2. `daily_first_shift_bonus_skipped`
   - `user_id`, `round_id`, `round_outcome`, `shift_cash`, `base_saved_cash_added`, `reset_key_utc`, `skip_reason`
   - allowed `skip_reason`: `already_claimed_today`, `feature_disabled`
3. `launch_badge_awarded`
   - `user_id`, `round_id`, `round_outcome`, `badge_id`, `badge_name`, `award_source`
   - locked `award_source`: `round_end_results`
4. `launch_badge_award_failed`
   - `user_id`, `round_id`, `round_outcome`, `badge_id`, `failure_reason`
   - allowed `failure_reason`: `service_error`, `feature_disabled`
5. `round_end_share_cta_shown`
   - `user_id`, `round_id`, `round_outcome`, `cta_variant`, `invite_supported`
6. `round_end_share_cta_pressed`
   - `user_id`, `round_id`, `round_outcome`, `cta_variant`, `invite_supported`
7. `round_end_share_cta_fallback_shown`
   - `user_id`, `round_id`, `round_outcome`, `fallback_reason`
   - allowed `fallback_reason`: `platform_unsupported`, `policy_blocked`, `prompt_error`

Keep older Sprint 1–4 event names unchanged.

### 6) Config-first tuning hooks
Put Sprint 5 values behind one local config surface. Do not scatter them across unrelated modules.

Locked tunables:
- `soft_launch_enabled = true`
- `daily_first_shift_bonus_enabled = true`
- `daily_first_shift_bonus_cash = 25`
- `daily_first_shift_bonus_reset_hour_utc = 0`
- `launch_badges_enabled = true`
- `three_am_regular_days_required = 3`
- `share_cta_enabled = true`
- `share_cta_show_on_success = true`
- `share_cta_show_on_failure = true`
- `analytics_debug_logging_enabled = true` in Studio/local proof and optional `false` in live if the normal analytics emit path still remains intact

Out of scope:
- remote config
- live tuning dashboard
- A/B splits
- extra badge definitions beyond the three locked ones

### 7) UI scope rules
Allowed Sprint 5 UI work:
- extend the existing results surface with optional daily-bonus / badge lines and the share CTA
- extend existing text/copy tables
- add the minimum low-risk button/state handling required for native invite prompt + fallback

Not allowed:
- new tabbed social UI
- new modal badge showcase system
- pre-round invite flow
- in-round CTA spam
- separate progression/badge screen

## Copy contract

### Store / update copy
- Summary line:
  - **`Soft launch: claim a Daily First Shift Bonus, unlock launch badges, and invite friends from the results screen.`**
- Release-note bullets:
  - **`Daily First Shift Bonus: your first completed shift each UTC day adds +$25 Saved Cash.`**
  - **`Launch badges: First Shift, Store Closed, and 3AM Regular.`**
  - **`Round-end Invite Friends button with fallback messaging on unsupported platforms.`**

### Results / badge / share copy
- **`Daily First Shift Bonus: +$25 Saved Cash`**
- **`Badge unlocked: <BadgeName>`**
- success helper: **`Good shift. Bring a crew back in.`**
- failure helper: **`Bring backup for the next shift.`**
- fallback helper: **`Invites aren’t available here. Use the Roblox game page or platform share menu.`**
- button: **`Invite Friends`**

## Proof expectations for engineering
Before calling Sprint 5 implementation done, capture honest proof for:
- `bash scripts/check.sh`
- `bash scripts/build.sh`
- daily bonus awarded once, then skipped on same UTC day
- daily bonus reset-key behavior across a forced/reset simulated next UTC day or equivalent deterministic proof
- `First Shift`, `Store Closed`, and `3AM Regular` badge award criteria
- badge double-award prevention
- results surface showing daily bonus + badge copy without breaking Sprint 4 wording
- share CTA shown on results
- share CTA fallback path when native invite/share is unavailable or forced to fail
- analytics console output / recent-event proof for the seven Sprint 5 events above
- no regression to late-join exclusion, payout landing, and shop persistent-cash behavior

If a proof item cannot be captured, leave it explicitly unverified instead of implying it passed.
