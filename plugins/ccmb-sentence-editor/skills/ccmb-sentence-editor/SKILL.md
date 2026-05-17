---
name: ccmb-sentence-editor
description: Tighten marketing copy. Remove hedging, AI-detection patterns, jargon, and parallel-structure tells. Pass a paragraph; get back a sharper version in the active CLAUDE.md voice. Use when polishing landing-page copy, email body, social posts, or any prose that needs to land harder. Triggers — "/ccmb-sentence-editor", "tighten this", "make this less AI", "edit my copy".
---

# CCMB Sentence Editor

> **STATUS — STUB.** Full implementation pending. This file resolves the install URL referenced by the Session 1 trigger prompt so the skill installs successfully. Behavior below is minimal; real implementation lands before cohort 1.

## What it does (target behavior)

Reads the active `CLAUDE.md` for voice context. Takes a paragraph or section as input. Returns a tightened version that:

- Cuts hedging (`it's worth noting`, `arguably`, `in many ways`, etc.)
- Kills AI-detection triggers (hedging stacks, three-clause parallel structures, "however/moreover/furthermore" transitions, summary closers)
- Replaces jargon with the working vocabulary in `CLAUDE.md`
- Closes em-dashes (`word—word`, never `word — word`)
- Sacrifices grammar for clarity where it sharpens a line

Returns the edited version. No "here's what I changed" preamble — just the result.

## Stub behavior (until full implementation)

Read the active `CLAUDE.md` for voice. Apply the cuts above. Return the tightened paragraph.

## See also

- `../../references/vibe-editing.md` for the copy-polish prompt template
