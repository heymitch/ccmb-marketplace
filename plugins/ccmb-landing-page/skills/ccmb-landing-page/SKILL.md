---
name: ccmb-landing-page
description: Generate (or rewrite) a complete landing page in the voice of the active CLAUDE.md — hero, pitch, CTA, social proof — as hand-tunable HTML inside a Next.js scaffold, mobile-correct and Core-Web-Vitals-performant by default, and deploy it to Vercel. Use when shipping a marketing site for the first time, rewriting an existing hero after a CLAUDE.md change, spinning up a landing page for a side project / pivot / client, or any prompt that asks for "a landing page", "a marketing site", "a hero section", or "rebuild my site from CLAUDE.md". Triggers — "/ccmb-landing-page", "build my landing page", "rewrite my hero section", "generate a marketing site from my CLAUDE.md", "ship a landing page", "scaffold a marketing page".
---

# CCMB Landing Page

## 1. What this skill does

Reads the active `CLAUDE.md`, asks 3-5 short questions, then writes a complete landing page — hero, pitch, CTA, social proof — as hand-tunable HTML inside a Next.js scaffold, and deploys it to Vercel. Your site lands on a public URL in roughly the time it takes to drink a coffee. The copy is in your voice, not template copy with bracketed placeholders. The HTML is editable by a human (no JSX components, no React state, no compile-time gymnastics). The defaults are mobile-correct and Core-Web-Vitals-performant out of the box, because the rules learned from the CCMB launch site got promoted upstream into this skill.

You ran this once during CCMB Session 1 to ship `yourname.vercel.app`. Every time after that, it's the same skill on a different folder — side project, client work, pivot, new offer. Same equipment, different output.

## 2. When to invoke

- First time building a landing page in CCMB Session 1 (the trigger prompt fetches and executes this skill inline).
- Rewriting an existing landing page after you changed your `CLAUDE.md` significantly (new niche, new offer, new voice).
- Building a landing page for a side project, pivot, client deliverable, or one-off marketing site.
- Anyone asking Claude Code for "a marketing site", "a landing page", "a hero section", or "a personal site."
- Anytime you want a from-scratch site that's correct on mobile and fast by default without auditing afterward.

If you want to iterate copy options *before* committing to the page rewrite, run `/ccmb-headline-writer` first. If you want to polish a single paragraph after the page ships, use `/ccmb-sentence-editor`. This skill handles the structural build.

## 3. What it produces

When the skill finishes, your folder contains:

- A **Next.js scaffold** if the folder was empty — `package.json`, `next.config.mjs`, `tailwind.config.ts`, `tsconfig.json`, `app/`, `public/`. If a Next.js project already exists, the skill modifies it in place instead of overwriting (and asks first before touching `page.tsx` if you've edited it).
- **`app/page.tsx`** — hand-tunable HTML in your voice. Hero, pitch, CTA, social proof sections. No JSX components, no `useState`, no `useEffect`. Per Tariq Shihipar's "Unreasonable Effectiveness of HTML" thesis — for a marketing page, HTML is the right primitive.
- **`app/globals.css`** — Tailwind directives plus the baked-in mobile + perf defaults (see §4).
- **`app/layout.tsx`** — minimal layout with font preconnect, LCP image preload, `dns-prefetch` for the CTA target if it's offsite, and the perf-tuned `<head>` tags.
- **`vercel.json`** — Cache-Control headers for static assets (`max-age=31536000, immutable`) and `_next/static` chunks. Ships with the site, no audit pass needed.
- **`public/`** — any images you provided, converted to WebP if they weren't already.
- A **live deployed URL** on Vercel, in the format `https://[slug].vercel.app`, printed at the end.

If Vercel isn't connected, the skill pauses *before* writing anything and coaches you through reconnecting via Settings → Connectors → Vercel. It doesn't try to deploy without a connection. It doesn't fabricate output.

## 4. The baked-in defaults — why your site is born performant

> Every site this skill generates ships with mobile correctness and Core Web Vitals defaults baked in. You don't audit-then-fix; you ship-and-it's-already-correct. These defaults exist because the patterns kept appearing as post-hoc edits on the CCMB launch site. They got promoted upstream.

This is the load-bearing reason the skill exists as a skill, not a prompt. A one-off prompt produces a generic landing page that fails Lighthouse and breaks on a 375px viewport. This skill produces a page that's already correct, because the ten mobile rules and six perf rules below are scaffolded by default — not added later by an audit.

### The 10 mobile rules (baked in)

1. **`overflow-x: hidden` + `max-width: 100%` on `html` and `body`.** Nothing in the generated tree ever causes sideways scroll. Anti-horizontal-scroll safety net.
2. **Grid columns use `minmax(0, 1fr)`, never bare `1fr`. All grid/flex children get `min-width: 0; max-width: 100%`.** Bare `1fr` is `minmax(auto, 1fr)` — `auto` lets min-content push the column wider than the parent. This is the bug that produces "CTAs bleeding off the edge."
3. **Desktop-only chrome (term strips, ambient animations, decorative widgets) gets `display: none` at the mobile breakpoint by default.** The generator places the gate, not the audit pass.
4. **Hero uses `min-height: 100dvh` with flex centering. Vertical padding clamps on viewport height. Hero image caps on both pixel AND `vh` units.** CTA above the fold isn't a desktop concern. It's a viewport concern. Landscape iPads exist.
5. **Display-weight headline clamp floors at 34px on phone, not 44px.** Two-word headlines need to fit one line at 375px wide. Floor against the longest real headline, not the design comp.
6. **Section gutter is 20px on phone portrait, not 32px.** 32px eats 17% of a 375px viewport in padding alone.
7. **Countdown / inline-flex data rows stack to `flex-direction: column` at ≤720px.** Any element whose natural width exceeds 320px gets a stacked phone variant by default.
8. **Sticky elements that should hide on mobile use `position: fixed` with translate, not `position: sticky` with translate.** Sticky claims layout space at `scrollY=0`. Fixed removes from flow.
9. **`word-break: break-word` + `overflow-wrap: anywhere` on inline `<code>` elements.** Long snippets (`.skills`, file paths, command flags) blow past viewport width otherwise.
10. **Grid reorder via `grid-template-areas`, never DOM duplication or JS.** Same source, two layouts. `display: contents` on a wrapper is the bridge when desktop wants a parent and mobile wants flat children.

Full case study with the six commits these rules were extracted from is in the CCMB cohort repository — students see it in the vibe-editing reference (link at the bottom).

### The 6 perf rules (baked in)

1. **WebP-only image pipeline.** Every raster image gets exported as WebP at q85 (q90 for the LCP hero), sized to display dimensions plus 2x retina. No PNG, no JPG in `public/`. Originals never ship. The CCMB launch site went from 19MB to 1.4MB on this rule alone (-92%).
2. **`<link rel="preconnect">` for every external font host in `<head>`.** `fonts.googleapis.com`, `fonts.gstatic.com`, `api.fontshare.com` — whichever your kit uses. TLS handshake runs in parallel with HTML parse. Saves 100-300ms on cold visits.
3. **LCP image preload + `fetchPriority="high"`.** The hero `<img>` gets `fetchPriority="high"` and `decoding="async"` plus a matching `<link rel="preload" as="image">` in `<head>`. The generator knows which image is the LCP because it placed it.
4. **Fonts loaded via `<link rel="stylesheet">` in `<head>`, never `@import` in CSS.** `@import` is a chain dependency that blocks discovery on `globals.css`. `<link>` is discoverable at HTML parse time and fetches in parallel. The generator never writes `@import` for fonts.
5. **`vercel.json` shipped by default with `Cache-Control: public, max-age=31536000, immutable` for static assets and `_next/static` chunks.** Vercel's ETag default is fine for correctness but costs a 304 round-trip on every return visit. Immutable + 1yr max-age is safe — public assets are commit-tracked, Next.js chunks are content-hashed.
6. **`<link rel="dns-prefetch">` for offsite CTA targets.** If your CTA points to SamCart, Stripe, Calendly, or any payment / booking domain, the generator adds `dns-prefetch` for that host in `<head>`. DNS lookup completes before the user clicks. Cheap, free win.

Full case study in the cohort repository, link at the bottom.

### Why these rules live here

Both the mobile and perf rule sets were extracted from post-hoc fixes on the CCMB launch site — six commits to fix mobile, two more for perf. Every fix mapped one-to-one to a rule. The lesson: if the rule lives in a skill, the next site is born correct. If it lives only in a one-off prompt, every new site repeats the audit-fix-retest loop. CCMB calls this the **codify loop** — when a fix shows up twice, promote it upstream so the third site never has the bug.

Cohort-wide vibe-editing reference (public): `https://github.com/heymitch/ccmb-marketplace/blob/main/references/vibe-editing.md`

## 5. The 5 inputs the skill needs

Three inputs come from the active `CLAUDE.md`. Two-to-three come from you in the moment. If `CLAUDE.md` is missing or sparse, the skill pauses and tells you to write one first — it doesn't fabricate.

**From `CLAUDE.md`:**

1. **Who you serve (ICP)** — the specific reader the page is for. Not "small business owners." Something like "SaaS founders shipping their first paid product." If `CLAUDE.md` says only "marketers," the skill asks you to tighten it before it'll write.
2. **What you sell (offer)** — the named product / service / engagement. Not "marketing consulting." Something like "a 6-week cohort that ships your AI marketing site by Week 6."
3. **Your voice (tone, phrases to use / phrases to avoid)** — the lines you'd actually say to a friend. The skill reads voice paragraphs verbatim and matches their cadence; it doesn't paraphrase them.

**From you in the moment:**

4. **Hero image source** — three options. (a) a file in this folder (`hero.jpg`, `me.png`, `logo.webp`); (b) a URL the skill should download; (c) "use a placeholder color block, I'll add an image later." All three work. Placeholder is fine for v1.
5. **One-sentence social proof** — a testimonial, a metric (`$3M ARR`, `47 founders shipped`), a recognizable client name, a "featured in" line. Or "skip" — section gets removed cleanly.
6. **CTA button text + target URL** — what visitors should DO and where they go. `Book a 15-min call → calendly.com/yourname`, `Buy now → checkout.yoursite.com/offer`, `Get the free guide → [we wire this up in S2]`, or `Get in touch → mailto:you@email.com`. If you don't know yet, the skill defaults to a `mailto:` CTA so the page is still functional.

If `CLAUDE.md` is missing, malformed, or sparse enough that ICP and offer can't be quoted back to you in a sentence: the skill pauses and tells you to fix `CLAUDE.md` first. Don't argue with it. A landing page generated from a fabricated ICP is a worse outcome than no landing page.

## 6. Execution flow

What happens when you invoke the skill — 12 steps from "read CLAUDE.md" to "print live URL."

1. Read the active `CLAUDE.md` from the current folder. If missing or sparse — pause and tell user to write one first.
2. Pull ICP, offer, voice phrases, and any do-not-use phrases from `CLAUDE.md`. Confirm them back to the user in one sentence ("Building for [ICP] who want to [outcome]. Voice: [tone]. Skip the words [avoid list]. Right?").
3. Ask the 3-5 inputs from §5 above (hero image, social proof, CTA, optional headline phrases, optional brand color).
4. Detect folder state — empty, existing Next.js project, non-empty but not Next.js, or has prior CCMB work. Pick the right path (scaffold / modify / sub-folder / ask). Never overwrite a user-edited `page.tsx` without confirming.
5. If scaffolding fresh — run `npx create-next-app@latest` with App Router, Tailwind, TypeScript, no ESLint scaffolding (we keep it minimal). Pin Next.js to a stable version if a bleeding-edge default would break the build.
6. Remove default Next.js boilerplate from `app/page.tsx`, `app/layout.tsx`, and `app/globals.css`.
7. Write `app/globals.css` with Tailwind directives plus the 10 mobile rules from §4 (CSS form, ready to apply).
8. Write `app/layout.tsx` with the font preconnect, LCP preload, `dns-prefetch` for any offsite CTA, and the perf-tuned `<head>` tags. Use `<link rel="stylesheet">` for fonts, never `@import`.
9. Write `vercel.json` with the Cache-Control headers from §4 rule 5.
10. Convert any user-provided hero image to WebP at q90 (it's the LCP) and save to `public/`. If the user provided a URL, download then convert.
11. Write `app/page.tsx` — HTML in the user's voice, drawing copy from `CLAUDE.md`. Hero (with the LCP image, `fetchPriority="high"`), pitch, CTA, social proof. Real headlines. Real subheads. No bracketed placeholders.
12. Deploy via the Vercel connector. Print the live URL. Tell the user to open it on their phone and confirm.

If the user asks for an edit between steps 11 and 12 ("the hero headline is too long, cut it to 8 words"), apply the edit, redeploy, and re-print the URL. Cap at 3 in-session edits during the live CCMB session (more becomes async homework); no cap outside the cohort.

## 7. What you can edit afterward

Your page is shipped. You're going to want to tweak it — a color, a phrase, a section reorder. That's normal. The way you do it matters more than what you change.

**Vibe editing** = casual conversational edits in Claude Code, without re-running the full skill. Open a fresh Claude Code chat (in the same folder), say what you want changed, end with "redeploy when done."

Four rules:

1. **Open a fresh chat in the same folder.** Don't continue the build chat — context gets stale and Claude needs to re-read `page.tsx` and `CLAUDE.md` clean.
2. **Be specific.** "Make it pop" doesn't work. "Cut the hero headline to 8 words, change the CTA button from blue to forest green, and add 'No credit card required' as small text under the CTA" works.
3. **Show, don't tell.** When you can, paste the exact text. "Replace 'Get started today' with 'Talk to a real human in 15 min'" beats "make the CTA friendlier."
4. **Always end with "redeploy when done."** Vercel doesn't auto-push unless you ask.

If you've made 5+ edits in one chat and Claude starts losing track of what `page.tsx` currently looks like, start another fresh chat: `Read my page.tsx and CLAUDE.md fresh. Then I have some edits.`

Re-run the full skill (not vibe-edit) when: your business changed completely, you want to start the page from scratch with new copy, or the page broke and you want a clean slate. Re-running is safe — the skill is idempotent.

Full vibe-editing cheat sheet (cohort-wide reference, public):
`https://github.com/heymitch/ccmb-marketplace/blob/main/references/vibe-editing.md`

## 8. Failure modes and recovery

Seven common breakage points and what the skill does about each.

1. **Vercel disconnected.** The skill pauses *before* it writes anything else and prints: "Vercel needs to be connected. Open Claude Desktop → Settings → Connectors → Vercel → Reconnect. Then paste back: 'Vercel reconnected, continue.'" It does not try to deploy without a connection. It does not write a half-built scaffold.
2. **`CLAUDE.md` is missing.** The skill prints: "I can't write a landing page without `CLAUDE.md`. Write one first — it's roughly a one-pager covering who you serve, what you sell, and how you talk. Then re-run me." It does not fabricate an ICP.
3. **Folder has existing Next.js project.** The skill detects `package.json` + `next.config.*` and switches to modify mode. It asks before touching `page.tsx` if the file has been edited since scaffold (compares against the default Next.js boilerplate). User says yes → it writes. User says no → it writes to `app/page.new.tsx` and lets the user diff.
4. **Folder is non-empty but not Next.js.** The skill prints: "This folder has stuff in it but no Next.js project. Want me to scaffold into a `site/` subfolder instead?" Defaults to yes.
5. **Tailwind compile errors at build time.** Usually `globals.css` missing the Tailwind `@tailwind` directives, or `layout.tsx` not importing `globals.css`. The skill checks both first if a build fails and prints the named diagnostic. Fix takes ~10 seconds.
6. **Build succeeds but page renders blank white.** Almost always a Tailwind wiring issue — `globals.css` imports missing, or `layout.tsx` not pulling in `globals.css`. The skill checks both, prints the diagnostic, fixes, and redeploys.
7. **Image is the wrong format.** PNG, JPG, or HEIC sources get converted to WebP at q85 (q90 for the LCP) before they enter `public/`. If conversion fails (e.g., the source file is corrupt), the skill falls back to the placeholder color block and tells the user — it doesn't ship a broken `<img>` tag.

Plus three lower-frequency cases worth knowing:

- **Vercel project name collision.** The skill detects "project name already in use" and offers an alternate slug (`yourname-ccmb-v2`, `yourname-site`).
- **Vercel rate limit on free tier.** New accounts cap at ~100 deploys/day. The skill prints the rate-limit error and tells the user to wait ~1 hour.
- **The user pastes the trigger twice during Session 1.** The skill detects already-installed and skips the install step. Idempotent by design.

## 9. Related skills

- **`/ccmb-headline-writer`** — generates 10 ranked headline options before you commit. Use this to iterate hero / subhead copy before re-running this skill or vibe-editing the page.
- **`/ccmb-sentence-editor`** — tightens a paragraph. Paste in copy, get back a sharper version in your voice. Use this after the page ships when you want to polish a single section without rebuilding.

Both install alongside this skill in CCMB Session 1 — they're already on your computer at `~/.claude/skills/`.

## 10. Versioning + updates

This skill is fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-landing-page/SKILL.md` during install. The file lives on your computer at `~/.claude/skills/ccmb-landing-page/SKILL.md` once installed. It works in any Claude Code chat, any folder, any project — that's what "app-wide skill" means.

To update to the latest version: paste in any Claude Code chat:

```
Update my CCMB skills to the latest version.
```

Claude re-fetches the skill files from the GitHub URL and replaces what's at `~/.claude/skills/ccmb-{landing-page,headline-writer,sentence-editor}/SKILL.md`. Your sites — your `page.tsx`, your `CLAUDE.md`, your `public/` images — are never touched by a skill update. Only the skill behavior gets refreshed.

If you want to pin to a specific version (rare): edit the GitHub URL in the install prompt to point at a tagged release instead of `main`. Cohort 1 students run from `main`. Future cohorts may pin to release tags.

Cohort-wide changelog (when there is one): `https://github.com/heymitch/ccmb-marketplace/blob/main/CHANGELOG.md`
