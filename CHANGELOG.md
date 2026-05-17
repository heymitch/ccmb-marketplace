# Changelog

All notable changes to the CCMB Marketplace.

## [1.0.0] — 2026-05-16

Converted from a raw-fetch skill host into a **native Claude Code plugin marketplace**.

### Added
- `.claude-plugin/marketplace.json` at repo root — 16 plugins, validated with `claude plugin validate`.
- `plugins/` directory. Every plugin is an unzipped directory with its own `.claude-plugin/plugin.json`.
- 6 session plugins imported from the bootcamp build set: `lead-magnet-launch-system`, `landing-page-builder`, `free-tool`, `lead-research`, `email-nurture`, `marketing-dashboard-kit`.
- 7 former bare skills wrapped as installable plugins: `ccmb-headline-writer`, `ccmb-sentence-editor`, `ccmb-landing-page`, `ccmb-lp-design`, `ccmb-lp-copy`, `ccmb-lp-build`, `ccmb-lead-enrichment`.

### Changed
- `ccmb-safe-install`, `ccmb-skyscraper`, `ccmb-voice-lab` moved `skills/` → `plugins/`; their `plugin.json` `name` normalized to the directory name.
- Install path is now `/plugin marketplace add heymitch/ccmb-marketplace` then `/plugin install <name>@ccmb-marketplace`.

### Breaking
- Loose skill raw URLs (`…/main/skills/<name>/SKILL.md`) now 404 — content moved to `plugins/<name>/skills/<name>/SKILL.md`. The CCMB session-1 trigger prompt and LP-factory install paste must be updated.
- `sessions/`, `references/`, and `campaign-status.json` paths are unchanged and still raw-fetch correctly.

## [0.3.3] — 2026-05-13

Browser-use escalation for JS-rendered pages. Composes with `dev-browser` skill, `claude-in-chrome` MCP, or `computer-use` MCP — first available.

### Added
- **New §6.7: Browser-use escalation.** When WebFetch returns skeleton HTML on a high-value, eligible source, the cascade auto-escalates to a real-browser render. Detection rule: `useful_body_bytes < 500` AND source is in `BROWSER_USE_ELIGIBLE_SOURCES` AND row has ≥1 confirmed prior signal AND per-row time budget remaining > 20 sec.
- **Eligible sources documented:** SaaS About pages (works ~85%), YouTube channel pages (~70%, Social Blade static fallback if browser-use also fails), Crunchbase public profiles (~60%), Substack/Medium author pages (~80%), Notion-hosted sites (~65%).
- **Explicitly-banned sources documented:** LinkedIn (TOS + ban risk), Instagram (bot detection too aggressive), Twitter/X (bot detection), Facebook (login walls), any site with confirmed anti-bot WAF. Skill detects these and skips with `failure_reason: anti_bot_challenge_detected`.
- **Three extraction modes:** `text` (default, ~5-8 sec/row), `screenshot + transcribe` (when visual layout matters, ~10-15 sec/row), `inspect` (targeted DOM query, ~6-10 sec/row).
- **Cost guardrail:** if browser-use fires on >25% of rows, skill prints a warning suggesting the playbook is mismatched. Typical healthy run = ~5-15% browser-use rate.

### Composition
- `dev-browser` skill (preferred — already in CCMB ecosystem, standalone or extension mode)
- `mcp__claude-in-chrome__*` tools (second choice, requires Chrome extension)
- `mcp__computer-use__*` tools (last resort, slowest)
- None installed → graceful skip with `failure_reason: js_heavy_page_no_browser_tool`. **No browser tool is required** for cohort 1; the cascade still works on ~85% of rows that don't need JS rendering.

### Failure modes added
- `skeleton_html_browser_use_skipped` — WebFetch returned skeleton but row didn't meet escalation criteria.
- `browser_use_timeout` — browser tool blocked >30 sec, skill killed it.
- `anti_bot_challenge_detected` — Cloudflare/captcha page returned, skill detected and aborted.
- `login_wall_detected` — redirect to `/login` or password form, skill detected and aborted.
- `js_heavy_page_no_browser_tool` — no browser MCP/skill installed, escalation impossible.

### Cascade playbooks updated
- JS-heavy sources flagged with **🌐** marker in `cascade-playbooks.md`.
- B2B SaaS founder playbook: About page + Crunchbase public profile flagged eligible.
- Creator-thought-leader playbook: YouTube discovery flagged eligible + Social Blade static fallback documented.

### Architecture note
Browser-use is **escalation only, not default.** Most rows complete via WebFetch in <1 sec. Browser-use adds 5-15 sec per escalated row, which is fine for the ~5-15% of rows that need it but would tank the cascade time budget if applied universally. The detection heuristic + guardrail warning prevent it from running away.

## [0.3.2] — 2026-05-13

Three critical fixes from cold dry-run + email-list-first input surface.

### Critical fixes (from stress-test against "vintage typewriter restorers under 40 in Portland")

- **Signal enrichability audit (§4.5 of SKILL.md).** Before any source is queried, the skill now classifies each ICP signal as ENRICHABLE / INFERRABLE / UNENRICHABLE. Unenrichable signals (exact age, exact revenue, decision-authority) are explicitly flagged and dropped from scoring with user confirmation. **Prevents the worst silent failure mode** — student writes "under 40" in ICP, scoring engine has no data path, every row gets default value, student thinks they filtered when they didn't. Now: loud failure, user choice to drop the signal or rewrite the ICP.
- **Tighter playbook matching algorithm (§5).** Old spec was ambiguous on "≥2 keyword hits" — could silently use the wrong playbook on a single weak match (e.g., `service-provider-consultant` falsely matching "restorer"). New spec: cluster-based confidence (high ≥3, medium 2, low 1, none 0), ties trigger user disambiguation, low/none confidence offers skyscraper chain or fallback-with-warning. No more silent wrong-playbook runs.
- **`/research:youtube` composition pinned (§10).** The cascade no longer attempts to auto-dispatch the YouTube research command — it's a human-interactive command, blocks 5-10 min per dispatch. New behavior: cascade writes `leads/enrichment-followup-[date].md` listing high-value rows that would benefit from manual `/research:youtube` deep-dives, with the exact commands to run. Student dispatches after the cascade finishes, batched. Programmatic auto-dispatch deferred to cohort 2+ (would require refactoring `/research:youtube`).

### Added — email-list-first input surface

- **New §6.5: Email-first cascade.** When >50% of rows are email-shaped with missing name/company, the skill runs a 4-step pre-cascade: split `handle@domain`, resolve domain → company via About-page WebFetch, resolve handle → name via team-page cross-reference or WebSearch, hand off to playbook cascade with pre-populated identity. Personal email domains (gmail/yahoo/etc.) get a separate fallback path with handle analysis + direct WebSearch.
- **Apollo/ListKit/Cognism CSV imports recognized as legacy enriched data.** When detected by header pattern, the cascade *skips resolution steps* the CSV already answers and only enriches missing signals. **Migration story:** student kept their old Apollo export, cancelled the subscription, the skill works with what they already own. No vendor lock-in.
- **ESP subscriber exports (Kit/Mailchimp/MailerLite/ConvertKit) auto-detected** with tag + segmentation metadata preserved as intent signals.
- **S1/S2 funnel data importable** — student's own `/api/lead` captures and landing page submissions feed directly into enrichment as warm-lead inputs.
- **5 new formats documented in `parsing-rules.md`**: email-only, ESP exports, Apollo CSVs, ListKit/Cognism/Lusha CSVs, S1/S2 funnel data.

### Output schema changes

- New `failure_reason` column in main CSV (e.g., `name_too_common_no_business_anchor`, `email_domain_returned_no_about_page`, `rate_limited_mid_cascade:github`). Low-confidence rows now explain *why* without re-running.
- New optional output file: `leads/enrichment-followup-[date].md` — manual deep-dive commands for rows worth heavyweight follow-up.

### Architecture notes

- Execution flow expanded from 10 → 12 steps to fold in the audit (step 5) and email-first pre-cascade (step 8).
- Cascade now favors email-as-primary-key over name-as-primary-key for B2B rows, because email domain = company is the strongest possible firmographic signal available before any source is queried.
- Critical principle reinforced: **loud failure beats silent silent-default**. Every step that could fail silently now either prints a warning, asks user confirmation, or writes a `failure_reason` to the output.

## [0.3.1] — 2026-05-13

Cascade rename + skyscraper chaining + YouTube simplification.

### Changed
- **Renamed waterfall → cascade** across the enrichment skill. "Waterfall" is Clay-branded vocabulary; "cascade" is more distinctive and doesn't imply imitation. `references/waterfall-playbooks.md` → `references/cascade-playbooks.md` (git mv preserves history). Both "cascade enrichment" and "waterfall enrichment" remain trigger phrases so students using either word still hit the skill.
- **YouTube source mechanism changed.** Dropped the `YOUTUBE_API_KEY` requirement from the `creator-thought-leader` playbook. Replaced with WebSearch + WebFetch on the channel page for routine discovery (no API key, no setup friction). For deep transcript-level analysis on high-value rows, dispatches to `/research:youtube` (the existing competitor-research command) — only on explicit request, not per-row default.

### Added
- **`/skyscraper` chaining for novel archetypes.** When ICP doesn't match any default or custom playbook with confidence, enrichment skill offers to dispatch `/skyscraper "enrichment sources for [novel ICP shape]"`. Skyscraper's 4 scouts return ranked existing patterns; enrichment skill synthesizes a one-time custom playbook from the report and optionally saves to `~/.ccmb-lp/playbooks/`. Composition is optional — falls back to `generic-fallback` if `ccmb-skyscraper` isn't installed.
- New section in `cascade-playbooks.md`: "When the ICP archetype is genuinely novel — chain with `/skyscraper`" with example novel archetypes (Substack climate writers, indie iOS devs, local realtors, veterinary practice owners).

### Architecture note
The skyscraper chaining is the codify loop applied to cascade authoring itself: when an unknown ICP archetype appears, don't vibe-code a new playbook — scan for existing patterns first. Same meta-skill pattern your skyscraper plugin embodies for general marketing problems.

## [0.3.0] — 2026-05-13

S4 lead enrichment — no-vendor-lock-in alternative to Apollo. Cascade scraping/lookup across free public sources (WebSearch + GitHub + public APIs + About pages), ICP-tuned via playbook library.

### Added
- `skills/ccmb-lead-enrichment/SKILL.md` — takes existing list (CSV/paste/LI export), enriches each row by cascading public sources, scores against ICP, outputs ranked CSV. Same downstream contract as v2 S4 spec — `lib/lead-research.ts` scoring engine unchanged.
- `skills/ccmb-lead-enrichment/references/cascade-playbooks.md` — 5 default ICP playbooks (developer-founder, b2b-saas-founder, creator-thought-leader, service-provider-consultant, generic-fallback). Each = ICP keyword triggers → ordered source list. Power users add custom playbooks at `~/.ccmb-lp/playbooks/`.
- `skills/ccmb-lead-enrichment/references/parsing-rules.md` — handles 6 input formats: CSV w/ headers, markdown table, LinkedIn Connections export, plain comma-separated paste, prose paste (LLM-extracted), names-only paste. Normalizes to internal `RawProspect` shape before cascade.

### Architecture notes
- **Tier 1 only for cohort 1.** Tier 2 (Cloudflare Worker browser-rendering proxy) and Tier 3 (Apify Store actors) documented as post-cohort upgrade paths but not shipped.
- **No LinkedIn scraping ever.** When LI URL is encountered, written to output for manual click-through; never crawled. TOS-clean, ban-risk-minimal.
- **No third-party transmission of student lists.** Skill calls public sources for individual lookups only; never bulk-submits to any external service.
- **ICP-aware cascade** — when student pivots offer, re-run against same list, get a completely different ranking from completely different signals. The list compounds across pivots.

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
