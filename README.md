# Claude Code Marketing Bootcamp — Plugin Marketplace

One plugin. 24 skills. The complete marketing-funnel toolkit you build across the bootcamp, plus Voice Lab, campaign planning, and a supply-chain install shield — all under a single install.

## Install

In Claude Code (or the Code tab in Claude Desktop):

```
/plugin marketplace add heymitch/ccmb-marketplace
/plugin install claude-code-marketing-bootcamp@ccmb-marketplace
```

That's it. One plugin, everything included. Then just tell Claude what you want:

```
build my landing page
```

Claude picks the right skill automatically. No slash commands to memorize.

> **On slash commands:** plugin skills are namespaced as `/claude-code-marketing-bootcamp:<skill>` (e.g. `/claude-code-marketing-bootcamp:landing-page`). You rarely need the slash form — natural language is the intended way to invoke these. The slash is the explicit escape hatch when you want to force a specific skill.

## What's inside

### The funnel (six bootcamp sessions)

| Skill | Just say… | Builds |
|---|---|---|
| `landing-page` (+ `frontend-design`) | "build my landing page" | High-converting landing/sales page — offer stack, 11-section copy, 15-question FAQ, distinctive design, live Vercel URL |
| `lead-magnet` | "build my lead magnet" | Full lead-magnet funnel — idea → asset → opt-in wired and delivering |
| `free-tool-builder` | "build a free tool" / "make a quiz" | Deployable quiz/calculator/assessment with a tiered opt-in funnel |
| `lead-research` | "enrich my lead list" | Opt-in list → confidence-rated CSV with org/role/contact + personalized openers |
| `email-nurture` | "build my nurture sequence" | Research-nurture or FOMO-sales sequences, AI-pattern cleansed, grounded against your source-of-truth |
| `build-dashboard-ui`, `dashboard-data-layer`, `deploy-gated-site`, `discover-connectors`, `supabase-sql` | "build my marketing dashboard" | Password-protected analytics dashboard — Supabase data layer, your design system, deployed behind auth |

**Session map:** S1 → `landing-page` · S2 → `lead-magnet` · S3 → `free-tool-builder` · S4 → `lead-research` · S5 → `email-nurture` · S6 → the five `dashboard`/`deploy`/`supabase` skills.

### Voice Lab (10 skills)

`voice-training` (orchestrator) · `voice-dna-extractor` · `archetype-analyzer` · `vocabulary-analyzer` · `sentence-fingerprint` · `quirk-injector` · `tone-grid-calibrator` · `mimic-and-modify` · `voice-template-compiler` · `voice-tutor`

Say "train my voice" — produces a Voice Template every content skill reads automatically.

### Operator skills

| Skill | Just say… | Does |
|---|---|---|
| `campaign-brainstorm` | "brainstorm a launch" | Dual-mode campaign brief generator; output feeds the funnel skills |
| `skyscraper` | "scan for existing solutions" | On-demand: checks native skills / Apify / Reddit / YouTube before you build something from scratch. Run it when you're about to build a custom tool. `/claude-code-marketing-bootcamp:skyscraper-setup` shows which optional API keys are active. |
| `safe-install` | "safely install \<package\>" | npm/CLI shield — publish-date checks, CVE lookups, version pinning. Auto-active via the bundled `safe-npm` once enabled. |

## Requirements

- Claude Desktop (Code tab) or Claude Code CLI
- A Vercel account connected as a Claude connector (deploys)
- A Supabase account (used by `free-tool-builder` and the dashboard skills)
- An email service provider — Kit (ConvertKit) canonical; Substack and others as adapters

Each session's pre-work walks you through account setup before you need it.

## Updating

```
/plugin marketplace update ccmb-marketplace
```

Backwards-compatible fixes ship straight to `main`; breaking changes bump the plugin version.

---

*Maintainers: see [`MAINTAINERS.md`](./MAINTAINERS.md) for the campaign-status kill-switch, the consolidated-plugin layout, and the release checklist.*
