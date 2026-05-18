# Free Tool Playbook — Scoring Design, Data Model, Funnel Copy

Load this when designing the instrument (workflow steps 2–5 and 9).

---

## 1. The Ungameable Scoring Framework

### 1.1 Positive-framing rule (non-negotiable)

Every answer option must be the **mature, defensible expression of its own
result tier**. Test each option: *"Would a thoughtful person who genuinely
holds this position pick this and feel seen?"* If any option reads as the
obvious "right" or "wrong" choice, rewrite it. There are no troll answers.

This is what makes the data trustworthy *and* the result shareable.

### 1.2 Item architecture

- **N scoring dimensions** (e.g. 5). Each dimension gets **2 items**.
- Each item presents **one option per result tier** (e.g. 5 tiers → 5
  options). Every option is tier-coded.
- Plus **one dedicated drift/gaming-gate item** that does not vote for a
  tier — it only detects the domain's known failure mode.
- Typical total: `2 × dimensions + 1`. (Origin session: 5 dims → 11 items.)

### 1.3 The grade emerges from the pattern

```
primaryTier      = plurality of tier-coded answers across scoring items
coherence        = (count of primary-tier answers) / (scoring items)
dimensionBreadth = (dimensions where ≥1 answer matched primary) / (dimensions)
monocultureFlag  = coherence >= 0.9
driftFlag        = drift-gate item == the drift option
```

### 1.4 Grade lookup table (v1 — tunable per tool)

| coherence | dimensionBreadth | monoculture | drift | Grade |
|-----------|------------------|-------------|-------|-------|
| < 0.30 | — | — | — | **F** |
| 0.30–0.49 | — | — | — | **D** |
| ≥ 0.90 | any | yes | — | **B** (monoculture cap) |
| 0.70–0.89 | ≥ 0.80 | no | yes (own-tier) | **B** (drift cap) |
| 0.70–0.89 | ≥ 0.80 | no | no | **A** |
| 0.50–0.69 | ≥ 0.60 | no | no | **B** |
| 0.50–0.69 | any | — | yes | **C** |
| else | — | — | — | **C** |

**Why the caps exist:**
- *Monoculture cap* — a perfectly clean cluster means the respondent either
  gamed it or holds an unexamined position. Either way it's not an A.
- *Drift cap* — the respondent's pattern is coherent but they tripped the
  domain's known failure mode; cap with a respectful, specific caveat (not a
  punishment — a flag).

### 1.5 Dimension sub-grades (for the breakdown panel)

Per dimension (2 items):
- both match primary tier → **A**
- one matches → **B**
- neither matches but both share a consistent secondary tier → **C**
- the two items pick different non-primary tiers → **D**

### 1.6 The drift/gaming gate

Pick the **one belief or input that, if held, undermines the whole tier
system** for this domain. Make it a standalone item with options that are all
defensible — but one option is the drift signal. When tripped:

- If the respondent's primary tier is the one most prone to that drift →
  cap grade + show the strong, specific caveat.
- Any other tier → show the soft, general caveat, no cap.
- Not tripped → no caveat.

The caveat is **respectful and educational**, never a gotcha. It names the
failure mode, says why it matters, and points to 2–3 resources.

---

## 2. Result-Page Anatomy

In order, top to bottom:

1. **Chapter mark / eyebrow** — tiny label, "Your result."
2. **The shareable claim** — the tier name at display scale. This is the
   thing they screenshot.
3. **Grade row** — letter + tiny "grade" label.
4. **Tagline** — one italic line: who this person is.
5. **Narrative** — 2 short paragraphs: the tier shell + the grade-specific
   delta.
6. **Drift caveat** — only if tripped; quoted/aside style.
7. **Breakdown** — dimension sub-grades as a hairline table.
8. **What's next** — 3 items: a practice, a reading, a tool-or-absence.
9. **Funnel block** — see §4.
10. **Share affordance** — screenshot-friendly; OG image optional.

Ship all tier × grade copy as **flagged stubs** (e.g. `[NEEDS_VOICE_REVIEW]`).
Voice redline is a separate concern. Copy assembly = shell + grade-delta +
optional caveat, so you author `tiers + (tiers × grades) + caveats`, not a
bespoke page per combination.

---

## 3. Research-Instrument Data Model

**Design the editorial cross-tabs you want to publish BEFORE the schema.**
Then the schema falls out. Minimum three tables (extend the lead-magnet
skill's storage; follow its conventions):

```
<tool>_submissions   one row per completion
  id (server-gen uuid), created_at, session_id,
  responses jsonb, computed jsonb (tier, grade, coherence, flags,
  dimensionGrades), referrer, user_agent_hash

<tool>_contacts      email opt-ins, linked to submission
  id, created_at, submission_id -> submissions(id),
  email, name, role, <segment flags>,
  <tier-1 opt-in>, <tier-2 opt-in>, <list opt-in>,
  consent_to_outreach (true on submit)

<tool>_events        funnel telemetry
  id, session_id, event_type, created_at, metadata jsonb
```

Splitting submissions vs contacts keeps **every endpoint a pure INSERT** — no
UPDATE policies, simpler RLS. Index on the computed tier + grade for editorial
queries. Code patterns for the RLS/PostgREST mechanics: `PATTERNS.md`.

---

## 4. Funnel + Consent Copy (canonical template)

Fill the brackets. **Do not reword the consent contract** — its precision is
the point.

**Headline:** `Willing to talk about this further?`

**Body:** `[ORG] is [WHAT YOU PUBLISH/DO]. I'd love to [THE ASK — e.g.
interview you for 15–30 minutes about your position]. [LOCAL PERK, optional —
e.g. "If you're in [PLACE] — coffee's on me."]`

**Consent block (verbatim — only swap [bracketed] terms):**

> **What we'll do with your information:** We use it to reach out to you
> about this conversation — nothing else. We will **never** publish, quote,
> or attribute your [tool] responses or anything you share without your
> explicit, written permission. If you choose to be featured later, that's a
> separate conversation we'll have with you directly.

**Tiered opt-ins (none pre-checked):**
- ☐ **[Primary ask]** — the highest-intent conversion
- ☐ **Notify me when [future product] is ready** — demand signal
- ☐ **Add me to the [list]** — lowest-friction

**Conversion hierarchy:** primary ask → future-product notify → list →
anonymous share. Deliver the primary-ask payoff (scheduling link, etc.) in
the success state, gated on the primary checkbox.

---

## 5. Spec / PRD skeleton (keep short)

- **Purpose & funnel intent** (priority-ordered: leads, editorial data,
  demand signal, list)
- **Instrument design** (tiers, dimensions, item count, ungameable rule,
  drift gate)
- **Scoring** (formulas + grade table from §1)
- **Result-page anatomy** (§2)
- **Funnel + consent** (§4)
- **Data model** (§3) + the editorial cross-tabs you intend to publish
- **Out of scope** (storage setup, design system, deploy, voice) with the
  sibling-skill pointer for each
- **Open questions** → resolve to a decisions log before building
