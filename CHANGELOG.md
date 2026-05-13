# Changelog

All notable changes to the CCMB Marketplace.

## [0.3.0] — 2026-05-13

S4 lead enrichment — no-vendor-lock-in alternative to Apollo. Waterfall scraping/lookup across free public sources (WebSearch + GitHub + public APIs + About pages), ICP-tuned via playbook library.

### Added
- `skills/ccmb-lead-enrichment/SKILL.md` — takes existing list (CSV/paste/LI export), enriches each row by waterfalling public sources, scores against ICP, outputs ranked CSV. Same downstream contract as v2 S4 spec — `lib/lead-research.ts` scoring engine unchanged.
- `skills/ccmb-lead-enrichment/references/waterfall-playbooks.md` — 5 default ICP playbooks (developer-founder, b2b-saas-founder, creator-thought-leader, service-provider-consultant, generic-fallback). Each = ICP keyword triggers → ordered source list. Power users add custom playbooks at `~/.ccmb-lp/playbooks/`.
- `skills/ccmb-lead-enrichment/references/parsing-rules.md` — handles 6 input formats: CSV w/ headers, markdown table, LinkedIn Connections export, plain comma-separated paste, prose paste (LLM-extracted), names-only paste. Normalizes to internal `RawProspect` shape before waterfall.

### Architecture notes
- **Tier 1 only for cohort 1.** Tier 2 (Cloudflare Worker browser-rendering proxy) and Tier 3 (Apify Store actors) documented as post-cohort upgrade paths but not shipped.
- **No LinkedIn scraping ever.** When LI URL is encountered, written to output for manual click-through; never crawled. TOS-clean, ban-risk-minimal.
- **No third-party transmission of student lists.** Skill calls public sources for individual lookups only; never bulk-submits to any external service.
- **ICP-aware waterfall** — when student pivots offer, re-run against same list, get a completely different ranking from completely different signals. The list compounds across pivots.

### Replaces
- The Apollo OAuth path from v2 S4 spec (now stale — see `~/.claude/projects/-Users-heymitch-speakeasy-agent/memory/feedback-ccmb-s4-enrichment-not-apollo.md`).

## [0.2.0] — 2026-05-13

LP factory stack — three-skill split-architecture for reusable design across pages.

### Added
- `skills/ccmb-lp-design/SKILL.md` — Claude Design system generator. 4-5 question interview → `~/.ccmb-lp/design-tokens.json` + `design-system.md` + `preview.html` + `component-shapes.md`. Cached user-global so subsequent pages reuse the brand.
- `skills/ccmb-lp-copy/SKILL.md` — conversion copy generator. 6-question interview → framework selection (PAS / AIDA / StoryBrand / Hormozi / Schwartz) → `copy.json`. Three quality gates: specificity, sign-your-name standard, framework integrity.
- `skills/ccmb-lp-copy/references/` — bundled domain knowledge:
  - `frameworks.md` — full structures of all 5 frameworks + picker table
  - `copy-patterns.md` — 25 headline formulas, hero shapes, CTA patterns, benefits/social-proof/FAQ section formulas
  - `voice-rules.md` — em-dash style, hype kill list (~30 banned words/phrases), directness rules, sign-your-name standard, AI-pattern flags
  - `swipe-file.md` — 6 annotated high-converting LPs with structural moves called out
- `skills/ccmb-lp-build/SKILL.md` — orchestrator. Reads cached artifacts + scaffolds Next.js + applies inherited mobile/perf rules + deploys to Vercel. Auto-chains `/ccmb-lp-design` and `/ccmb-lp-copy` if their artifacts are missing — blank folder + single `/ccmb-lp-build` prompt → live page in 14-22 min.

### Changed
- README: added two-paths section (monolith vs factory stack) + install instructions for the factory stack.

### Rationale
- Existing `ccmb-landing-page` is monolithic — design choices, copy, and build happen in one pass. Great for one-offs, but every new page repeats the design interview.
- The factory stack separates concerns so the design step caches and subsequent pages get ~10 min faster.
- The `ccmb-lp-copy` references folder is the load-bearing addition — explicit conversion frameworks with bundled swipe files, instead of relying on generic LLM "write me good copy" output.
- `ccmb-lp-build` inherits the 10 mobile rules + 6 perf rules from `ccmb-landing-page` by reference (no duplication) — codify loop applied cross-skill.

## [0.1.0] — 2026-05-12

Initial scaffold for cohort 1.

### Added
- Session 1: instructions bundle + landing-page generator skill, with mobile + perf defaults baked in (10 mobile rules + 6 perf rules extracted from `heymitch/ccmb-landing`).
- `ccmb-headline-writer` and `ccmb-sentence-editor` skill stubs (full implementations pending).
- `references/vibe-editing.md` — cross-cutting cheat sheet linked from every session.
