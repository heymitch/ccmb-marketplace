---
name: quirk-injector
description: Identify your writing quirks — humor style, metaphor patterns, backstory references — and codify them for AI. Say "find my quirks", "quirk quotient", or "what makes my writing unique".
---

# Quirk Injector

## Purpose

Identify and codify writing quirks — humor style, metaphor patterns, backstory references — that make writing distinctive and personally recognizable.

## Flow

1. Read writing samples from `voice/` — use any `.md` files present as the sample set
2. Analyze samples across three angles:

   **Humor** — What's their brand of funny?
   - Dry wit, sarcasm, self-deprecating, dad jokes, F-bombs, dark humor, or none
   - Find 2-3 actual examples from their text
   - Note frequency: every paragraph, every post, rarely?
   - "Your humor is mostly dry wit — like when you wrote '[actual quote].' That's very you."

   **Metaphors & Analogies** — What DOMAIN do they draw comparisons from?
   - Sports, cooking, tech, war, nature, pop culture, business, other?
   - Identify the source domain, not specific metaphors to reuse. "You draw from tech" is the insight — not "use 'defragging your brain' in future writing."
   - Quote examples as evidence to show the user, but the profile should capture the DOMAIN (e.g., "tech metaphors"), not the specific phrases. A creative metaphor belongs to the piece it was written for.

   **Backstory** — What personal experiences keep showing up?
   - Geographic roots, career moments, hobbies, family, education
   - Find examples of personal stories in samples
   - "You reference growing up in [place] a lot — that grounds your writing."

3. If the samples don't show enough signal, ask directly — but warmly:
   - "I'm not seeing much humor in these samples. Is that because these are more formal, or do you tend to keep things straight?"
   - "What world do your metaphors come from? When you explain something complicated, what do you compare it to?"
   - "What personal stories do you lean on? The ones that keep showing up?"

4. Compile the Quirk Quotient profile with specific AI instructions for each quirk
5. Present it: "These are the things that make your writing feel like YOU and not anyone else."
6. On approval, save to `voice/analysis/quirk-quotient.md`

## Rules

- Every quirk must come from evidence in the samples or direct user input
- Never invent quirks — if the writing is straightforward with no humor, say so (that's data too)
- If they don't like a detected quirk, move it to the "avoid" list
- Rank metaphor domains by actual frequency, not assumed importance
- Quirk instructions must be specific enough for AI to act on: "Draw from cooking when explaining complex processes" not just "be funny"
- But NEVER include specific creative metaphors as reusable instructions. "Draws from cartography/exploration" is a pattern. "Here be dragons" is a one-time creative choice — don't recycle it.
- Exception: codified frameworks (named methods, branded processes) ARE reusable — those are intellectual tools, not one-off imagery
- Ask about quirks they WANT to develop, not just ones that exist: "Any quirks you wish showed up more?"
