---
name: voice-dna-extractor
description: Extract your Voice DNA from writing samples — the core voice + style attributes that define how you write. Say "extract my voice DNA", "analyze my writing voice", or "what's my voice DNA".
---

# Voice DNA Extractor

The core analysis. Reads writing samples and pulls out the unique fingerprint of how someone writes — both what they say (voice) and how they say it (style).

## Flow

**1. Check for Existing DNA**
If `voice/analysis/voice-dna.md` exists: read it and offer update option.

**2. Gather Samples**
Delegate to sample-gatherer sub-skill. If samples were already collected (running inside the full pipeline), skip this — read from `voice/` instead.

**3. Extract Voice Attributes**
Analyze each sample for up to 10 voice attributes (personality traits evident in writing):
- Conversational vs formal tone
- Humor usage and patterns
- First/second/third person perspective
- Reader relationship approach
- Authority level and expertise signaling

Quote text evidence to SHOW the user what you found — but mark these as evidence, not instructions. The compiled Voice DNA should describe PATTERNS (e.g., "conversational, uses direct address, breaks fourth wall"), not store quotes for reuse. One-off creative metaphors and topic-specific imagery belong to the original piece — don't carry them into the profile as things to repeat.

**4. Merge Voice Attributes**
Deduplicate and consolidate voice patterns across all samples. Present core voice profile.

**5. Analyze Writing Style**
Perform style analysis on technical dimensions:
1. **Word Choice** — formal vs casual, jargon level, sophistication
2. **Sentence Structure** — simple vs complex, structural variety
3. **Rhythm and Pacing** — tempo variation across passages
4. **Point of View** — first/second/third person usage and consistency
5. **Figurative Language** — metaphor and analogy SOURCE DOMAINS (e.g., "draws from tech, cooking, sports"), NOT specific metaphors to reuse
6. **Imagery** — sensory and emotional language PATTERNS, not specific images to recycle

**6. Merge Style Attributes**
Consolidate style patterns across all samples.

**7. Compile Voice DNA**
Create structured Voice DNA document with voice attributes and style analysis sections.

**8. Save**
On user approval, save to `voice/analysis/voice-dna.md` with timestamp.

## Rules
- Minimum 3 samples. If they only have 2, encourage a third: "One more would really help me nail this."
- Quote their actual writing as evidence — don't just list traits abstractly
- Find what's DISTINCTIVE first, then what's common. The interesting stuff is what sets them apart.
- Never invent traits that aren't in the samples
- If the samples are all very different in tone (e.g., one formal report, one casual email), note that — it's useful data about their range
