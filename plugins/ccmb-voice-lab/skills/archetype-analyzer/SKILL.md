---
name: archetype-analyzer
description: Profile your writing against the 5 Voice Archetypes and discover your unique voice mix. Say "analyze my archetypes", "what's my voice mix", or "voice archetype analysis".
---

# Archetype Analyzer

## The 5 Archetypes

1. **The Storyteller** — dates, times, locations, real-life examples. "In 1999..." / "The first time I..."
2. **The Opinionater** — strong conviction, emphasis. "There's a reason why..." / "It's unbelievable how..."
3. **The Fact Presenter** — stats, studies, research to back up claims
4. **The Frameworker** — actionable frameworks, how-tos, checklists. "A Proven Process..." / "A Simple Checklist..."
5. **The F-Bomber** — abrasive, cursing, ranting, sarcasm

## Flow

1. Read writing samples from `voice/` — use any `.md` files present as the sample set
2. If no samples: "I need some of your writing to work with. Want to paste something, or should we pull samples first?"
3. Analyze each sample against all 5 archetypes. Find specific phrases that match each type.
4. Calculate the voice mix — percentage breakdown across all 5 (must sum to 100%)
5. Present with genuine interest: "Here's what I'm seeing — you're [X]% Frameworker, [Y]% Storyteller, with a little Opinionater mixed in. That means when you write, you tend to lead with actionable stuff but bring it to life with personal stories. That's a strong combo."
6. Show the evidence — actual quotes from their writing mapped to each archetype
7. Save to `voice/analysis/archetype-mix.md`

## Rules

- Percentages must be backed by actual markers found in the text — not vibes
- Show evidence for EVERY archetype they score above 10%
- The voice mix description should feel like a discovery: "Oh interesting, you're more Storyteller than you probably think"
- Don't force F-Bomber to 0% just because there's no profanity — sarcasm and rants count
- If multiple samples show different mixes, note the range: "You shift more toward Opinion in your LinkedIn posts vs. your emails"
