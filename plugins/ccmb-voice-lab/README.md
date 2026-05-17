# Voice Lab — Claude Code edition

Ported from the Cowork Bootcamp v2 Voice Lab package. 10 sub-skills covering the *Digital Writers Voice Lab* framework by Nicolas Cole and Dickie Bush, wired for Claude Code's plugin/skills system instead of Cowork's `.coworker/` workspace.

## What you get

- `/voice-training` — the orchestrator. Runs the full 9-step pipeline (gather → DNA → archetype → vocab → sentence → quirks → tone → compile → mimic).
- `/voice-tutor` — optional 10-module lesson series if you want to learn the theory before doing it.
- 8 standalone analyzer skills you can invoke independently to tune one part of an existing Voice Template:
  - `voice-dna-extractor`
  - `archetype-analyzer`
  - `vocabulary-analyzer`
  - `sentence-fingerprint`
  - `quirk-injector`
  - `tone-grid-calibrator`
  - `voice-template-compiler`
  - `mimic-and-modify`

## Output

A single file: `voice/voice-template.md` at your workspace root. Every CCMB content skill (`headline-writer`, `sentence-editor`, `content:*` family) reads this automatically once you wire it into your `CLAUDE.md`:

```markdown
## Voice
Voice Template: `voice/voice-template.md` (compiled by voice-lab)
All content skills MUST read this file before drafting copy.
```

The `/voice-training` orchestrator offers to add this block for you on completion.

## Install

1. Marketplace install via `heymitch/ccmb-marketplace`, or drop this folder into your Claude Code plugins dir directly.
2. Run `/voice-training` and answer the prompts. Most students take 30-45 minutes the first time.
3. Re-run any individual analyzer to fine-tune (e.g., `/vocabulary-analyzer` after a new launch shifted your power-words list).

## Source attribution

The Voice Lab framework (Voice DNA, archetypes, tone grid, sentence fingerprint, quirk quotient, voice template) is Nicolas Cole and Dickie Bush's *Digital Writers Voice Lab*. This plugin is the Claude Code orchestration wrapper.
