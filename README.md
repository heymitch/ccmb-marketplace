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

  # S4 lead enrichment (replaces Apollo dependency — no vendor lock-in)
  ccmb-lead-enrichment/SKILL.md    ← cascade enrichment for existing lists, Tier 1 free sources only
                                     chains with /skyscraper for novel ICP archetypes
    references/                    ← bundled — cascade-playbooks (5 default ICP shapes), parsing-rules

  # Bonus packages (multi-skill plugins, installed as directories)
  ccmb-safe-install/               ← npm/CLI install shield, reads campaign-status.json
  ccmb-skyscraper/                 ← pre-flight scan for existing solutions
  ccmb-voice-lab/                  ← 10-skill voice training (Cole / Bush framework)
  ccmb-campaign-brainstorm/        ← dual-mode launch-campaign brief generator

references/
  vibe-editing.md           ← cross-cutting cheat sheet linked from every session

campaign-status.json        ← LIVE signal for the safe-install shield (see below)
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

## The bonus packages (multi-skill plugins)

Three larger packages live as full directories under `skills/`. They're multi-file (entry skill + sub-skills + bin/ or references/), so students install them as directories, not single SKILL.md files.

### `ccmb-safe-install` — the npm/CLI shield

Students say "install chalk" or `/safe-install chalk`, and the plugin handles publish-date quarantine, CVE lookup, lifecycle-hook defang, and pinned-version policy automatically. Reads live state from `campaign-status.json` at this repo's root — flip `campaign_active` to `false` and every student's shield relaxes globally on the next install.

```
skills/ccmb-safe-install/
  skills/safe-install/SKILL.md     ← entry point + policy
  bin/safe-npm                      ← bash worker (the actual install gate)
  bin/lib/*.py                      ← python helpers
  config/campaign-status.json       ← offline fallback (live version is at repo root)
```

### `ccmb-skyscraper` — pre-flight scan for existing solutions

Run `/skyscraper "<marketing problem>"` to scan native Claude Code skills + Apify Store + Reddit + YouTube before vibe-coding from scratch. Sub-agent fan-out with curated `known-natives.md` corpus. UserPromptSubmit hook auto-nudges on vibe-code intent.

### `ccmb-voice-lab` — 10-skill voice training

Ported from Cowork Bootcamp v2. Trains Claude Code on the student's writing voice using Nicolas Cole + Dickie Bush's *Digital Writers Voice Lab* framework. Outputs `voice/voice-template.md` that every CCMB content skill reads automatically. Orchestrator: `/voice-training`. Theory tour: `/voice-tutor`.

### `ccmb-campaign-brainstorm` — Campaign Pack planning skill

Dual-mode launch-campaign brief generator. Smart mode reads existing context (CLAUDE.md, voice-template.md, MCPs, deps) and asks ~6-8 Qs for what's missing. Workshop mode walks 5 framework layers (~15 Qs). Output: `campaigns/<slug>/brief.md` with 16-field YAML frontmatter + markdown body. Downstream CCMB skills auto-read the brief when cwd is at or below `campaigns/<slug>/` (v1.1 retrofit, separate ship).

MarTech section is Claude-native — uses installed MCPs, never defaults to paid SaaS. Ayrshare and HubSpot paid only mentioned if detected or asked.

## The campaign-status signal (for `ccmb-safe-install`)

`campaign-status.json` at the repo root is the live policy file the safe-install shield reads on every invocation. Shape:

```json
{
  "campaign_active": true,
  "campaign_name": "Mini Shai-Hulud / TeamPCP",
  "before_date_offset_days": 14,
  "pinned_packages": {"vercel": "39.4.0"},
  "recent_compromises": [],
  "last_updated": "2026-05-13"
}
```

**To deactivate the shield globally:** flip `campaign_active` to `false`. Every CCMB student's shield silently becomes a pass-through on next install. No emails, no manual reversal.

**To hard-block a freshly disclosed compromised version:** append to `recent_compromises` (e.g., `"foo@1.2.3"`). Students refuse to install it the moment the commit lands.

**To pin a different package:** add to `pinned_packages`. Students can only install the pinned version unless they pass `--pin-override`.

URL the shield fetches: `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json`

## Versioning

Breaking changes bump the trigger-prompt version inside `session-N-landing-page.md` in the CCMB project. Backwards-compatible fixes ship straight to `main`.

See `CHANGELOG.md`.
