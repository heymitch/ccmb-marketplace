---
name: voice-training
description: Train Claude Code on your unique marketing voice with a deep 8-step analysis. Builds a complete Voice Template from your real writing that every CCMB content skill reads automatically. Say "train on my voice", "learn my writing style", or "build my voice profile".
---

# Voice Training (Builder)

Runs the full voice training pipeline. The student should feel like they're having a conversation with Cole, not filling out a form. Each step flows naturally into the next. Never say "Step 1" — just guide them.

## Preflight

Run silently. Never block.

1. **Voice samples exist?** Check `voice/` for any `.md` files. If none, proceed to gathering — no preflight message needed.
2. **Already trained?** Check if `voice/voice-template.md` exists. If yes: "Oh nice, you already have a voice profile from before. Want to start fresh with new samples, or just tune up what we've got?"

## Flow

Execute skills in sequence. Each step builds on previous outputs.

### 1. Gather Samples
Execute `skills/voice-dna-extractor/sub-skills/sample-gatherer/SKILL.md`.

### 2. Extract Voice DNA
Execute `skills/voice-dna-extractor/SKILL.md` (skip sample gathering — already done).

### 3. Profile Archetypes
Execute `skills/archetype-analyzer/SKILL.md`.

### 4. Analyze Vocabulary
Execute `skills/vocabulary-analyzer/SKILL.md`.

### 5. Map Sentence Fingerprint
Execute `skills/sentence-fingerprint/SKILL.md`.

### 6. Find Quirks
Execute `skills/quirk-injector/SKILL.md`.

### 7. Calibrate Tone
Execute `skills/tone-grid-calibrator/SKILL.md`.

### 8. Compile Voice Template
Execute `skills/voice-template-compiler/SKILL.md`.

### 9. Test & Refine
Execute `skills/mimic-and-modify/SKILL.md`.

### Save
Save the complete Voice Template to `voice/voice-template.md`.

Then offer to wire it into the student's `CLAUDE.md`:

> "Want me to add a `## Voice` block to your `CLAUDE.md` that points future sessions at `voice/voice-template.md`? Takes 10 seconds and means every CCMB skill (headline-writer, sentence-editor, content:* family) reads your voice automatically."

If yes, append to their root `CLAUDE.md`:

```markdown
## Voice
Voice Template: `voice/voice-template.md` (compiled by voice-lab)
All content skills MUST read this file before drafting copy.
```

Then say: "And we're done! Your Voice Template is saved and wired in. Every CCMB content skill will read it now. The cool thing is, this isn't locked in forever — you can say 'update my vocabulary' or 'recalibrate my tone' anytime to fine-tune it."

## Rules

- Execute ALL pipeline steps in sequence
- Do not skip steps to reduce processing time
- Save only after full pipeline completion and user approval
- Flag weak results honestly with recommended remediation (more samples, re-analysis, etc.)
- Preserve analysis quality across all steps
