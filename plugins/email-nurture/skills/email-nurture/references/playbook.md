# PLAYBOOK — Canonical copy formulas

Load this when drafting. Fill brackets, never reword the formulas.

## Preflight summary format

Produce this verbatim shape before drafting. If any line is `[unknown]`, ask.

```
Genre: [genre tag, e.g. research-nurture sequence (warm-lead → conversation)]
Reference: [PLAYBOOK.md research-nurture arc OR a named past sequence]
Touches: [single-touch per email | AM main + PM bump on which days]
Must-include: [the ask], [sync/async format], [booking link], [secondary
              opt-in if any], [audience-appropriate framing]
Conversion bar: [number or comparison, e.g. 8-15% of opt-ins book]
```

## The five preflight questions (canonical — do not reword)

1. **Genre tag** — name the genre in plain language. Each genre has its own
   structural skeleton. Research-nurture ≠ DR launch ≠ thought-leadership.
2. **Reference template** — point to a known-good past example of the same
   genre. Pattern-match it, don't blank-page it.
3. **Touch count** — single-touch or multi-touch (AM main + PM bump)?
4. **Info architecture** — what info MUST be in the email. "Soft pitch" means
   the CTA shape is soft, NOT that information is withheld. The reader who
   opens only one email needs that one to be complete.
5. **Conversion bar** — the bar this email must clear, numeric or comparative.
   Without it you optimize prose quality, which is the wrong metric.

## The research-nurture arc (canonical 5-email skeleton)

A descent from public to personal. The last email converts; the early ones
earn the right to ask.

| # | Day | Role | Angle | CTA shape |
|---|---|---|---|---|
| 1 | 0 | Warm + acknowledge | Their result as a snapshot, not a verdict. Plant the ask in the P.S., not the headline. | Soft reply + buried booking link |
| 2 | 3 | Pattern + reduce isolation | Show them the shape of everyone else's results. Honor every category. | Forward / share + buried booking link |
| 3 | 7 | Depth + reframe | Elevate the lead magnet from poll to diagnostic. First headline-level ask. | Book the conversation |
| 4 | 12 | Concrete proof | One specific moment from a real prior conversation. Demystifies the format. **Often a HOLD until a real moment exists.** | Book the conversation |
| 5 | 18 | Direct + vulnerable | The mask comes off: here's what I'm actually doing and why your voice matters. Both formats explicit. | Book OR async reply |

Adjust count/cadence to the user's inputs. Keep the descent shape.

## Email frontmatter schema (canonical — every email file gets this)

```yaml
---
sequence: [sequence name]
email_number: [N]
send_day: [days after email 1 delivery; 0 for the trigger email]
trigger: [enrollment trigger or "N days after Email X delivery"]
status: [READY TO LOAD | HOLD — DO NOT LOAD | READY (caveat: ...)]
primary_cta: [one CTA]
secondary_cta: [optional, P.S. only]
segment: [who gets it / who skips]
revision_note: [optional — why this differs from an earlier draft]
hold_reason: [required iff status is HOLD]
---
```

Body sections per email, in order: subject line options (2-3), preview text,
purpose (one sentence), body copy, primary CTA, secondary CTA (if any),
pre-send check (any placeholders/claims to verify), notes for KIT setup
(trigger, tokens, exit condition).

## Subject + preview rules

- 2-3 subject options per email, varied: curiosity / benefit / personal-reply
  style / question. Under ~50 chars where possible.
- The right A/B winner for a warm sequence is often **reply rate**, not open
  rate. A clickbait subject lifts opens and suppresses warmth. Say so.
- Preview text (40-90 chars) complements the subject, never repeats it.

## P.S. patterns that work in research-nurture

- **Buried booking link** (emails 1-2): "If you'd rather talk it through,
  grab [N] minutes: [link]. Sync or async, however works."
- **Qualitative social proof** (final email): name a *feeling* prior
  interviewees reported, not a number, unless the number is real and honest.
- **Soften-for-first-wave note**: any line implying prior conversations
  ("the men who've said yes so far") is false on the first send. Carry a
  pre-send instruction to soften until N real conversations exist.

## Companion: conversation-prep doc structure

Sent on booking or async reply. Dual intro.

- **Intro A (async)** — "answer the ones that draw you in, skip the rest,
  voice memo or written, 15-30 min, send back when ready."
- **Intro B (sync prep)** — "you don't need to prepare answers; these are
  here so it doesn't feel like an ambush."
- **Section 0 (placeholder until a real transcript exists)** — "If you're
  worried about this being adversarial" + link to a permissioned sample
  transcript. Stays inactive until `transcripts/` has one.
- **Section 1 — Your result** — list every product category as the strong
  form of a real position. Then: what did it get right / wrong / how long
  have you been here.
- **Section 2 — Per-category questions** — one question block per archetype.
  Always include "the temptation specific to your archetype you've felt in
  yourself."
- **Section 3 — Everyone** — wished-for conversation, certainty/uncertainty,
  what would change your mind, who asks different questions than you.
- **Section 4 — Practice not theology** — what it looks like in your week,
  where you've declined to use it, what you'd protect.
- **Section 5 — The one that matters most** — "What's the thing you've been
  wanting to say out loud and haven't found the right room to say it in?"
- **Attribution** — three reversible options: full / first-name+context /
  anonymous. Nothing published stronger than their day-before-publication
  comfort level.

## Tone law

Every category the product sorts people into is the strong form of a real
position. None is the wrong answer. If the rhetoric only works by quietly
demoting some categories, the rhetoric is wrong, not the categories.
