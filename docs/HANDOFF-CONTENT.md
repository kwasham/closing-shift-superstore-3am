# Content Handoff

Use this file when engineering, design, or production needs Sprint 1 player-facing copy, world-sign text, prop priorities, and first-store content direction.

## Objective
Define the exact task-facing copy, onboarding wording, signage, and atmosphere support for the first playable supermarket slice in **Closing Shift: Superstore 3AM**.

## Source of truth
For Sprint 1 content, treat these as locked:
1. `project/docs/HANDOFF-ENGINEERING.md`
2. `project/docs/GDD.md`
3. `project/docs/STORE-BEATS.md`
4. `project/docs/ART-DIRECTION.md`

## Locked Sprint 1 content rules
- Round length is **9 minutes**.
- Intermission is **15 seconds**.
- Task value is **banked during the round** and paid at round end.
- `Close Register` is the **final gated task**.
- There is exactly **one blackout** max and **one mimic** max per round.
- Copy must stay short, readable, and mobile-friendly.
- Task names and task prompts must stay aligned with engineering's exact implementation names.

## 1) Exact task prompt copy + interaction verbs
Use the text below exactly for Sprint 1 prompts unless engineering needs a formatting change for UI constraints.

| Task id | Exact task name | Prompt text | Short interaction verb | World/readability note |
| --- | --- | --- | --- | --- |
| `restock_shelf` | Restock Shelf | Hold to restock shelf | Restock | Place on obvious half-empty shelf gap |
| `clean_spill` | Clean Spill | Hold to mop spill | Mop | Place on dark spill decal with clean edge |
| `take_out_trash` | Take Out Trash | Hold to haul trash bag out back | Haul | Anchor to one readable bag/drop point |
| `return_cart` | Return Cart | Hold to return cart to corral | Return | Show clear cart destination nearby |
| `check_freezer` | Check Freezer | Hold to inspect freezer alarm | Inspect | Anchor to freezer alarm panel or warning box |
| `close_register` | Close Register | Hold to count drawer and lock register | Close | Final task only; checkout lane hero node |

### Locked / disabled prompt states
Use these exact short states for Sprint 1.

| State | Text |
| --- | --- |
| `Close Register` locked | Finish all other tasks first |
| Any task during blackout | Blackout — wait for backup power |

## 2) Event alert copy
These are written to stay distinct at phone size. If engineering only ships one message per event, use the **Preferred default** lines.

### Blackout alerts
| Moment | Preferred default | Optional alternates |
| --- | --- | --- |
| Blackout start | Blackout. Wait for backup power. | Power out. New tasks disabled. / Lights out. Hold position. |
| Blackout end | Backup power restored. | Power restored. / Lights steady. Get moving. |

### Mimic alerts
| Moment | Preferred default | Optional alternates |
| --- | --- | --- |
| Mimic triggered | That wasn't on the list. | Wrong task. Time lost. / Fake task triggered. |

### Copy distinction rules
- **Blackout** copy should read as a store-wide systems failure.
- **Mimic** copy should read as a suspicious mistake or trap, not a power issue.
- Do not use long warning sentences.
- Avoid using the same opening word for both events.

## 3) First-round onboarding sequence
Keep onboarding to a short 4-step sequence. This should fit intermission and the opening moments of the first round.

### Recommended onboarding cards
1. **Finish the close**  
   Clear the store checklist before time runs out.
2. **Bank shift pay**  
   Real tasks add to Shift Pay. You get paid at round end.
3. **Register opens last**  
   `Close Register` unlocks after all other tasks are done.
4. **Watch for hazards**  
   Blackout blocks new tasks. Mimic is a fake task.

### Short banner fallback version
If only a single compact tutorial panel ships, use:

`Finish tasks to bank Shift Pay. Close Register unlocks last. Blackout blocks new tasks. Mimic is a fake task.`

### Onboarding tone rules
- Sound practical first, eerie second.
- Keep each step to 1 short sentence.
- Do not explain hidden timing windows or exact penalties in the tutorial.
- The player only needs enough information to avoid confusion.

## 4) Essential signs, decals, and label text
These are the minimum world-text elements that will make the first store readable.

| Zone | Text | Purpose |
| --- | --- | --- |
| Front doors | Entrance / Exit | Immediate orientation |
| Checkout | LANE 1 | Makes register lane distinct |
| Checkout wall or hanging sign | CHECKOUT | Visible home-base landmark |
| Aisle 1 | Aisle A / Snacks | Quick wayfinding |
| Aisle 2 | Aisle B / Drinks | Quick wayfinding |
| Aisle 3 | Aisle C / Household | Quick wayfinding |
| Freezer wall | FROZEN | Marks cold zone from a distance |
| Back door | EMPLOYEES ONLY | Makes trash route instantly readable |
| Exterior cart area | CART RETURN | Clarifies destination for cart task |
| Spill support prop | CAUTION WET FLOOR | Helps spill read without hiding decal |
| Optional checkout indicator | REGISTER CLOSED | Optional visual support for locked final task |

### Signage rules
- Prefer 1 to 3 words.
- Use high contrast with simple block fonts.
- Keep sign count low; every sign should help navigation.
- Do not wallpaper the store in posters.

## 5) Highest-priority props to place first in Studio
Place these before detail clutter. This order supports both content readability and engineering node hookup.

1. **Front doors + storefront windows**
2. **One checkout counter + register terminal + lane sign**
3. **Three short gondola aisles with clear shelf gaps**
4. **Freezer wall with alarm panel**
5. **Back trash door + utility nook + readable trash bag cluster**
6. **Cart corral + 2 to 4 loose carts**
7. **Fluorescent ceiling grid + emergency/exit lighting anchors**
8. **Spill decals + caution sign props**
9. **Wayfinding signs and labels**
10. **Ambient filler clutter only after task routes stay clear**

## 6) Optional sound cues
These are not required for Sprint 1 functionality, but they are the best low-cost audio beats to support mood.

| Trigger / location | Suggested cue | Purpose |
| --- | --- | --- |
| General sales floor | fluorescent hum | Baseline unease |
| Checkout lane | faint scanner beep / idle register buzz | Makes front area feel like the task hub |
| Freezer section | compressor hum + light rattle | Makes freezer feel colder and more hostile |
| Back trash area | vent hum + distant clank | Sells the dirtiest corner cheaply |
| Exterior cart area | light wind + loose cart rattle | Adds emptiness without big scope |
| Blackout start | hard power cut + hum drop | Clear event transition |
| Blackout active | low emergency electrical buzz | Keeps tension readable |
| Blackout end | power thunk + hum return | Confirms recovery instantly |
| Mimic trigger | short wrong-note sting or register chirp glitch | Makes the fake task feel intentional |

## 7) Task staging notes for builder + engineer
- `Restock Shelf` should look routine and safe at first glance.
- `Clean Spill` should read instantly from floor contrast, not from tiny decals.
- `Take Out Trash` should feel like a quick commitment into a dirtier corner.
- `Return Cart` should be visible from the storefront.
- `Check Freezer` should feel isolated enough to be memorable.
- `Close Register` should always look like the final objective location even while locked.

## 8) Sprint 1 tone target
The player fantasy is not "survive a monster attack." It is:
- finish normal retail tasks fast
- feel the store get stranger as the round goes on
- understand every objective immediately
- get a satisfying paycheck summary at the end

Keep the world copy plain, the mood cold, and the task language unmistakable.