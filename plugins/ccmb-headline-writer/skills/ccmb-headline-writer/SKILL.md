---
name: ccmb-headline-writer
description: Generate 10 headline variations for a given topic + audience + voice. Uses mechanism-headline and objection-headline patterns (not just outcome). Use when drafting hero headlines, magnet titles, free-tool naming, or email subject lines. Triggers — "/ccmb-headline-writer", "generate headlines", "give me 10 headline options for X".
---

# CCMB Headline Writer

> **STATUS — STUB.** Full implementation pending. This file resolves the install URL referenced by the Session 1 trigger prompt so the skill installs successfully. Behavior below is minimal; real implementation lands before cohort 1.

## What it does (target behavior)

Given a topic, audience, and voice reference (typically `CLAUDE.md`), generates 10 headlines spanning three patterns:

1. **Mechanism** — names the *how* (e.g., "The 3-skill stack that ships your marketing site this afternoon")
2. **Objection** — flips the reader's hesitation (e.g., "You don't need to know code. You need to know what to ask Claude.")
3. **Outcome** — the standard "you'll get X" frame (used sparingly — most marketers default here and it's why their headlines blur together)

Returns the 10 options ranked, no commentary.

## Stub behavior (until full implementation)

Read the active `CLAUDE.md`. Generate 10 headlines for the requested target. Mix the three patterns. Return ranked list.

## See also

- `../ccmb-sentence-editor/SKILL.md` for polishing the winning headline
- `../../references/vibe-editing.md` for the "3 options ranked, no commentary" prompt-shape pattern
