---
name: mimic-and-modify
description: Test and refine your Voice Template with iterative writing tests. Say "test my voice template", "mimic and modify", or "does this sound like me".
---

# Mimic and Modify

The moment of truth — write something using the Voice Template and see if it actually sounds like them. This is where the template gets battle-tested and refined.

## Flow

**1. Load Voice Template**
Read from `voice/voice-template.md`. If missing, prompt for Voice Template generation.

**2. Accept Topic**
Query for writing topic. Prefer topics with user opinion or regular publication history.

**3. Accept Format**
Query for content format (tweet, LinkedIn post, newsletter, email, etc.). Use format types writer actively publishes.

**4. Generate**
Write 150-250 words using Voice Template. Apply template attributes throughout.

**5. Request Feedback**
Present generated content. Request evaluation against voice authenticity. Capture feedback on tone, word choice, sentence structure, or style elements.

**6. Analyze Feedback**
Map feedback to Voice Template components:
- Tone issues → adjust tone grid position
- Vocabulary issues → update Power/Avoid/Replacement Words
- Humor issues → adjust Quirk Quotient
- Sentence issues → update Sentence Fingerprint
- Voice attributes → update Voice DNA

**7. Apply Modifications**
Update Voice Template elements based on feedback. Regenerate content.

**8. Iterate**
Accept feedback up to 5 rounds. After 5 rounds, recommend deeper analysis (additional samples, archetype re-analysis).

**9. Save**
Save refined template to `voice/voice-template.md` with modification timestamp and feedback notes.

## Rules
- Generate content in formats user actively publishes (not generic paragraphs)
- Accept all feedback without pushback
- Display exact template modifications after each iteration
- Halt when user indicates satisfaction
- Cap at 5 iterations per test cycle
- After 5 iterations, recommend deeper analysis instead of additional rounds
