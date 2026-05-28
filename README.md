# Claude Code Marketing Bootcamp — Plugin Marketplace

One plugin, everything included. The complete marketing-funnel toolkit (28 skills) — landing pages, lead magnets, free tools, lead research, email nurture, analytics dashboards, Voice Lab, campaign planning, an install shield, plus the power-tools **Skyscraper** (pre-build research), **Funnel Hack** (competitor teardown), and **Browser Monkey** (no-API analytics).

## Install

In Claude Code (or the Code tab in Claude Desktop):

```
/plugin marketplace add heymitch/ccmb-marketplace
/plugin install claude-code-marketing-bootcamp@ccmb-marketplace
```

That's it — one install, all 28 skills. Then just tell Claude what you want:

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
| `safe-install` | "safely install \<package\>" | npm/CLI shield — publish-date checks, CVE lookups, version pinning. Auto-active via the bundled `safe-npm` once enabled. |

### Power-tools (now bundled in)

| Skill | Just say… | Does |
|---|---|---|
| `skyscraper` (+ 5 scout sub-skills) · `/skyscraper-setup` | "scan for existing solutions" | Fans out parallel scouts across native skills / Apify / Reddit / YouTube *before* you build something custom — the cheapest tool is the one you didn't have to build |
| `funnel-hack` | "funnel-hack [competitor]" | Reverse-engineers a competitor's funnel and adapts it to *your* brand (reads your mission / voice / ICP / offers first). Pairs with Skyscraper |
| `monkey` · `sniffer` · `replay` | "pull my Substack stats into the dashboard" | Browser Monkey — no-API analytics. Sniff a site's API surface once, replay at fetch() speed with your logged-in session, write to Supabase, save as a slash command. **Scope guard: no-API + not-anti-bot + your own account only — never point it at LinkedIn.** |

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

This refreshes the marketplace listing **in place** — do NOT remove and re-add (that creates a duplicate marketplace entry). Backwards-compatible fixes ship straight to `main`; breaking changes bump the plugin version.

---

*Maintainers: see [`MAINTAINERS.md`](./MAINTAINERS.md) for the campaign-status kill-switch, the consolidated single-plugin layout, and the release checklist.*
