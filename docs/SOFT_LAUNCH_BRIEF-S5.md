# Sprint 5 soft launch brief

## Objective
Lock the player-facing soft-launch package for the current build only.

Sprint 5 messaging is limited to:
- `Daily First Shift Bonus`
- three launch badges
- round-end `Invite Friends` CTA plus fallback
- update/store/release surfaces for the existing one-store build

## Unchanged publish identity
- Title: `Closing Shift: Superstore 3AM`
- Tagline: `Close the store. Survive the shift.`

## Locked summary line
- `Soft launch: claim a Daily First Shift Bonus, unlock launch badges, and invite friends from the results screen.`

## Locked release-note bullets
- `Daily First Shift Bonus: your first completed shift each UTC day adds +$25 Saved Cash.`
- `Launch badges: First Shift, Store Closed, and 3AM Regular.`
- `Round-end Invite Friends button with fallback messaging on unsupported platforms.`

## Locked results copy
### Daily bonus
- `Daily First Shift Bonus: +$25 Saved Cash`

Usage notes:
- show only when awarded
- no placeholder when skipped for already claimed today
- do not call it `Shift Cash`
- do not mention XP

### Badge unlock format
- `Badge unlocked: <BadgeName>`

Display order if multiple unlock together:
1. `First Shift`
2. `Store Closed`
3. `3AM Regular`

## Locked badge package
- `First Shift`
  - badge id: `first_shift`
  - description: `Finish your first full shift.`
- `Store Closed`
  - badge id: `shift_cleared`
  - description: `Clear a shift before time runs out.`
- `3AM Regular`
  - badge id: `three_am_regular`
  - description: `Claim the Daily First Shift Bonus on 3 different UTC days.`

Guardrails:
- badges grant no `Cash`, `Saved Cash`, XP, or power
- do not describe them as a progression overhaul
- keep badge messaging on the results surface only for Sprint 5

## Locked share / invite package
### Success helper
- `Good shift. Bring a crew back in.`

### Failure helper
- `Bring backup for the next shift.`

### Button
- `Invite Friends`

### Fallback helper
- `Invites aren’t available here. Use the Roblox game page or platform share menu.`

Guardrails:
- no referral reward language
- no invite reward language
- no badge tie-in language
- no promise of platform support everywhere

## QA verification list
- Summary line matches exactly on update/store surfaces.
- Release notes use the three locked Sprint 5 bullets.
- Awarded results can show `Daily First Shift Bonus: +$25 Saved Cash`.
- Skipped daily-bonus results show no placeholder line.
- Badge unlock lines use `Badge unlocked: <BadgeName>`.
- Multi-badge unlock order is `First Shift`, `Store Closed`, `3AM Regular`.
- Success results helper line matches exactly.
- Failure results helper line matches exactly.
- Invite fallback helper line matches exactly when invites are unavailable or fail.
- No player-facing Sprint 5 copy promises extra maps, combat, referral rewards, or a larger social system.

## Scope guardrail reminder
This is a soft-launch copy package, not a large feature announcement. Every surface should still read as the same fluorescent late-night supermarket build, now with one daily bonus, three launch badges, and a round-end invite prompt.