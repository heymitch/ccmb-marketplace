---
name: ccmb-lp-build
description: Compose a complete landing page from a cached design system + `copy.json` and deploy it live to Vercel. Reads `~/.ccmb-lp/design-tokens.json` (from /ccmb-lp-design) and `./copy.json` (from /ccmb-lp-copy), scaffolds Next.js + Tailwind, applies the baked-in mobile + perf rules, and ships the live URL. Use when design + copy are already locked and you want to deploy, or when you want the orchestrator that chains design → copy → build in one prompt. Triggers — "/ccmb-lp-build", "deploy my landing page", "ship the LP", "build and deploy this page", "make the page go live".
---

# CCMB LP Build

## 1. What this skill does

Reads two artifacts (design system from `/ccmb-lp-design`, copy from `/ccmb-lp-copy`) and ships a production Next.js landing page to Vercel. Output: a live `https://[slug].vercel.app` URL, mobile-correct and Core Web Vitals-performant by default.

This skill is **the orchestrator.** If either artifact is missing, it chains the prerequisite skill automatically:

- No design tokens cached? → invoke `/ccmb-lp-design` first, wait, then proceed.
- No `copy.json` in the current folder? → invoke `/ccmb-lp-copy`, wait, then proceed.
- Both present? → build + deploy directly.

The blank-folder test case works because of this chaining. A user with zero prior state can type "build me a landing page" and get a live URL in 14-22 minutes.

## 2. When to invoke

- The default entry point for any LP deploy. `/ccmb-lp-build` is the "make me a page" command.
- Re-deploys of an existing LP after copy or design changes — the skill detects existing `.vercel` project and re-deploys to the same URL.
- Iterating on a single page across copy revisions — run `/ccmb-lp-copy` to update `copy.json`, then `/ccmb-lp-build` to redeploy.

**Use `/ccmb-landing-page` instead** if you want the single-shot monolith that does design + copy + build in one pass without artifact files. The monolith is faster for one-off pages; this skill is better for brands shipping multiple pages.

## 3. What it produces

A complete Next.js project in the current folder:

- **`package.json`** — Next.js 14, React 18, Tailwind 3 (pinned to prevent v4 breakage)
- **`next.config.mjs`** — minimal, no exotic features
- **`tailwind.config.ts`** — wired with tokens from `~/.ccmb-lp/design-tokens.json` (or sub-brand cache)
- **`tsconfig.json`** — strict mode on
- **`app/layout.tsx`** — fonts preconnect, LCP preload, dns-prefetch for offsite CTA targets
- **`app/page.tsx`** — the page, composed from `copy.json` using the right Hero/Benefits/Footer variants per `~/.ccmb-lp/component-shapes.md`
- **`app/globals.css`** — Tailwind directives + the 10 mobile rules + the 6 perf rules (see §5)
- **`vercel.json`** — Cache-Control for static + `_next/static`
- **`public/`** — any provided product image converted to WebP at q90

Then: a live deployed URL. Printed at the end. Tested against the user's phone before claim-of-done.

## 4. The chaining logic

```
/ccmb-lp-build invoked
  │
  ├─ Check ~/.ccmb-lp/design-tokens.json
  │   ├─ Missing → "Design system not cached. Running /ccmb-lp-design first."
  │   │            (skill invokes /ccmb-lp-design inline, waits for completion)
  │   └─ Present → continue
  │
  ├─ Check ./copy.json
  │   ├─ Missing → "Page copy not found. Running /ccmb-lp-copy first."
  │   │            (skill invokes /ccmb-lp-copy inline, waits)
  │   └─ Present → continue
  │
  ├─ Detect folder state (empty / existing Next.js / non-empty other)
  ├─ Scaffold or modify in place
  ├─ Wire tokens into tailwind.config.ts
  ├─ Compose app/page.tsx from copy.json
  ├─ Apply mobile + perf rules
  ├─ Deploy to Vercel
  └─ Print live URL
```

If either sub-skill fails, the build skill **stops** and prints the failure. It does not proceed with a half-completed input.

## 5. The baked-in defaults — inherited from `ccmb-landing-page`

This skill inherits the **10 mobile rules** and **6 perf rules** from the existing `ccmb-landing-page` skill verbatim. See `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-landing-page/SKILL.md` §4 for the full rule set with rationale.

The summary, for reference at build time:

### 10 mobile rules

1. `overflow-x: hidden` + `max-width: 100%` on `html` and `body`.
2. Grid columns use `minmax(0, 1fr)`. Grid/flex children get `min-width: 0; max-width: 100%`.
3. Desktop-only chrome gets `display: none` at mobile breakpoint.
4. Hero uses `min-height: 100dvh` with flex centering. Vertical padding clamps on viewport height.
5. Display headline clamp floors at 34px on phone, not 44px.
6. Section gutter is 20px on phone portrait, not 32px.
7. Countdown / inline-flex data rows stack to `flex-direction: column` at ≤720px.
8. Sticky elements use `position: fixed` with translate, not `position: sticky` with translate.
9. `word-break: break-word` + `overflow-wrap: anywhere` on inline `<code>`.
10. Grid reorder via `grid-template-areas`, never DOM duplication.

### 6 perf rules

1. WebP-only image pipeline at q85 (q90 for LCP hero).
2. `<link rel="preconnect">` for every external font host.
3. LCP image preload + `fetchPriority="high"`.
4. Fonts via `<link rel="stylesheet">` in `<head>`, never `@import`.
5. `vercel.json` with `Cache-Control: public, max-age=31536000, immutable` for static + `_next/static`.
6. `<link rel="dns-prefetch">` for offsite CTA targets.

These are applied as scaffold defaults, not audit-pass corrections. The page is born correct.

## 6. Token-to-Tailwind mapping

`/ccmb-lp-design` writes `design-tokens.json`. This skill maps those tokens to `tailwind.config.ts`:

| Token JSON path | Tailwind config key |
|---|---|
| `colors.background` | `colors.brand.background` |
| `colors.surface` | `colors.brand.surface` |
| `colors.primary` | `colors.brand.primary` (also default for `bg-brand-primary`, `text-brand-primary`) |
| `colors.accent` | `colors.brand.accent` |
| `colors.text_primary` | `colors.brand.text` |
| `colors.text_secondary` | `colors.brand.text-secondary` |
| `colors.text_tertiary` | `colors.brand.text-tertiary` |
| `fonts.display` | `fontFamily.display` |
| `fonts.body` | `fontFamily.sans` |
| `radii.{sm,md,lg,full}` | `borderRadius.{sm,md,lg,full}` (overrides Tailwind defaults) |
| `spacing_scale` | `spacing.{xs,sm,md,lg,xl,2xl}` (custom keys, doesn't replace Tailwind defaults) |
| `shadows` (if non-empty) | `boxShadow.{sm,md,lg}` |

Fonts that aren't system fonts get loaded via Google Fonts `<link>` in `app/layout.tsx`. Order matters: preconnect → preload → stylesheet link.

## 7. Component variant selection

`/ccmb-lp-design` writes `component-shapes.md` with notes like:

> Hero variant: **Shape B (two-column with product image)** because mood "warm editorial library" wants visual richness.
> Benefits: 3-column grid with soft cards (12px radius).
> Footer: minimalist with links left, brand right.

This skill reads those notes and composes `app/page.tsx` accordingly. Available variants:

### Hero
- **Shape A** — single column, headline + subhead + email form. Lead-magnet default.
- **Shape B** — two-column, image right. Course/cohort/product default.
- **Shape C** — eyebrow + centered headline + subhead + CTA + trust strip. Service/consulting default.

### Benefits (if `copy.benefits` exists)
- 3-column grid with hover lift (default)
- 2-column with screenshots (when copy has visual assets)
- Single-column with numbered steps (StoryBrand 3-step plan)

### Form
- Embedded in hero (lead-magnet mode)
- Mid-page + bottom-page section (full mode)

### Footer
- Minimalist (brand + 3 links)
- Full (brand + 4 columns + social)

If `component-shapes.md` doesn't specify, the skill picks by `copy.mode`:
- `lead-magnet` → Shape A + minimal footer
- `full` → Shape B or C based on `copy.hero.cta_text` presence

## 8. Execution flow

12 steps, same shape as `ccmb-landing-page` but artifact-driven.

1. Check `~/.ccmb-lp/design-tokens.json`. If missing, invoke `/ccmb-lp-design` inline and wait.
2. Check `./copy.json`. If missing, invoke `/ccmb-lp-copy` inline and wait.
3. Read both artifacts. Confirm one-line back to user: "Building '[slug]' with brand '[design-system mood]' and [framework] copy. Deploying to heymitch-[slug].vercel.app (or [user-prefix]-[slug] if configured). Right?"
4. Detect folder state — empty / existing Next.js / non-empty other. Pick scaffold-fresh, modify-in-place, or sub-folder strategy. Confirm with user if non-empty.
5. If scaffolding fresh: `npx create-next-app@latest` with App Router, Tailwind, TypeScript, no ESLint. Pin Next.js to a stable version.
6. Remove boilerplate from `app/page.tsx`, `app/layout.tsx`, `app/globals.css`.
7. Write `tailwind.config.ts` from `design-tokens.json` per §6 mapping.
8. Write `app/globals.css` with Tailwind directives + the 10 mobile rules in CSS.
9. Write `app/layout.tsx` with font preconnects (from `design-tokens.json.fonts`), LCP preload (if `copy.hero.product_image` present), dns-prefetch (if `copy.form.form_id` is a third-party service like Kit or Mailchimp), and `<link rel="stylesheet">` for fonts.
10. Write `vercel.json` per perf rule 5.
11. Compose `app/page.tsx` from `copy.json` + `component-shapes.md`. HTML in the user's voice. No JSX state, no `useState`. Static React-as-HTML.
12. Convert any provided image to WebP. Deploy via Vercel CLI (`vercel deploy --prod --yes`) or Vercel MCP if connected. Print live URL.

If the user asks for an edit between steps 11 and 12, apply and redeploy.

## 9. The blank-folder run

The load-bearing test case. User opens an empty folder, says "build me a landing page for [thing]." Sequence:

1. `/ccmb-lp-build` invokes.
2. No `~/.ccmb-lp/`. Skill says: "Design system not cached. Running `/ccmb-lp-design` first." Invokes it.
3. `/ccmb-lp-design` runs its 4-5 question interview, writes cache, returns. ~5 min.
4. `/ccmb-lp-build` resumes. No `copy.json`. Skill says: "Page copy not found. Running `/ccmb-lp-copy` first." Invokes it.
5. `/ccmb-lp-copy` runs its 6-question interview, writes copy.json, returns. ~12-18 min.
6. `/ccmb-lp-build` scaffolds, composes, deploys. ~6-9 min.
7. Live URL printed.

Total: 23-32 min on the absolute first run. Subsequent pages on the same brand: skip step 2-3 (design cached), so 18-27 min. Same brand, fast copy iteration (`quick mode`): 10-15 min.

The first-run cost is the design interview. Every page after is downhill.

## 10. Vercel handling

**Important framing:** The deploy mechanism is the **Vercel CLI** in every environment. There's no "the Connector deploys directly" path — the Vercel Connector (Claude Desktop → Settings → Connectors → Vercel) is an *auth + coaching layer.* It authenticates the user's Vercel account once and instructs the agent on the right CLI invocation. The actual `vercel deploy` still runs via the agent's Bash tool. The Vercel **MCP server** (separate, optional) is the only path that replaces the CLI — and only if the student has it installed and connected.

Deploy path selection, in this order:

1. **Vercel MCP server is connected** — call its `deploy_to_vercel` tool directly. No CLI involved. This is rare for CCMB students (the MCP isn't part of the default install).
2. **Vercel Connector is configured (Desktop) or `vercel whoami` returns a user (local)** — auth is already established. Skill runs `vercel deploy --prod --yes` via Bash.
3. **Vercel CLI present, not authenticated** — skill runs `vercel login`. OAuth opens a browser. User clicks once, returns. Skill detects auth and proceeds. If running in Claude Desktop with no Connector, skill prints: "Quickest path: open Settings → Connectors → Vercel → Connect. Or run `vercel login` and click the link. Say 'continue' when done." Pauses.
4. **No Vercel CLI present** — skill installs it. If `ccmb-safe-install` is also installed (check `~/.claude/skills/ccmb-safe-install/`), route through it: `safe-npm i -g vercel` — picks up the pinned version from `campaign-status.json` automatically. Otherwise: `npm i -g vercel` direct. If global install fails (no sudo in restricted environments): fall back to `npx vercel` for the deploy.

The skill never asks the user to "open a terminal." Bash runs inside the existing Claude Code session. The only manual moments are:
- **First-ever Vercel auth.** Either click the Connector approval in Settings (Desktop) or click the OAuth link `vercel login` prints (local). One-time, ~10 seconds.
- **Sandbox where neither CLI install nor MCP path works.** Skill pauses and explains the environment limitation rather than failing silently.

Project naming: defaults to `[brand-slug]-[copy-slug]` (e.g., `heymitch-drive-skill`). User can override at scaffold step.

Re-deploys: detects existing `.vercel/project.json` and links to the same project, so URL stays stable across runs.

## 11. Failure modes and recovery

- **`vercel` command not found, `npm i -g` blocked by sandbox.** Cowork-style environments whitelist npm registry so global install works in most cases. If it truly fails: fall back to `npx vercel deploy --prod --yes`. Slower (cold npx fetch each run), but no manual intervention needed.
- **`ccmb-safe-install` is installed and quarantines `vercel`.** The shield's `campaign-status.json` pins to a known-good version (currently `39.4.0`). The skill calls `safe-npm` instead of raw `npm i -g`, so the pin is honored automatically. If the shield blocks even the pinned version (e.g., during an active CVE campaign), the skill prints the shield's error and pauses for the user to either wait, `--pin-override`, or contact maintainer.
- **`vercel login` OAuth times out** (user didn't click the browser link). Skill detects the timeout, prints: "I opened the Vercel login flow but didn't see the auth complete. Click the link Vercel printed, then say 'continue'."
- **Connector configured but expired** (Desktop). The CLI invocation returns an auth error. Skill prints: "Vercel Connector token expired. Open Settings → Connectors → Vercel → Reconnect. Then say 'continue'."
- **Vercel project name collision.** Skill detects "already in use" and offers an alternate slug. Defaults to `[name]-v2`.
- **`copy.json` malformed.** Skill validates JSON before scaffolding. Prints exact line/column of error. Suggests re-running `/ccmb-lp-copy` if user can't fix.
- **`design-tokens.json` missing required keys.** Skill validates the schema. Prompts to re-run `/ccmb-lp-design` if keys missing.
- **Next.js build fails.** Skill captures the error, checks for the three common breakage points (Tailwind import missing, globals.css not imported in layout, font not loading), prints diagnostic, fixes, retries once. If still fails, prints error and pauses.
- **Build succeeds, page renders blank.** Always Tailwind wiring. Skill checks `globals.css` imports + `layout.tsx` import of globals. Fixes and redeploys.
- **User wants to fork to a sub-brand mid-build.** Skill stops, suggests user run `/ccmb-lp-design new <slug>` first to create a sub-brand cache, then re-run `/ccmb-lp-build`.

## 12. Composition with other skills

- **`/ccmb-lp-design`** — hard prerequisite. Auto-invoked if cache missing.
- **`/ccmb-lp-copy`** — hard prerequisite. Auto-invoked if `copy.json` missing.
- **`ccmb-safe-install`** — if installed, the build skill routes any `npm i -g vercel` through `safe-npm` to honor pinned versions and CVE quarantine from `campaign-status.json`. No flag needed; the composition is automatic when both skills are present.
- **`/ccmb-headline-writer`** — optional pre-step. Use to iterate hero options before `/ccmb-lp-copy` locks them.
- **`/ccmb-sentence-editor`** — post-deploy polish. Use to tighten individual paragraphs after the page ships, then `/ccmb-lp-build` to redeploy.
- **`/ccmb-landing-page`** — the monolith alternative. Use when you want one-shot, no artifacts. Use this skill when you want explicit separation + reusable design.

## 13. Versioning

Fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-build/SKILL.md`. Installs to `~/.claude/skills/ccmb-lp-build/SKILL.md`.

Update with: "Update my CCMB skills to the latest version."
