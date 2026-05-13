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
  ccmb-landing-page/SKILL.md       ← session-1 generator (monolith, single-shot)
  ccmb-headline-writer/SKILL.md    ← utility, used in S1-S5
  ccmb-sentence-editor/SKILL.md    ← utility, used in every session

  # LP factory stack (additive, multi-page workflow)
  ccmb-lp-design/SKILL.md          ← step 1: brand design system (tokens + components)
  ccmb-lp-copy/SKILL.md            ← step 2: conversion copy via frameworks
    references/                    ← bundled — frameworks, copy-patterns, voice-rules, swipe-file
  ccmb-lp-build/SKILL.md           ← step 3: scaffold + deploy (orchestrator, auto-chains)

references/
  vibe-editing.md           ← cross-cutting cheat sheet linked from every session
```

## Two LP paths

**Single-shot (monolith) — `/ccmb-landing-page`:**
One skill, design + copy + build in one pass. Use for one-off pages where reusability across pages doesn't matter.

**Factory stack (3 skills) — `/ccmb-lp-design` → `/ccmb-lp-copy` → `/ccmb-lp-build`:**
Reusable brand design system + framework-driven copy + cached artifacts. Use when shipping multiple pages on the same brand. `/ccmb-lp-build` auto-chains the prerequisites if their artifacts are missing, so a blank folder still works with a single `/ccmb-lp-build` prompt.

## What students fetch

The session-1 trigger prompt fetches and executes:

- `sessions/session-1/instructions.md` — what to build, scaffold rules, default styling, deploy flow
- `skills/ccmb-landing-page/SKILL.md` — installs app-wide to `~/.claude/skills/`
- `skills/ccmb-headline-writer/SKILL.md` — same
- `skills/ccmb-sentence-editor/SKILL.md` — same

The LP factory stack installs independently. See `Installing the LP factory stack` below.

URLs use `raw.githubusercontent.com/heymitch/ccmb-marketplace/main/<path>`.

## Installing the LP factory stack

Paste this in any Claude Code chat to install all three LP factory skills app-wide:

```
Install the CCMB LP factory stack to ~/.claude/skills/ by fetching:
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-design/SKILL.md
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/SKILL.md
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-build/SKILL.md
And the lp-copy references folder:
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/references/frameworks.md
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/references/copy-patterns.md
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/references/voice-rules.md
- https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/references/swipe-file.md
Place each in ~/.claude/skills/<skill-name>/ matching the marketplace structure.
```

Then in any folder: `/ccmb-lp-build` → blank-workspace → live page in 14-22 minutes on first run, 9-12 minutes per page after.

## Versioning

Breaking changes bump the trigger-prompt version inside `session-N-landing-page.md` in the CCMB project. Backwards-compatible fixes ship straight to `main`.

See `CHANGELOG.md`.
