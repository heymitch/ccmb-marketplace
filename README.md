# CCMB Marketplace

Public marketplace for the **Claude Code Marketing Bootcamp** — hosts the skills and instruction bundles that students fetch via the live-session trigger prompts.

Students don't clone this repo. Their Claude Code fetches individual files via `raw.githubusercontent.com` URLs at runtime.

## Structure

```
sessions/
  session-1/
    instructions.md         ← rich bundle the S1 trigger prompt fetches and executes
  session-2/ ... session-6/  (forthcoming)

skills/
  ccmb-landing-page/SKILL.md       ← session-1 generator
  ccmb-headline-writer/SKILL.md    ← utility, used in S1-S5
  ccmb-sentence-editor/SKILL.md    ← utility, used in every session

references/
  vibe-editing.md           ← cross-cutting cheat sheet linked from every session
```

## What students fetch

The session-1 trigger prompt fetches and executes:

- `sessions/session-1/instructions.md` — what to build, scaffold rules, default styling, deploy flow
- `skills/ccmb-landing-page/SKILL.md` — installs app-wide to `~/.claude/skills/`
- `skills/ccmb-headline-writer/SKILL.md` — same
- `skills/ccmb-sentence-editor/SKILL.md` — same

URLs use `raw.githubusercontent.com/heymitch/ccmb-marketplace/main/<path>`.

## Versioning

Breaking changes bump the trigger-prompt version inside `session-N-landing-page.md` in the CCMB project. Backwards-compatible fixes ship straight to `main`.

See `CHANGELOG.md`.
