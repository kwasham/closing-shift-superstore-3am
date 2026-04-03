# Closing Shift: Superstore 3AM

This is the shared Roblox repo used by the OpenClaw Roblox game-dev pipeline.

## Workflow
- Open this folder in your editor
- Run `rokit install`
- Install the Rojo Studio plugin if needed
- Start syncing with `rojo serve`
- Let OpenClaw agents work against this repo via the `project/` symlink inside each workspace
- For the first implementation pass, start with `prompts/MAIN_SPRINT1_SEQUENCE.md`

## Core docs
- `docs/GDD.md`
- `docs/ROADMAP.md`
- `docs/BACKLOG.md`
- `docs/SPRINT.md`
- `docs/DECISIONS.md`
- `docs/QA.md`
- `docs/HANDOFF-ENGINEERING.md`
- `docs/HANDOFF-CONTENT.md`
- `docs/STORE-BEATS.md`
- `docs/TEST-PLAN-SMOKE.md`

## Prompt pack
- `prompts/MAIN_SPRINT1_SEQUENCE.md`
- `prompts/DESIGN_SPRINT1_TASK_SPEC.md`
- `prompts/ENGINEER_SPRINT1_MVP_IMPLEMENTATION.md`
- `prompts/CONTENT_SPRINT1_ENVIRONMENT_AND_COPY.md`
- `prompts/QA_SPRINT1_VALIDATION.md`

## Core commands
```bash
rokit install
rojo serve
rojo build default.project.json --output build/ClosingShift.rbxlx
selene src scripts
stylua src scripts
run-in-roblox --place build/ClosingShift.rbxlx --script scripts/smoke_runner.lua
```
