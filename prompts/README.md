# Sprint 1 prompts

These prompts are designed for the `main` OpenClaw agent to paste into worker sub-agent runs with minimal rewriting.

## Files
- `MAIN_SPRINT1_SEQUENCE.md` — orchestration order for `main`
- `DESIGN_SPRINT1_TASK_SPEC.md` — design brief for the first concrete spec pass
- `ENGINEER_SPRINT1_MVP_IMPLEMENTATION.md` — engineering brief for the MVP round/task/event/HUD slice
- `CONTENT_SPRINT1_ENVIRONMENT_AND_COPY.md` — content brief for the first store and player-facing copy
- `QA_SPRINT1_VALIDATION.md` — QA brief for acceptance criteria and smoke/manual validation

## Use pattern
1. `main` reads the sequence file.
2. `main` sends the design prompt first.
3. `main` then sends the engineer and content prompts.
4. `main` sends QA after implementation and content land.
5. `main` updates `project/docs/SPRINT.md` and reports status.

## Important
Keep `project/docs/SPRINT.md` owned by `main` during Sprint 1 to avoid needless merge conflicts.
