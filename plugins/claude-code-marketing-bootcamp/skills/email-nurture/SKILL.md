---
name: email-nurture
description: >-
  Use when the user wants to "write a nurture sequence", "email sequence to
  book calls", "warm-lead nurture", "drip to get interviews", "quiz-to-interview
  sequence", "recruit interviewees from my lead magnet", "turn opt-ins into
  conversations", "follow up on my quiz/lead magnet", "write a FOMO/launch
  sequence", "sell my course/product to my email list", or "pre-launch email
  campaign". Builds a multi-email sequence whose conversion event is either a
  booked 1:1 conversation (research-nurture arc) OR a product/service purchase
  (Ship 30 FOMO sales arc), plus companion artifacts, shipped as KIT-ready
  markdown. Survives three gates: voice, AI-pattern detection, and factual
  alignment with the actual product. NOT for creating the quiz or lead magnet
  itself (separate skill). NOT for standalone generic copywriting — single
  thought-leadership essays, landing/sales pages, or paid ads (separate skill);
  email sales sequences ARE in scope. NOT for implementing the dashboard — this
  produces the measurement SPEC only, a separate skill/tool builds it.
---

# Email Nurture

Turn an email list into booked conversations or product sales with a sequence
that survives three independent gates: voice, AI-pattern detection, and
**factual alignment with the actual product**.

The differentiator is the **grounding pass**. Polished, on-voice, AI-clean
copy can still be wrong because it contradicts the product it describes, or
because its proof is fabricated. This workflow forces a diff against the
source-of-truth artifact, and HOLDs any unverified proof, before anything ships.

## Two arcs, one skill

The genre-lock preflight (Phase 0) selects which arc to deploy:

| Arc | Conversion event | Default | Reference |
|---|---|---|---|
| **Research-nurture** | A booked 1:1 conversation (interview, call) | 5 emails / 18 days, soft, ask buried late | `references/playbook.md` |
| **FOMO sales** | A digital product / service purchase | 7 emails / ~7-day pre-launch window, direct, education-led | `references/fomo-campaign.md` + `assets/fomo-email-templates.md` |

Both arcs share Phase 4 (AI cleanse), Phase 5 (grounding pass), Phase 6 (HOLD),
Phase 7 (companions where relevant), Phase 8 (packaging), and the subject-line
rules in `references/fomo-campaign.md` Module #4.

## When to use vs. not

| Situation | This skill? |
|---|---|
| "Nurture sequence to get interviews from my quiz takers" | ✅ Research-nurture arc |
| "Drip so opt-ins book a call / demo" | ✅ Research-nurture arc |
| "7-email FOMO campaign to sell my course before the cohort" | ✅ FOMO sales arc |
| "Pre-launch email sequence for my digital product" | ✅ FOMO sales arc |
| "Follow-up sequence after someone downloads my lead magnet" | ✅ Either arc, per goal |
| "Design the quiz / archetypes / scoring itself" | ❌ Separate skill (lead-magnet creation) |
| "Write one thought-leadership essay / a landing page / a Meta ad" | ❌ Separate skill (generic copywriting) |
| "Build the marketing dashboard" | ❌ Out — emits the SPEC; a separate tool builds it |
| "Just clean the AI tells out of this paragraph" | ❌ Call the `ai-hunter` skill directly |

## Workflow

Run these phases in order. Do not skip Phase 0 or Phase 5.

### Phase 0 — Genre-lock preflight (HARD GATE)

Before drafting one word, lock the genre. Voice rules do NOT determine shape.
Answer these five (ask the user if unknown — do not extrapolate):

1. **Genre tag** — name it plainly, and pick the arc. Research-nurture
   (conversation CTA, soft) or FOMO sales (purchase CTA, direct)?
2. **Reference template** — `references/playbook.md` (research-nurture arc) OR
   `references/fomo-campaign.md` + `assets/fomo-email-templates.md` (FOMO arc),
   OR a past sequence the user names.
3. **Touch count** — single-touch per email unless the user wants AM/PM bumps.
4. **Info architecture** — what MUST be in. Research-nurture: the ask, format
   options, booking link. FOMO: full offer breakdown, price anchor, deadline,
   real proof. "Soft pitch" means the CTA shape is soft, NOT that information
   is withheld.
5. **Conversion bar** — a number or comparison. Research-nurture: e.g. "8-15%
   of opt-ins book". FOMO: e.g. "beat last launch's X% list-to-sale".

Produce a 5-line preflight summary and confirm before drafting. Format in
`references/playbook.md` → "Preflight summary format".

### Phase 1 — Inputs

Gather: goal, audience + lifecycle stage, the single conversion CTA, number of
emails (default per arc), cadence, brand voice source, booking/checkout
mechanism, and — critically — **the file path to the product's source-of-truth
artifact** (the quiz JSON, the offer/pricing doc, the real testimonials). If
there is no artifact to ground against, say so explicitly and flag every
product claim and every proof element as unverified.

### Phase 2 — Angle brainstorm + arc skeleton

- **Research-nurture:** map a descent from public to personal. The *last*
  email converts; early emails earn the right to ask. See
  `references/playbook.md` → "The research-nurture arc".
- **FOMO sales:** map the 7-email escalation — Transformation → Financial
  Outcomes → Price Anchor → Challenges/Benefits → Success Stories → In-Depth
  Case Study → Last Chance. See `references/fomo-campaign.md` Module #2 for the
  goal of each email.

State the arc, a one-line angle per email, and the escalation logic.

### Phase 3 — Draft each email

- **FOMO arc:** draft from the verbatim skeletons in
  `assets/fomo-email-templates.md`. Fill `{brackets}` only — never reword the
  structure. These are the $3M+ proven originals.
- **Research-nurture arc:** use the canonical formulas + frontmatter schema in
  `references/playbook.md`.

Both: one primary CTA per email; 2-3 subject options refined against the 5
subject-line rules (`references/fomo-campaign.md` Module #4); preview text
complements, never repeats, the subject.

### Phase 4 — AI-pattern cleanse

Run drafts through the `ai-hunter` skill (separate skill — call it, do not
reimplement). Zero tolerance for em-dashes. Kill repeated negative
parallelism, rule-of-three staccato, throat-clearing openers, formulaic hooks.
See `references/patterns.md` → "AI-pattern cleanse checklist".

**FOMO nuance:** the proven templates intentionally use em-dashes and
rule-of-three. When a brand has a strict AI bar, cleanse AFTER filling
brackets and surface the diff so the user chooses proven-original vs.
AI-clean per email. Do not silently overwrite the proven structure.

### Phase 5 — Grounding pass (HARD GATE — the whole point)

Diff every product claim and every proof element against the Phase 1 artifact:

- Every named category/archetype/feature/price in the copy exists in the
  artifact
- If the product sorts people into N buckets, the copy honors **all N** as the
  strong form of a real position — never collapse them for punchier rhetoric
- Every testimonial, customer name, count, and `{$X}` value is real and
  verifiable, or it gets HOLD'd
- Every implied prior event or deadline is true at send time or carries a
  soften-for-first-wave / set-the-real-date note

See `references/patterns.md` → "Grounding pass". Record a `revision_note` in
frontmatter when a draft changed because of this pass.

### Phase 6 — HOLD any data-dependent content

Any email or block needing a real anecdote, testimonial, case study, or
verifiable count does NOT get faked. Convert to a HOLD shell: `DO NOT SEND`
banner, structural beats preserved, a capture roadmap, `-HOLD` in the
filename. FOMO Emails 5 and 6 are almost always HOLD until real success
stories with written permission exist. See `references/patterns.md` → "The
HOLD pattern".

### Phase 7 — Companion artifacts

- **Research-nurture:** conversation-prep doc, notes-capture template,
  sample-transcript spec, measurement spec. See `references/playbook.md` and
  `references/patterns.md`.
- **FOMO sales:** an offer/proof inventory (what's real vs. HOLD), a
  post-purchase onboarding stub, and the measurement spec (list-to-sale,
  per-email CTR, revenue attribution, cart-open/close timing). Measurement is
  SPEC ONLY — do not build the dashboard.

### Phase 8 — Package

Single source, KIT-ready markdown. Each email a separate file
`email-N-day-N.md` (HOLD files keep `-HOLD`). Add a README status table so
load order and HOLD state are obvious. Document exit/suppression conditions
per file. For FOMO, document the cart-open/cart-close datetime each send keys
off. Do not auto-send anything.

## Anti-patterns (every one is a real mistake this skill canonicalizes against)

| Anti-pattern | Why it bit us | Do instead |
|---|---|---|
| Trusting ai-hunter + voice as a ship gate | A B+ voice-clean email invented a "3-group" framing when the real quiz had 5 archetypes | Phase 5 grounding pass against the artifact |
| Collapsing a product's taxonomy for rhetoric | The collapse quietly told 2 of 5 archetype-holders they were the wrong answer | Honor every bucket as the strong form of a real position |
| Faking proof to make an email "done" | A fabricated anecdote nearly shipped; FOMO Emails 5/6 are nothing but proof | HOLD shell + capture roadmap, `-HOLD` filename |
| AI-cleansing the proven FOMO templates silently | The Ship 30 originals earned $3M+ with em-dashes and rule-of-three intact | Cleanse after bracket-fill, surface the diff, let the user choose per email |
| Extrapolating voice → genre | Literary brand voice tempts essay shape when DR/research/FOMO shape was needed | Phase 0 genre-lock preflight |
| "Soft pitch" = withhold info | The reader who opens only one email needs it informationally complete | Soft = the CTA shape, not the info density |
| Leading the hardest ask first (research arc) | Trust compounds; the last email converts | Descent arc: public → personal, ask last |
| Subject line too long / headline-cased | Hook gets cut off; reads like an article not a friend | 5-15 words, sentence case, 1 of the 4 proven hooks |
| Shipping a sequence with no companion infra | A "book a call" CTA with no prep doc, or a sale with no onboarding, is a dead end | Phase 7 companion artifacts |
| Em-dashes anywhere (strict-bar brands) | Highest-frequency AI tell | Periods, commas, parens, restructure |

## Output contract

A bundle of: numbered email markdown files with frontmatter + a README status
table, companion artifacts from Phase 7, a preflight summary naming the arc, a
flow/escalation diagram with exit/suppression (and cart timing for FOMO), and
an A/B test plan. Nothing auto-sends. Every product claim and proof element is
either grounded or flagged/HELD.

## Reference map

- `references/playbook.md` — research-nurture arc, canonical copy formulas,
  frontmatter schema, conversation-prep doc structure, preflight format
- `references/fomo-campaign.md` — Ship 30 philosophy, the 7-email FOMO strategy
  (Module #2), and the 5 subject-line rules (Module #4)
- `assets/fomo-email-templates.md` — the 7 verbatim fill-in FOMO templates
  (Module #3); fill brackets, never reword
- `references/patterns.md` — AI-pattern cleanse checklist, the grounding pass,
  the HOLD pattern, companion artifact specs, packaging conventions
