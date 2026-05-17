# CCMB Marketplace

Official Claude Code **plugin marketplace** for the **Claude Code Marketing Bootcamp**.

Students add the marketplace once, then install any plugin by name.

## Install

```
/plugin marketplace add heymitch/ccmb-marketplace
/plugin install <plugin-name>@ccmb-marketplace
```

List everything available:

```
/plugin marketplace list
```

## Plugins

All plugins live unzipped under `plugins/` and are registered in
`.claude-plugin/marketplace.json`.

### Session plugins

| Plugin | What it does |
|---|---|
| `lead-magnet-launch-system` | Idea → name → mockup → landing copy → onboarding → built, wired, delivered |
| `landing-page-builder` | Offer stack → 11-section LTO copy → 15-Q FAQ → designed layout → live Vercel URL |
| `free-tool` | Build a deployable lead-magnet mini-app (quiz, calculator, etc.) |
| `lead-research` | Enrich opt-in lead lists into a confidence-rated, prioritized list |
| `email-nurture` | Multi-email nurture sequences — research-nurture and re-engagement arcs |
| `marketing-dashboard-kit` | Password-protected marketing analytics dashboard, end to end |

### LP factory stack

| Plugin | Step |
|---|---|
| `ccmb-lp-design` | 1 — reusable brand design system (tokens + components), cached |
| `ccmb-lp-copy` | 2 — conversion copy as `copy.json` via PAS/AIDA/StoryBrand/Hormozi/Schwartz |
| `ccmb-lp-build` | 3 — scaffold + deploy to Vercel; auto-chains design → copy → build |
| `ccmb-landing-page` | Single-shot alternative — design + copy + build in one pass |

### Utilities

| Plugin | What it does |
|---|---|
| `ccmb-headline-writer` | 10 headline variations (mechanism + objection patterns, not just outcome) |
| `ccmb-sentence-editor` | Tighten copy — strip hedging, AI-detection tells, jargon |
| `ccmb-lead-enrichment` | Cascade enrichment of an existing list, free public sources only |

### Tool packages (multi-skill)

| Plugin | What it does |
|---|---|
| `ccmb-safe-install` | npm/CLI install shield — date quarantine, CVE lookup, hook defang |
| `ccmb-skyscraper` | Pre-flight scan (native skills / Apify / Reddit / YouTube) before vibe-coding |
| `ccmb-voice-lab` | 10-skill voice training (Cole / Bush *Digital Writers Voice Lab*) |

## Repo structure

```
.claude-plugin/
  marketplace.json          ← marketplace manifest (16 plugins)
plugins/
  <plugin>/
    .claude-plugin/plugin.json
    skills/ | commands/ | bin/ | references/ ...
sessions/
  session-1/instructions.md ← live-session bundle (still raw-fetched at runtime)
references/
  vibe-editing.md           ← cross-cutting cheat sheet
campaign-status.json        ← live policy signal for ccmb-safe-install
```

## Still raw-fetched at runtime (not via /plugin)

Two things deliberately stay file-fetched and are **not** installed as plugins:

- **`sessions/session-N/instructions.md`** — the live-session trigger prompts
  fetch these via `raw.githubusercontent.com/heymitch/ccmb-marketplace/main/sessions/...`.
- **`campaign-status.json`** — the `ccmb-safe-install` shield reads this from the
  repo root on every invocation. Flip `campaign_active` to `false` to relax every
  student's shield globally; append to `recent_compromises` to hard-block a bad
  version; add to `pinned_packages` to force a version.
  URL: `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json`

## ⚠️ Migration note (v1.0.0 — native marketplace conversion)

This repo was converted from a raw-fetch skill host into a native plugin
marketplace. **Loose skill paths moved:**
`skills/<name>/SKILL.md` → `plugins/<name>/skills/<name>/SKILL.md`.

Any old raw URL pointing at `…/main/skills/…` now 404s. The CCMB project's
session-1 trigger prompt and the LP-factory install paste must be updated to
either (a) instruct `/plugin install …@ccmb-marketplace`, or (b) point at the
new `plugins/<name>/skills/<name>/SKILL.md` paths. `sessions/` and
`campaign-status.json` paths are unchanged and still resolve.

## Versioning

Per-plugin `version` lives in each `plugins/<name>/.claude-plugin/plugin.json`
and is mirrored in `marketplace.json`. See `CHANGELOG.md`.
