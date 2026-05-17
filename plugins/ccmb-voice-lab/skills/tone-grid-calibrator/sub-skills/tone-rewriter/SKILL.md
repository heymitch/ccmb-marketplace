---
name: tone-rewriter
description: Rewrite text at specific Tone Grid coordinates to explore different tonal positions. Sub-skill of tone-grid-calibrator.
user-invocable: false
---

# Tone Rewriter

## Overview

Rewrites text at specified coordinates on the Tone Grid, allowing writers to explore how the same content lands in different tonal positions (Playful, Laid Back, Snappy, Polished).

Invoked by **tone-grid-calibrator** or explicitly via tone grid experimentation workflows.

## Flow

1. Receive text to rewrite (from active draft, clipboard, or provided)
2. Receive target coordinates as either:
   - **Explicit values:** Feel (1-10), Attitude (1-10)
   - **Preset:** Playful | Laid Back | Snappy/Punchy | Polished
3. Rewrite the text maintaining meaning while shifting tone to target:
   - **Playful (2, 2):** Loose structure, humor, conversational asides
   - **Laid Back (2, 8):** Conversational but professional, no snark
   - **Snappy/Punchy (8, 2):** Tight sentences, irreverent edge, attitude
   - **Polished (8, 8):** Engineered structure, zero humor, formal
4. Present rewrite with annotation showing specific changes (structure, word choice, punctuation)
5. Optionally generate multiple coordinate versions for comparison
6. User selects which version to keep or blends elements

## Rules

- Preserve core meaning and message intent across all rewrites
- Changes must be tonal only — never alter facts, data, or primary claims
- Show exactly what changed: sentence structure, word swaps, punctuation decisions
- Each rewrite should be genuinely different, not minor tweaks
- Never rewrite to an extreme that breaks the message (e.g., Polished version of dark humor becomes hollow)
- Presets are defaults — user can fine-tune with exact coordinates

## Output

- **Original text** with tone coordinates labeled
- **Rewritten text** at target coordinates
- **Change annotation:** Specific shifts in structure, language, tone
- **Optional:** 2-4 alternative versions at different coordinates for comparison
- **Explanation:** Why these changes move the tone on both axes
