# FAQ Generator

Generates the FAQ section (page-structure.md, section 10). The job of a sales-page FAQ is not documentation — every answer clarifies the question *and* moves the reader one step closer to buying.

## Inputs (pull from `landing-page-brief.md`)

Use what's already collected — do not re-ask the user:
- Product name, **format** (self-paced course / cohort / template bundle / asset / etc.), price
- Main problems solved, main benefits/outcomes
- Target audience avatar
- The 3 biggest mistakes (objections field)
- Everything included (features/modules/templates/assets)
- Instructor bio + credibility milestones
- Guarantee terms (default 14-day, no-questions)

If `format` isn't in config, ask only that one thing — it drives half the logistical questions.

## What to generate

**15 questions**, written in the customer's voice, covering both categories:

1. **Logistical** (how it works) — examples to adapt, not copy verbatim:
   - Self-paced or cohort? How long to go through it?
   - How/when do I get access? Lifetime access or time-limited?
   - What format are the materials (video, written, templates)?
   - Do I need any tools/software/budget to use this?
   - Will this be updated? Do I get updates free?
   - Can my team/business use it too?

2. **Buying objections** (will this work for *me*) — derive these from the avatar and the 3 mistakes:
   - "Will this work if I'm a [beginner / advanced / specific situation]?"
   - "I've tried [common alternative] and it didn't work — how is this different?"
   - "I don't have much time — how much do I need?"
   - "Is this worth $[price]? What's the ROI?"
   - "What if it doesn't work for me?" (route to the guarantee)
   - "Why should I learn this from you?" (route to bio/milestones — real proof only)
   - "Can't I just find this free online / from AI?"
   - "Is now the right time, or should I wait?"

Aim for roughly a 6/9 split (logistical / objection); objections are where the sale is won.

## Answer rules

- **Clarify, then convert.** First sentence answers the literal question. The rest reframes toward the purchase — without hype.
- **Turn objections into reasons to buy.** "I'm a beginner" → name exactly where the product meets a beginner and the first win they'll get.
- **Route, don't repeat.** Risk questions point to the Guarantee section; authority questions use the real milestones from config. Never restate a whole other section.
- **Real proof only.** No invented stats, names, or outcomes. If a milestone isn't in config, don't manufacture one.
- **Match the format.** A cohort and a template bundle get different logistical answers — use the actual `format` value.
- Closed em-dashes (`word—word`). Direct, no throat-clearing, no "Great question!".
- One tight paragraph per answer. The strongest objection-handlers end on a forward nudge, not a hedge.

## Output

Show the 15 Q&As grouped (Logistical first, then Objections) for approval before they go into the page schema's `faq.items[]`. Iterate on any the user flags, then hand the approved set to `frontend-design` with the rest of the page.
