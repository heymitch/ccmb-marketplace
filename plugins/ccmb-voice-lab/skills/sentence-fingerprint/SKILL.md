---
name: sentence-fingerprint
description: Map your sentence patterns — length, structure, rhythm — and create a Sentence Style Guide. Say "analyze my sentences", "sentence fingerprint", or "map my writing rhythm".
---

# Sentence Fingerprint

## Purpose

Map sentence patterns across length, structure, rhythm, and syntax to create a Sentence Style Guide. Ensures AI writing matches the writer's natural cadence and sentence construction patterns.

## Flow

1. Read writing samples from `voice/` — use any `.md` files present as the sample set
2. If no samples: "I need some of your writing to map your rhythm. Paste something or point me to it?"
3. Analyze across five dimensions:

   **Length** — Count words per sentence. Find the average, range, and preferred zone. "You tend to write 8-15 word sentences with punchy 3-5 word kickers for emphasis."

   **Structure** — Simple, compound, complex sentences. What's the mix? "You're 40% simple, 35% compound — you like keeping things clean."

   **Beginnings** — How do sentences start? Subject-first? "But" and "And" starters? Questions? "You start 25% of your sentences with 'But' — that's a real stylistic choice, not a mistake."

   **Transitions** — Which connector words show up? How often? "You almost never write 'however' — you use 'but' instead. That's more conversational."

   **Rhythm** — Paragraph length, question frequency, command structures. "Your paragraphs are 1-3 sentences max. Short. Punchy. Easy to scan."

4. Build a Sentence Style Guide with specific numbers and examples
5. Present it: "Here's how your sentences move — think of this as the sheet music for your writing."
6. On approval, save to `voice/analysis/sentence-fingerprint.md`

## Rules

- Base everything on actual sentence counts from the samples — not estimates
- Always include specific examples from their text as evidence
- If they have a distinctive pattern (like starting sentences with "And"), call it out positively
- Note when patterns change by content type (tweets vs. newsletters)
- The Style Guide should be specific enough that AI can follow it mechanically
