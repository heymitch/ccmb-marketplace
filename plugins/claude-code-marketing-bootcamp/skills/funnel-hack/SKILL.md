---
name: funnel-hack
description: >-
  Use when asked to funnel-hack, reverse-engineer, or do a competitor teardown
  of another creator or business — estimate their traffic, map their funnel and
  offer ladder, figure out posting cadence and topics, estimate conversion rates
  and revenue, and find how many people sign up per month. Triggers on "funnel
  hack X", "reverse-engineer X's business", "analyze a competitor", "teardown
  their offer", "how does X make money", "what's their content strategy". Reads
  the working dir's CLAUDE.md/business config to tailor the adaptation to YOUR
  brand. NOT for enriching your own opt-in leads — that is the lead-research
  sibling. NOT for ideating your own campaign from scratch — that is
  campaign-brainstorm. NOT for building the content/landing pages the teardown
  inspires — those are separate sibling skills.
---

# Funnel Hack

Reverse-engineer a competitor's business from public signals, then turn it into a move *you* can run.

The durable output is **two artifacts**:

1. **`FUNNEL-HACK.md`** — the reverse-engineered machine: traffic engine, offer ladder, funnel map, conversion + revenue estimates, **growth velocity (signups/month)**, and vulnerabilities.
2. **`ADAPT-TO-<brand>.md`** — what to steal, where to differentiate, and ready-to-fire content ideas, snapped to the operator's own brand read from their workspace config.

A teardown that stops at "here's what they do" is half-finished. The value is the adaptation.

## When this applies

- "Funnel hack `<person/company>`" / "reverse-engineer their business"
- "Analyze a competitor": their traffic, funnel, offers, cadence, topics, CTAs
- "How does `<creator>` actually make money?" / "estimate their revenue and conversion"
- "What's `<creator>`'s content strategy across platforms?"
- "How fast is `<competitor>` growing / how many sign up a month?"

## When this does NOT apply (route elsewhere)

| Request | Not here — belongs to |
|---|---|
| Enrich *my own* opt-in list into a contacts CSV | `lead-research` |
| Brainstorm my own campaign / content angles from scratch | `campaign-brainstorm` |
| Actually build the landing page / lead magnet / emails | `landing-page` / `lead-magnet` / `email-nurture` |
| Scan existing solutions before *I* build a product | `skyscraper` |

This skill targets **someone else's** business and stops at intel + an adaptation playbook. It never sends anything and never publishes.

## Workflow (orchestrator)

```
0. CONFIG     → read the working dir's CLAUDE.md / AGENTS.md / business config; learn YOUR brand (mission, voice, ICP, offer ladder, content system). Absent → ask 3 quick Qs or use neutral defaults. This steers Step 6.
1. SCOPE      → confirm the target; one quick search to lock their footprint (handles, primary offer, platforms). Create output dir: <workspace>/competitor-intel/<target-slug>/
2. DISPATCH   → 4 parallel research agents, one per arm, in ONE message (verbatim contracts in PLAYBOOK.md). Each writes one file. Velocity is a first-class arm, never skipped.
3. VERIFY     → confirm all 4 arm files exist on disk and are non-empty. Trust agent summaries; never read their transcript files.
4. RECONCILE  → cross-check numbers across arms; keep RANGES with honest error bars. Label every estimate (est.). Show arithmetic for conversion/revenue.
5. SYNTHESIZE → write FUNNEL-HACK.md (master report) referencing the 4 arm files. Use REPORT-TEMPLATE.md.
6. ADAPT      → write ADAPT-TO-<brand>.md: steal / differentiate / content ideas, each snapped to the Step-0 brand config (voice, offers, values).
7. PATTERN    → flag repeatable mechanics + the single best next move for the operator.
```

### Naming & dispatch conventions

- **`<workspace>`** = the directory the skill is invoked from (the operator's `pwd` / repo root). Never the plugin dir.
- **`<target-slug>`** = the target's name lowercased, spaces → hyphens, non-alphanumerics stripped (e.g. "Liam Ottley" → `liam-ottley`, "Acme & Co." → `acme-co`).
- **`<brand>`** in `ADAPT-TO-<brand>.md` = the operator's brand name from Step-0 config, slugified the same way. If the config has a mission but no explicit brand name, derive a short slug from the mission or fall back to `ADAPT-TO-operator.md` and say so.
- **Dispatch** = the harness's parallel-agent mechanism (Task / Agent tool), one agent per arm, all in a single message. Use a research-capable general agent per arm; reserve the heavier model for the synthesis you do yourself in Steps 5–6.

### Step 0 — Working-dir config (steers the adaptation)

The skill runs in the operator's folder, so its `CLAUDE.md` is already in context. Read it (and any `AGENTS.md` or business/brand config it points to) FIRST, and honor pointers to:

- **Mission / positioning** → the lens for "differentiate" in Step 6.
- **Voice / banned words** → so content ideas come out in their voice, draft-ready.
- **ICP / audience** → to judge whether the target shares their audience (direct vs adjacent competitor).
- **Offer ladder / products** → to spot which gaps in the target's funnel the operator can already fill.
- **Content / distribution system** → if they have a named repurposing engine, frame the adapted plan around it.

This config is the **operator's**, kept in their folder — never inside the plugin — so marketplace updates can't overwrite it, and the same skill works for any brand that installs it. If `CLAUDE.md` points to nothing usable, ask at most 3 quick questions (mission, who you serve, your offers) or fall back to neutral defaults and say so.

### The four research arms

| Arm | Question it answers | Output file |
|---|---|---|
| **Traffic engine** | What drives attention? (primary platform stats, cadence, topics, hooks, CTAs) | `01-engine.md` |
| **Offer ladder + funnel** | How do they make money? (every rung, prices, funnel map, conversion + revenue estimate) | `02-offer-funnel.md` |
| **Cross-platform footprint** | Where else do they publish, and how does it feed the funnel? | `03-platforms.md` |
| **Growth velocity** | How FAST is it growing? (signups/month, sub growth/month — the flow rates) | `04-velocity.md` |

Read **`PLAYBOOK.md`** before Step 2 (verbatim agent contracts + synthesis rules) and **`REPORT-TEMPLATE.md`** before Step 5 (output skeleton).

## Anti-patterns (learned the hard way — do not repeat)

1. **Totals without velocity.** The #1 lesson. A member count tells you where they *are*; "~36K new free members/month" tells you how fast the engine *pumps* and whether it's accelerating or saturating. A teardown only becomes actionable at the velocity layer. Always compute flow rates via Wayback-Machine diffs (member counts across dated snapshots) and Social Blade / SocialCounts (sub growth). Never ship totals alone.
2. **Generic adaptation.** Skipping Step 0 makes the playbook default to bland "post more, build a list" advice. Always snap steal/differentiate/content-ideas to the operator's real mission, voice, and offer ladder.
3. **False precision.** Competitor numbers vary by source and snapshot date. Present ranges with honest error bars, label every estimate `(est.)`, and show the arithmetic behind conversion and revenue figures. A confident wrong number destroys the report's credibility.
4. **Hardcoding a brand.** Never bake a specific operator's brand into the skill. Read it from the working dir every run.
5. **Reading agent transcript files.** Never `cat`/`tail` a sub-agent's JSONL output — it overflows context. Trust the completion summary and verify the output file exists.
6. **Single-threaded research.** The 4 arms are independent. Dispatch all 4 in one message so they run concurrently; serial dispatch is ~4x slower for zero benefit.
7. **Treating a direct competitor as adjacent.** Check whether the target shares the operator's tools and audience. A same-lane competitor changes the entire adaptation (it's now a positioning fight, not a borrow).
8. **Publishing the teardown without permission.** The output is intel. Turning it into content is a separate, explicit decision the operator makes.

## Definition of done

- Four arm files on disk, each non-empty, velocity included.
- `FUNNEL-HACK.md`: TL;DR, velocity read, reconciled numbers (ranges + `(est.)`), funnel map, vulnerabilities, sources.
- `ADAPT-TO-<brand>.md`: steal / differentiate / content ideas, each tied to the Step-0 brand config (or an explicit note that config was absent and defaults were used).
- A one-paragraph report to the operator: the machine in a sentence, the headline velocity numbers, the single biggest vulnerability, and the one best next move.
