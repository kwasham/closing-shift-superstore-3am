# Content handoff

Use this file when engineering, production, or QA needs the locked Sprint 5 soft-launch content package.

## Objective
Deliver a truthful soft-launch content layer for the current build only.

Focus on:
- `Daily First Shift Bonus` copy
- launch badge naming and description copy
- round-end `Invite Friends` CTA copy plus fallback
- update/store/release surfaces for the current soft-launch build
- mobile-readable wording QA can verify in the live build

Do **not** expand the promise beyond the existing build.

## Read first
- `project/docs/HANDOFF-ENGINEERING.md`
- `project/docs/GDD.md`
- `project/docs/DECISIONS.md`
- `project/docs/ART-DIRECTION.md`
- `project/docs/RELEASE_NOTES.md`
- `project/docs/SOFT_LAUNCH_BRIEF-S5.md`

## Files edited for Sprint 5
- `project/docs/ART-DIRECTION.md`
- `project/docs/HANDOFF-CONTENT.md`
- `project/docs/RELEASE_NOTES.md`
- `project/docs/SOFT_LAUNCH_BRIEF-S5.md`

## Locked Sprint 5 package

### Store/update summary line
- `Soft launch: claim a Daily First Shift Bonus, unlock launch badges, and invite friends from the results screen.`

### Release-note bullets
- `Daily First Shift Bonus: your first completed shift each UTC day adds +$25 Saved Cash.`
- `Launch badges: First Shift, Store Closed, and 3AM Regular.`
- `Round-end Invite Friends button with fallback messaging on unsupported platforms.`

### Daily bonus results copy
- `Daily First Shift Bonus: +$25 Saved Cash`

Rules:
- show this line only when the bonus is actually awarded
- do not show a placeholder line when the player already claimed it that UTC day
- do not describe it as `Shift Cash`
- do not mention XP because the bonus grants none

### Launch badge copy
Use Roblox badge names and descriptions exactly as follows:
- `First Shift`
  - description: `Finish your first full shift.`
- `Store Closed`
  - description: `Clear a shift before time runs out.`
- `3AM Regular`
  - description: `Claim the Daily First Shift Bonus on 3 different UTC days.`

Results-line format:
- `Badge unlocked: <BadgeName>`

If multiple badges unlock in one round, display them in this order:
1. `First Shift`
2. `Store Closed`
3. `3AM Regular`

### Share / invite copy
Success-state helper line:
- `Good shift. Bring a crew back in.`

Failure-state helper line:
- `Bring backup for the next shift.`

Button label:
- `Invite Friends`

Fallback helper line:
- `Invites aren’t available here. Use the Roblox game page or platform share menu.`

Fallback rules:
- keep the results surface usable
- replace helper text instead of opening a broken state
- do not imply rewards, referral credit, or badge credit for invites

## Publish-surface guardrails
Keep Sprint 5 messaging locked to the current build:
- one supermarket only
- 1–6 player co-op closing shifts
- blackout, false tasks, and security alarms remain the real disruption set
- Sprint 5 adds soft-launch retention/distribution surfaces only

Do **not** promise:
- extra maps or store expansions
- roaming enemies or combat
- referral rewards or share-to-earn rewards
- party systems, guilds, or a persistent social layer
- a major progression expansion beyond the three launch badges

## QA acceptance checklist
- Store/update summary matches the locked summary line.
- Release notes use the three locked Sprint 5 bullets.
- Results can show `Daily First Shift Bonus: +$25 Saved Cash` only when awarded.
- Results can show `Badge unlocked: <BadgeName>` lines in the locked order.
- Success results helper reads `Good shift. Bring a crew back in.`
- Failure results helper reads `Bring backup for the next shift.`
- Unsupported/error invite flow swaps to the locked fallback helper line.
- No Sprint 5 release surface claims extra rewards, extra maps, combat, or social systems.

## Notes for production / QA
- Title and tagline stay unchanged from Sprint 4:
  - `Closing Shift: Superstore 3AM`
  - `Close the store. Survive the shift.`
- Treat Sprint 5 as a soft-launch packaging pass, not a major content expansion.
- Prefer screenshots or clips that prove the real results UI copy over promotional mockups that imply more than the build supports.
