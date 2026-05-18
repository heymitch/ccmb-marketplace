# Claude Code Marketing Bootcamp — Plugin Marketplace

Everything you build in the bootcamp ships as a Claude Code plugin. Install the marketplace once, install the plugins you need, then just tell Claude what you want — it runs the right skill.

## Install

In Claude Code (or the Code tab in Claude Desktop):

```
/plugin marketplace add heymitch/ccmb-marketplace
```

Then install any plugin:

```
/plugin install landing-page-builder@ccmb-marketplace
```

Then **just say what you want** — Claude picks the right skill from the plugin automatically:

```
build my landing page
```

That's the loop: add the marketplace, install a plugin, tell Claude what to do.

> **On slash commands:** plugin skills are namespaced as `/<plugin>:<skill>` (e.g. `/landing-page-builder:landing-page`) — there's no bare `/landing-page`. You rarely need the slash form; natural language is the intended way to invoke these. The slash is the explicit escape hatch when you want to force a specific skill.

## The six core plugins

These are the assets you build across the bootcamp's six sessions. Install them as you go, or all at once.

| Plugin | Just say… | What it builds |
|---|---|---|
| `landing-page-builder` | "build my landing page" | A high-converting landing or sales page — offer stack, 11-section copy structure, 15-question FAQ, distinctive design, deployed to a live Vercel URL. |
| `lead-magnet-launch-system` | "build my lead magnet" | A complete lead magnet funnel — idea, name, mockup, landing copy, onboarding sequence, promo email, the asset itself, opt-in wired and delivering. |
| `free-tool` | "build a free tool" / "make a quiz" | A deployable lead-magnet mini-app — quiz, calculator, assessment, or diagnostic — engineered ungameable and shareable with a tiered opt-in funnel. |
| `lead-research` | "enrich my lead list" | An opt-in list enriched into a confidence-rated CSV — org, role, contact, LinkedIn/X, and a one-sentence personalized opener per lead. |
| `email-nurture` | "build my nurture sequence" | Multi-email nurture sequences — research-nurture (book 1:1s) or FOMO sales (convert a list), with AI-pattern cleanse and a no-hallucination grounding pass. |
| `marketing-dashboard-kit` | "build my marketing dashboard" | A password-protected analytics dashboard — Supabase data layer, your design system, deployed behind auth on Vercel. |

Install all six:

```
/plugin install landing-page-builder@ccmb-marketplace
/plugin install lead-magnet-launch-system@ccmb-marketplace
/plugin install free-tool@ccmb-marketplace
/plugin install lead-research@ccmb-marketplace
/plugin install email-nurture@ccmb-marketplace
/plugin install marketing-dashboard-kit@ccmb-marketplace
```

### How they map to the bootcamp sessions

The plugins are named for what they do, not what session they're in — so you can reuse them on any campaign forever. For reference, the bootcamp covers them in this order:

- **Session 1** → `landing-page-builder`
- **Session 2** → `lead-magnet-launch-system`
- **Session 3** → `free-tool`
- **Session 4** → `lead-research`
- **Session 5** → `email-nurture`
- **Session 6** → `marketing-dashboard-kit`

## The four bonus plugins

| Plugin | Just say… | What it does |
|---|---|---|
| `voice-lab` | "train my voice" | Trains Claude Code to write in your voice. Outputs a Voice Template every content plugin reads automatically. |
| `campaign-brainstorm` | "brainstorm a launch" | Dual-mode launch-campaign brief generator. Produces a structured brief downstream plugins consume. |
| `skyscraper` | "scan for existing solutions" | Scans for existing solutions (native skills, Apify, Reddit, YouTube) before you vibe-code something from scratch. Run `/skyscraper:skyscraper-setup` once after install. |
| `safe-install` | "safely install \<package\>" | A safety shield for `npm` / CLI installs — publish-date checks, CVE lookups, version pinning. Recommended before any package install. |

```
/plugin install voice-lab@ccmb-marketplace
/plugin install campaign-brainstorm@ccmb-marketplace
/plugin install skyscraper@ccmb-marketplace
/plugin install safe-install@ccmb-marketplace
```

## Recommended order

1. `safe-install` — install first so every later package install is shielded
2. `voice-lab` — train your voice before you generate any copy
3. `landing-page-builder` → `lead-magnet-launch-system` → `free-tool` → `lead-research` → `email-nurture` → `marketing-dashboard-kit` — the funnel, in build order
4. `campaign-brainstorm` — when you're ready to run a full launch
5. `skyscraper` — any time you're about to build something custom

## Requirements

- Claude Desktop (Code tab) or Claude Code CLI
- A Vercel account connected as a Claude connector (deploys)
- A Supabase account (used by `free-tool` and `marketing-dashboard-kit`)
- An email service provider — Kit (ConvertKit) is canonical; Substack and others are supported as adapters

Pre-work for each session walks you through any account setup before you need it.

## Updating

```
/plugin marketplace update ccmb-marketplace
```

Pulls the latest version of every plugin. Backwards-compatible fixes ship straight to `main`; breaking changes bump the plugin version.

---

*Maintainers: see [`MAINTAINERS.md`](./MAINTAINERS.md) for the campaign-status kill-switch, versioning policy, and release process.*
