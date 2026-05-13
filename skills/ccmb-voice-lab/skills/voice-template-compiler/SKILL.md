---
name: voice-template-compiler
description: Compile all your voice analysis into a single Voice Prompt Template you can use with any AI tool. Say "compile my voice template", "build my voice prompt", or "create my voice template".
---

# Voice Template Compiler

## Purpose

Compile all voice analysis components into a single, reusable Voice Prompt Template for AI use across any platform.

## Flow

1. Read all analysis files from `voice/analysis/`:
   - `voice-dna.md` — core voice + style attributes (required)
   - `archetype-mix.md` — voice archetype percentages
   - `vocabulary-lists.md` — power words, avoid words, replacements
   - `sentence-fingerprint.md` — sentence length, structure, rhythm
   - `tone-grid.md` — tone grid position and quadrant
   - `quirk-quotient.md` — humor style, metaphor domains, backstory patterns
2. Check what's there and what's missing. If Voice DNA is missing: "We need your Voice DNA first — that's the foundation. Want me to run it?"
3. For missing but optional pieces, note them: "I don't have your Quirk Quotient yet, so I'll leave that section open. You can fill it in later by saying 'find my quirks.'"
4. Compile everything into the Voice Template format:

```
Write in the style of [Name].

Voice Attributes:
- [from Voice DNA]

Tone Attributes:
- [from Tone Grid position]
- Humor Style: [from Quirk Quotient]

Style Attributes:
- [from Voice DNA style analysis]
- Vocabulary Preferences:
  - Power Words: [from Vocabulary Analyzer]
  - Avoid Words: [from Vocabulary Analyzer]
  - Replacement Words: [from Vocabulary Analyzer]

Structure Attributes:
- Sentence Length: [from Sentence Fingerprint]
- Paragraph Length: [from Sentence Fingerprint]
- Signature Moves: [from Sentence Fingerprint + Archetypes]

Quirk Quotient:
- [from Quirk Injector]
- Anecdote Frequency: [from Quirk Injector]

Additional Instructions:
- [from Voice DNA + user preferences]
```

5. Present it: "Here's your Voice Template. This is you, distilled into instructions any AI can follow. You can paste this into ChatGPT, Claude, Gemini — anywhere — and it'll write in your voice."
6. Save to `voice/voice-template.md` as master copy

8. Offer to save as a standalone file: "Want me to save this as a separate file you can copy around?"

## Rules

- Voice DNA is required — everything else enhances but isn't blocking
- Template must work standalone — someone should be able to paste it into any AI with no extra context
- Use "TBD" for sections with no data yet, not empty sections
- Include a "last updated" timestamp
- This is a living document — remind them: "This gets better every time you test it with mimic-and-modify."

## Critical: Patterns Not Content

The Voice Template captures HOW someone writes — not WHAT they wrote about. When compiling:
- Store metaphor DOMAINS (e.g., "draws from tech and exploration"), not specific metaphors from their samples
- Store humor STYLE (e.g., "dry wit, self-deprecating"), not specific jokes they made
- Store sentence PATTERNS (e.g., "mixes 5-word punches with 25-word builds"), not specific sentences to echo
- Exception: codified frameworks (named methods, branded models) ARE included — those are reusable intellectual tools
- If a quote from their writing appears in the template, it should be labeled as EXAMPLE/EVIDENCE, not as an instruction to reuse
