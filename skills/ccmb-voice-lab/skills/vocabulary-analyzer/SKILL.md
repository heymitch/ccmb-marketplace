---
name: vocabulary-analyzer
description: Audit your vocabulary and create Power Words, Avoid Words, and Replacement Words lists for consistent voice. Say "analyze my vocabulary", "update my word lists", or "vocabulary audit".
---

# Vocabulary Analyzer

## Purpose

Audit writing vocabulary and create Power Words, Avoid Words, and Replacement Words lists for consistent AI-assisted writing. Ensures AI uses the writer's actual vocabulary instead of default AI patterns.

## Flow

1. Read writing samples from `voice/` — use any `.md` files present as the sample set
2. If no samples: "I need to see your actual writing to find your vocabulary patterns. Want to paste something?"
3. Analyze all samples for:
   - Words you reach for repeatedly (3+ times per 1000 words)
   - Unique phrases that are distinctly yours
   - Industry jargon you use naturally
   - Words you conspicuously avoid
4. Build three lists:
   - **Power Words** (10-15): "These are YOUR words — the ones that show up again and again. They're part of your signature."
   - **Avoid Words** (10-15): "These are words to cut. Some are AI-tells (game-changer, supercharge, delve), some are just filler you don't need."
   - **Replacement Words** (5-10 pairs): "Instead of [this], you'd actually say [that]."
5. Present the lists with examples from their writing: "See how you used 'leverage' three times in that LinkedIn post? That's a Power Word."
6. Format as AI instructions they can paste anywhere
7. On approval, save to `voice/analysis/vocabulary-lists.md`

## Rules

- Power Words must come FROM their writing — don't suggest words they've never used
- Avoid Words need evidence — don't ban words they actually like
- Always include AI-tell words found in their samples (gently: "You might not realize it, but 'crucial' shows up a lot — that's an AI fingerprint word")
- Replacement pairs should feel natural to THEM, not to a thesaurus
- If unsure about a word, ask: "Do you actually like using 'implement' or does it just show up?"
