---
name: free-tool-builder
description: >-
  Build a Free Tool — a deployable lead-magnet mini-app (quiz, calculator,
  assessment, or diagnostic) engineered as an ungameable, shareable research
  instrument with a tiered opt-in funnel. Trigger when the user says "build a
  free tool", "make a lead-magnet quiz", "build a calculator/assessment",
  "create a diagnostic funnel", "design an archetype quiz", "build an
  ungameable quiz", or wants a small interactive giveaway that converts
  visitors into qualified leads. Builds ON existing Supabase+SQL storage from
  the lead-magnet skill — run that FIRST. NOT for storage/Supabase/schema
  setup (see the lead-magnet skill). NOT for creating a design system —
  inherits the workspace's existing design tokens. NOT for deploy mechanics
  (Vercel/git-PR) or brand-voice copy editing — those are separate concerns.
---

# Free Tool Builder

A **Free Tool** is a small interactive giveaway — quiz, calculator,
assessment, diagnostic — that is secretly three things at once:

1. A **shareable result** the user wants to post (the lead magnet).
2. An **ungameable research instrument** (clean data, because there are no
   obvious "right" answers).
3. A **tiered opt-in funnel** (interview / future-product / list), gated by
   an explicit outreach-only consent contract.

If it's only a quiz, you built a toy. The job is all three.

## Dependency & scope (read first)

- **RUN THE LEAD-MAGNET SKILL FIRST.** It provisions Supabase + SQL storage
  and the base funnel. This skill *builds the instrument on top* and follows
  that storage's conventions. If no storage exists yet, stop and run the
  lead-magnet skill.
- **Inherit the design system. Never create one.** The workspace already has
  design tokens (colors, type, spacing). Detect them and consume them. The
  single biggest failure in the origin session was a stylesheet that
  re-declared `:root` tokens instead of inheriting — it caused both a visual
  mismatch and a hidden path bug. See `PATTERNS.md` → "Inherit, never
  re-declare."
- **Out of scope, by design:** storage/schema setup (lead-magnet skill),
  visual identity (workspace tokens), deploy mechanics, brand-voice redline.
  Ship copy as flagged stubs for later voice review.

## The workflow

Follow in order. Each step has a deliverable.

| # | Step | Deliverable |
|---|------|-------------|
| 1 | **Frame the instrument** | Tool type + what the result *says about the person* (the shareable claim) |
| 2 | **Design result tiers** | The archetypes/bands/score-ranges + what each means |
| 3 | **Write the ungameable item set** | Questions/inputs where every option is attractive (see Law below) |
| 4 | **Design the scoring** | Pattern-coherence grade + gaming/drift gate (see `PLAYBOOK.md`) |
| 5 | **Spec + PRD + phased plan** | Short docs; data model designed for editorial cross-tabs from day one |
| 6 | **TDD the scoring core** | Pure function, no DOM/fetch, unit-tested before any UI |
| 7 | **Build UI on inherited tokens** | Static-first; detect & consume workspace design system |
| 8 | **Wire to existing storage** | Anon-INSERT-only tables following lead-magnet conventions |
| 9 | **Funnel + consent** | Tiered opt-ins under an outreach-only consent block |
| 10 | **Ship + smoke test live** | Deploy via the workspace's existing pipeline; verify end-to-end |

Steps 1–4 are the craft. Steps 6–10 are execution and reuse `PATTERNS.md`.

## Tool-type → result mechanic

| Tool type | Result mechanic | Grade/score source |
|-----------|-----------------|--------------------|
| **Typing quiz** | 1-of-N archetype + letter grade | Plurality archetype + cross-question coherence |
| **Assessment** | Readiness band (A–F or tier) | Weighted dimension sub-scores → composite |
| **Calculator** | A number + interpretation band | Formula output mapped to narrative bands |
| **Diagnostic** | Strength/gap map | Per-dimension pass/gap + a headline verdict |

All four use the same **funnel + consent + research-instrument** spine. Only
the result mechanic differs.

## The Ungameable Law (the one teachable nugget)

> **Make every option attractive within its own tier. Grade the *pattern*,
> not the answers.**

A spiritual-gifts-style quiz where the "good" answers are obvious destroys
both data quality and shareability. Invert it:

- Every option is the *mature, defensible* expression of its tier. No troll
  options, no obviously-wrong answers.
- The grade emerges from **cross-item coherence** (did the pattern cluster?),
  not from individual choices.
- A **monoculture cap**: a too-clean cluster (e.g. ≥90% one tier) signals an
  unexamined/gamed response → cap the grade.
- A dedicated **drift/gaming gate** item detects the known failure mode for
  the domain and caps the grade with an explicit, respectful caveat.

Full formulas and the grade lookup table: `PLAYBOOK.md`.

## Anti-patterns (from the origin session — do not repeat)

- **Re-declaring design tokens.** A local `:root` override desynced the tool
  from the site AND masked a routing bug. Inherit tokens; never redeclare.
- **Relative fetch paths in a rewritten route.** `fetch('./content.json')`
  breaks when the page is served at `/tool` vs `/tool/`. Use
  `new URL('...', import.meta.url)`. (`PATTERNS.md`)
- **`Prefer: return=representation` on an insert-only table.** It forces a
  SELECT through RLS and fails. Generate the UUID server-side and use
  `return=minimal`. (`PATTERNS.md`)
- **Floating the tool with no site chrome.** A centered card in an empty
  viewport reads as a standalone document, not a page of the site. Inherit
  the site's nav + footer for "balance."
- **Designing the data model after the UI.** Decide the editorial cross-tabs
  you want to publish *first*; the schema falls out of that. (`PLAYBOOK.md`)
- **Troll answers / obvious best options.** Kills the research instrument.
  See the Ungameable Law.
- **Building scoring inside the view layer.** Keep scoring a pure,
  separately-tested module. UI changes must never risk the grade logic.

## References

- `PLAYBOOK.md` — canonical scoring-design formulas, the grade lookup table,
  the research-instrument data model, and the verbatim outreach-only consent
  + funnel copy template. Load when designing Steps 2–5 & 9.
- `PATTERNS.md` — reusable code patterns: pure scoring engine shape + TDD,
  anon-INSERT-only RLS + PostgREST `return=minimal`, `import.meta.url` fetch
  resolution, inherit-tokens rule, static-first wiring. Load for Steps 6–10.
