# Email Nurture

A Claude plugin that builds multi-email sequences with two arcs:

- **Research-nurture** — convert lead-magnet opt-ins into booked 1:1
  conversations (interviews, calls, demos).
- **FOMO sales** — convert an email list into product/service purchases using
  the proven Ship 30 for 30 7-email framework ($3M+ in revenue).

Its signature move is the **grounding pass**: polished, on-voice, AI-clean
copy can still be wrong because it contradicts the product it describes or
because its proof is fabricated. This skill forces a diff against the
source-of-truth artifact and HOLDs unverified proof before anything ships.

## Install

1. Open Claude → **Customize** → **Personal Plugins**
2. Click **Add Plugin (+)** → **Upload Plugin**
3. Upload `email-nurture.zip`
4. The `/email-nurture` command and the auto-triggering skill are now available

## Usage

```
/email-nurture write a 7-email FOMO sequence to sell my course before the cohort opens
/email-nurture nurture my quiz opt-ins into 1:1 interviews about their results
```

Or just say a trigger phrase in conversation and the skill activates.

### Trigger phrases

- "write a nurture sequence" · "warm-lead nurture" · "drip to get interviews"
- "quiz-to-interview sequence" · "turn opt-ins into conversations"
- "follow up on my quiz / lead magnet"
- "write a FOMO / launch sequence" · "sell my course/product to my email list"
- "pre-launch email campaign"

## Scope boundary

**What it does:** genre-lock preflight (picks the arc) → angle/skeleton →
draft (verbatim FOMO templates or research-nurture formulas) → AI-pattern
cleanse → grounding pass against the product artifact → no-hallucination HOLD
shells → arc-appropriate companion artifacts → KIT-ready markdown bundle with
a status table. Nothing auto-sends.

**What it explicitly does NOT do:**

- **Quiz / lead-magnet creation** — designing the quiz, archetypes, or scoring
  is a separate skill. This one *consumes* an existing artifact.
- **Standalone generic copywriting** — a single thought-leadership essay, a
  landing/sales page, or a paid ad is a separate skill. Email *sales
  sequences* (FOMO) ARE in scope.
- **Dashboard implementation** — emits the measurement *spec* only. A separate
  skill/tool builds the actual dashboard.
- **Line-level AI-pattern editing** — it *calls* the separate `ai-hunter`
  skill; it does not reimplement detection.

## What's inside

```
email-nurture/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── email-nurture.md              # /email-nurture command
├── skills/
│   └── email-nurture/
│       ├── SKILL.md                  # orchestrator: 8-phase workflow,
│       │                             # two-arc selection, anti-patterns
│       ├── references/
│       │   ├── playbook.md           # research-nurture arc + canonical
│       │   │                         # copy formulas + frontmatter schema
│       │   ├── fomo-campaign.md      # Ship 30 philosophy + 7-email
│       │   │                         # strategy + 5 subject-line rules
│       │   └── patterns.md           # AI cleanse, grounding pass, HOLD
│       │                             # pattern, companion artifact specs
│       └── assets/
│           └── fomo-email-templates.md  # 7 verbatim fill-in FOMO templates
└── README.md
```

This follows the official Claude skill anatomy: `SKILL.md` at the root of the
skill, context-loaded docs under `references/`, and fill-in output templates
under `assets/`. Progressive disclosure means SKILL.md stays lean and the
heavy reference/template content loads only when the relevant arc is selected.

## The one lesson this teaches

An email can pass voice review **and** AI-detection **and** still be wrong —
because it contradicts the actual product or fabricates its proof. A B+ email
that is grounded beats an A email that lies. Always diff the copy against the
artifact it describes, and never fabricate a testimonial or anecdote to make
an email look finished — HOLD it instead.

## License

Personal / purchaser use only. Not for redistribution.

Author: Mitch Harris · mitch@ship30for30.com
