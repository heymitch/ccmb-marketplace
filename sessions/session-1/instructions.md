# CCMB Session 1 — Landing Page (Execution Bundle)

**Audience:** Claude Code executing the Session 1 trigger prompt. NOT the student.
**Fetched by:** the trigger prompt the student pastes (see `session-1-landing-page.md` lines 141-170).
**Status:** v1, cohort 1.

---

## 1. Preamble — what this bundle does

You are executing CCMB Session 1. Your job: scaffold a Next.js landing page in the student's CCMB folder, write hero + pitch + CTA + social proof in their voice from `CLAUDE.md`, deploy to Vercel, hand them a live URL.

The trigger prompt that fetched this bundle is the contract. Honor it literally. The student pastes once and expects: (a) skills installed app-wide, (b) site scaffolded if needed, (c) 3-5 questions answered live, (d) page written, (e) Vercel deploy, (f) URL printed with the closing "DONE." line.

You operate in the student's CCMB folder. The only path you write outside it is `~/.claude/skills/` (skill installs — handled by the trigger prompt itself, not this bundle).

Every default in this bundle is battle-tested on `ccmb-landing` (the production CCMB launch site). The 10 mobile rules from `mobile-pass.md` and the 6 perf rules from `perf-v2.md` are baked into the scaffold so the site is born mobile-correct and Lighthouse-clean. Don't second-guess the defaults. Don't "improve" them mid-session.

---

## 2. Bombproof execution rules

These are non-negotiable. Re-read before each major step.

- **Idempotent re-execution.** A student may paste the trigger prompt twice. Detect existing scaffold (`package.json` + `next.config.*`) BEFORE running `create-next-app`. If present, skip scaffold and proceed to content writing on the existing files. If `app/page.tsx` exists AND has student edits (not your original output), stop and ask before overwriting.
- **Never write outside the student's CCMB folder.** Exception: `~/.claude/skills/` for skill installs (the trigger prompt handles this, not you). No writes to `~/Desktop`, `~/Documents`, `/tmp`, nowhere else.
- **Sacrifice grammar for clarity.** Output prose in the student's voice from `CLAUDE.md`. Fragments are fine. Punchy beats polished.
- **Forbidden phrases in any output.** No "Great question!" No "In today's fast-paced world." No "I'd be happy to help." No "Let's dive in." No "fast-paced," "ever-evolving," "game-changer," "revolutionary," "unlock," "leverage" (as a verb), "seamlessly," "robust," "comprehensive solution." If a phrase reads like a default LLM helper, kill it.
- **Stop and ask before overwriting student-modified files.** If you detect `app/page.tsx` was edited after your previous run, surface the diff in one sentence and ask: "I see you edited X. Overwrite, merge, or keep yours?"
- **Sacrifice cleverness for working software.** If a design choice isn't load-bearing, default to the simpler version. The student must hit DONE in 50 min.
- **No JSX components.** The page is HTML inside `app/page.tsx`. `<div>`, `<h1>`, `<p>`, `<a>`, `<img>`. Not `<Hero />`, not `<CTAButton />`. Per S1-D10 ("Unreasonable Effectiveness of HTML") — student must be able to read and edit their own page without learning React.
- **Never invent social proof.** If the student says "skip" or "starting fresh," omit the social-proof section entirely. Do not fabricate testimonials, numbers, client logos, or press mentions.
- **Pin Next.js to 14.2.x.** Per S1-D6 in the design doc. Newer versions have shifted scaffold ergonomics; 14.2 is what the test plan validates against.

---

## 3. Pre-flight checks

Run all three before scaffolding. Surface results to the student in one compact log block.

### 3.1 Is there an existing Next.js project?

Check the current working directory for both:
- `package.json` (parse it — look for `"next"` in `dependencies` or `devDependencies`)
- `next.config.js`, `next.config.mjs`, or `next.config.ts`

Branches:
- **Both present** → set `EXISTING_SCAFFOLD=true`. Skip Section 5. Proceed to content writing (Section 6+). If `app/page.tsx` exists and looks student-edited (not boilerplate), pause per rule above.
- **Neither present** → set `EXISTING_SCAFFOLD=false`. Proceed through Section 5.
- **One present, one missing** → folder is in a half-state. Ask the student: "Found `package.json` but no `next.config`. Did a previous run fail mid-scaffold? Want me to re-scaffold clean (will overwrite `package.json`) or repair?"

### 3.2 Is Vercel connected?

You cannot directly query the Claude Desktop connectors API from inside Claude Code. So:
- Attempt the Vercel CLI deploy at Section 11. If it fails with an auth error, fall back to the reconnect coach flow.
- Do NOT pre-warn the student about Vercel unless it actually fails. Pre-work was supposed to handle this. Assume green until proven otherwise.

### 3.3 Has the student's `CLAUDE.md` been read?

Read `./CLAUDE.md` from the current folder. If missing, stop and tell the student: "No `CLAUDE.md` in this folder. Session 1 needs the pre-work 0.5 file. Go finish pre-work 0.5, then re-paste the trigger."

If present, parse it for: business name, ICP, offer, voice samples, taglines, design preferences. Hold these in working memory through Section 6.

---

## 4. The 3-5 questions to ask the student

After pre-flight, ask these in one batch. Numbered list. Use these EXACT phrasings.

**Required (3):**

1. **Hero image source?**
   Options to offer verbatim:
   - "I have a file in this folder called `hero.jpg` (or `.png` / `.webp`) — use it"
   - "Use this URL: [paste URL]"
   - "Use a placeholder color block — I'll add an image later"

2. **One-sentence social proof?**
   Examples to offer:
   - "Helped 47 SaaS founders ship in 30 days"
   - "$3M ARR built with this exact framework"
   - "Featured in Lenny's Newsletter"
   - "Skip — starting fresh" (in which case omit the section entirely)

3. **CTA button text and target?**
   Examples to offer:
   - "Book a 15-min intro call → calendly.com/yourname"
   - "Buy now → checkout.yoursite.com/offer"
   - "Get the free guide → [we'll wire this up in S2]"
   - "I don't know yet — use 'Get in touch' linking to mailto:you@email.com"

**Optional (2):**

4. **Any specific words/phrases you want featured in the headline?** (1-3 if any. "Skip" is fine.)
5. **Any color preferences for the page?** (Brand hex like `#FF5733`. Skip → tasteful neutral default.)

Wait for answers before proceeding. Do NOT default-answer on the student's behalf. If they answer "skip" to a required question, accept that — defaults are below.

**Defaults if a required answer is "skip":**
- Hero image: placeholder cream/coffee color block, 16:9, with the business name as text overlay.
- Social proof: section omitted.
- CTA: `Get in touch` → `mailto:` using whatever email appears in `CLAUDE.md`, or `#` if none.

---

## 5. Scaffold logic

Only run this section if `EXISTING_SCAFFOLD=false`.

### 5.1 Scaffold command

```bash
npx create-next-app@14.2 . \
  --typescript \
  --tailwind \
  --app \
  --no-src-dir \
  --no-import-alias \
  --no-eslint
```

Notes:
- `@14.2` pins to the 14.2.x line. Do not use `@latest`.
- `.` scaffolds into the current directory.
- `--app` = App Router (the `app/` folder convention).
- `--no-src-dir` = `app/` at the root, not `src/app/`. Simpler mental model for the student.
- `--no-import-alias` = no `@/` shenanigans. Plain relative imports only.
- `--no-eslint` = avoids the ESLint config dialog mid-scaffold. Student doesn't need lint right now.
- `--tailwind` = Tailwind v3 (current default for `create-next-app@14.2`). DO NOT install Tailwind v4 — config syntax is incompatible.

If the folder is non-empty, `create-next-app` will refuse. If that happens:
- Confirm the only files present are CCMB pre-work artifacts (`CLAUDE.md`, maybe a `hero.jpg`).
- Move them temporarily to a `.ccmb-prework/` subfolder.
- Run scaffold.
- Restore them.

### 5.2 Post-scaffold cleanup

Delete the default Next.js boilerplate so the student starts clean:

```bash
rm -f app/favicon.ico
rm -f public/next.svg public/vercel.svg
```

Then replace these three files entirely with the templates in Sections 6, 7, 8. Do NOT keep the scaffolded versions.

Replace `vercel.json` (Section 9) — `create-next-app` does not generate one by default.

### 5.3 Tailwind sanity check

Confirm `tailwind.config.ts` exists. Confirm `app/globals.css` contains the three Tailwind directives (`@tailwind base; @tailwind components; @tailwind utilities;`). Your Section 7 globals.css replacement keeps these.

---

## 6. The page template — `app/page.tsx`

Write this complete file to `app/page.tsx`. Fill the bracketed slots with content sourced from `CLAUDE.md` + student answers. NO JSX components. Plain HTML inside one default-exported function.

```tsx
// app/page.tsx — CCMB Session 1 landing page
// HTML in your voice. Edit any of the copy below directly.
// Per Tariq's "Unreasonable Effectiveness of HTML" — you don't need React
// to ship a landing page. You need words, a button, and a host. That's it.

export default function Page() {
  return (
    <main>
      {/* ──────────────────────────────────────────────────────────
          HERO
          - min-height: 100dvh + flex centering keeps CTA above the
            fold on every viewport (incl. landscape iPads).
          - Vertical padding clamps tighten on short viewports.
          - Hero image caps on both pixel AND vh units (max-width
            + max-height: 70vh) so it scales instead of pushing
            the CTA below the fold on small landscape screens.
          ────────────────────────────────────────────────────── */}
      <section className="hero">
        <div className="hero-grid">
          <div className="hero-text">
            <p className="eyebrow">[EYEBROW — short pill text from CLAUDE.md positioning, e.g. business category or 1-line context]</p>
            <h1 className="hero-h">[HEADLINE — 8-14 words, mechanism-as-headline or objection-as-headline preferred per CCMB TASTE. NOT outcome-as-headline.]</h1>
            <p className="hero-sub">[SUBHEAD — 1-2 sentences. Who you serve + what they get. Pulled from CLAUDE.md voice samples.]</p>
            <div className="hero-cta-row">
              <a
                href="[CTA_TARGET]"
                className="btn btn--primary"
              >
                [CTA_TEXT]
              </a>
            </div>
          </div>
          <div className="hero-right">
            {/* LCP image — preloaded in <head> via layout.tsx.
                fetchPriority="high" + decoding="async" per perf-v2 rule. */}
            <img
              src="/[HERO_IMAGE_FILENAME]"
              alt="[HERO_ALT — describe what's in the image, 1 sentence]"
              className="hero-box-img"
              fetchPriority="high"
              decoding="async"
              width="800"
              height="600"
            />
          </div>
        </div>
      </section>

      {/* ──────────────────────────────────────────────────────────
          PITCH — what you do, who it's for, why it matters.
          Pull voice + specifics from CLAUDE.md. NOT generic.
          ────────────────────────────────────────────────────── */}
      <section className="section">
        <div className="inner">
          <h2 className="display">[SECTION HEADER — e.g. "What I do" or punchier per voice]</h2>
          <div className="pitch-body">
            <p>[PITCH PARAGRAPH 1 — the real angle. Pulled from CLAUDE.md About-Me or Pitch section. 2-4 sentences.]</p>
            <p>[PITCH PARAGRAPH 2 — what's different about how you do it. Specific. Not "I help X do Y." 2-4 sentences.]</p>
          </div>
        </div>
      </section>

      {/* ──────────────────────────────────────────────────────────
          SOCIAL PROOF — OMIT THIS WHOLE SECTION IF STUDENT SAID
          "skip" / "starting fresh." Do not fabricate. Do not use
          generic placeholders. Section either ships real or doesn't ship.
          ────────────────────────────────────────────────────── */}
      <section className="section section--proof">
        <div className="inner">
          <p className="proof-line">[SOCIAL_PROOF_SENTENCE — verbatim from student answer]</p>
        </div>
      </section>

      {/* ──────────────────────────────────────────────────────────
          SECONDARY CTA — same target as hero CTA. Different copy
          so it doesn't read like a repeat. If the student is
          unsure, omit this section — primary CTA above is enough.
          ────────────────────────────────────────────────────── */}
      <section className="section section--cta">
        <div className="inner">
          <h2 className="display">[CTA_HEADER — e.g. "Ready when you are." or voice-matched]</h2>
          <div className="hero-cta-row">
            <a
              href="[CTA_TARGET]"
              className="btn btn--primary"
            >
              [CTA_TEXT_SECONDARY — different phrasing from hero CTA]
            </a>
          </div>
        </div>
      </section>

      {/* ──────────────────────────────────────────────────────────
          FOOTER — copyright + contact link. Always ships.
          ────────────────────────────────────────────────────── */}
      <footer>
        <div className="inner">
          <p>© [YEAR] [BUSINESS_NAME].</p>
          <p><a href="mailto:[CONTACT_EMAIL]">[CONTACT_EMAIL]</a></p>
        </div>
      </footer>
    </main>
  );
}
```

**Bracket-fill notes:**

- Pull `[HEADLINE]` from `CLAUDE.md` voice samples — do NOT generate from scratch with default LLM tone. If `CLAUDE.md` has a hook list or tagline section, prefer those. Per CCMB TASTE 2026-04-30 ("Mechanism-as-headline beats outcome-as-headline"), prefer mechanism or objection framings over outcome.
- `[HERO_IMAGE_FILENAME]` is the converted WebP from Section 10. If the student chose placeholder, set `src="/placeholder.svg"` and ship the SVG (a flat color block at the student's brand color or `#f8f4e9` cream by default).
- `[CTA_TARGET]` and `[CTA_TEXT]` from student answer Q3.
- `[CONTACT_EMAIL]` from `CLAUDE.md` if present, else `hello@[business-slug].com` placeholder with a comment telling them to swap it.
- Year: current year. Hardcode it, don't `new Date().getFullYear()` — keep the page static.

---

## 7. `app/globals.css` — baked-in defaults

Write this complete file to `app/globals.css`, overwriting the scaffolded version. The mobile rules from `mobile-pass.md` are embedded here. Add brand-color overrides at the top from the student's Q5 answer if provided.

```css
/* ============================================================
   globals.css — CCMB Session 1 default styles.
   The 10 mobile rules from mobile-pass.md are baked in.
   Edit freely. The structure here is opinionated but minimal.
   ============================================================ */

@tailwind base;
@tailwind components;
@tailwind utilities;

/* ──────────────────────────────────────────────────────────
   DESIGN TOKENS
   Override --accent in :root for brand color.
   ────────────────────────────────────────────────────── */
:root {
  --bg:           #fbf6ec;          /* cream */
  --ink:          #1c1c1c;          /* near-black */
  --muted:        #5a5a5a;
  --accent:       [BRAND_HEX_OR_DEFAULT];  /* default: #f35a1f orange */
  --rule:         #e7dfd0;
  --gutter:       32px;
  --max:          1200px;
  --radius:       14px;

  --font-sans:    system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  --font-display: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;

  --text-display: clamp(44px, 6vw, 88px);
  --text-h1:      clamp(40px, 5vw, 72px);
  --text-body:    clamp(17px, 1.4vw, 20px);
}

/* ──────────────────────────────────────────────────────────
   GLOBAL RESETS — including the 10 mobile rules baseline
   ────────────────────────────────────────────────────── */

/* RULE 1 (mobile-pass): anti-horizontal-scroll safety net.
   Nothing in the tree should ever cause sideways scroll on phone. */
html, body {
  overflow-x: hidden;
  max-width: 100%;
}

body {
  background: var(--bg);
  color: var(--ink);
  font-family: var(--font-sans);
  font-size: var(--text-body);
  line-height: 1.55;
  -webkit-font-smoothing: antialiased;
}

* { box-sizing: border-box; }

img, svg {
  display: block;
  max-width: 100%;
  height: auto;
}

a { color: inherit; text-decoration: underline; text-underline-offset: 3px; }
a:hover { color: var(--accent); }

/* ──────────────────────────────────────────────────────────
   LAYOUT PRIMITIVES
   ────────────────────────────────────────────────────── */

.section {
  padding: clamp(64px, 8vw, 120px) var(--gutter);
}

.inner {
  max-width: var(--max);
  margin: 0 auto;
}

.display {
  font-family: var(--font-display);
  font-size: var(--text-display);
  font-weight: 800;
  line-height: 1.05;
  letter-spacing: -0.02em;
  margin: 0 0 32px;
}

/* ──────────────────────────────────────────────────────────
   HERO
   - RULE 4 (mobile-pass): min-height: 100dvh + flex centering.
     CTA above the fold on every viewport incl. landscape iPad.
   - Vertical padding clamps on viewport height for short screens.
   - Hero image caps on both pixel AND vh units.
   ────────────────────────────────────────────────────── */
.hero {
  padding: clamp(48px, 8vh, 80px) var(--gutter);
  min-height: 100dvh;
  display: flex;
  align-items: center;
}

.hero-grid {
  width: 100%;
  max-width: var(--max);
  margin: 0 auto;
  display: grid;
  /* RULE 2 (mobile-pass): minmax(0, 1fr), never bare 1fr. */
  grid-template-columns: minmax(0, 1.15fr) minmax(0, 1fr);
  gap: clamp(32px, 4vw, 56px);
  align-items: center;
}

/* RULE 2 (mobile-pass): all grid/flex children get min-width: 0
   + max-width: 100%. Prevents min-content blowing out the column. */
.hero-grid > * {
  min-width: 0;
  max-width: 100%;
}

.eyebrow {
  font-size: 13px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--accent);
  margin: 0 0 18px;
  font-weight: 600;
}

.hero-h {
  font-family: var(--font-display);
  font-size: var(--text-h1);
  font-weight: 800;
  line-height: 1.05;
  letter-spacing: -0.02em;
  margin: 0 0 20px;
}

.hero-sub {
  font-size: clamp(18px, 1.6vw, 22px);
  color: var(--muted);
  margin: 0 0 32px;
  max-width: 56ch;
}

.hero-cta-row {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
  margin-top: clamp(22px, 3vh, 36px);
}

/* RULE 4 (mobile-pass): hero image caps on both pixel and vh. */
.hero-box-img {
  width: 100%;
  max-width: 560px;
  max-height: 70vh;
  height: auto;
  object-fit: contain;
}

/* ──────────────────────────────────────────────────────────
   BUTTONS
   ────────────────────────────────────────────────────── */
.btn {
  display: inline-block;
  font-weight: 600;
  font-size: 16px;
  padding: 14px 28px;
  border-radius: var(--radius);
  text-decoration: none;
  transition: transform 80ms ease, background 120ms ease;
}
.btn:hover { transform: translateY(-1px); }

.btn--primary {
  background: var(--accent);
  color: white;
}
.btn--primary:hover { color: white; opacity: 0.92; }

/* ──────────────────────────────────────────────────────────
   PITCH BODY
   ────────────────────────────────────────────────────── */
.pitch-body p {
  font-size: clamp(18px, 1.5vw, 22px);
  line-height: 1.55;
  max-width: 68ch;
  margin: 0 0 20px;
}

/* ──────────────────────────────────────────────────────────
   PROOF + SECONDARY CTA
   ────────────────────────────────────────────────────── */
.section--proof {
  background: white;
  border-top: 1px solid var(--rule);
  border-bottom: 1px solid var(--rule);
  text-align: center;
}
.proof-line {
  font-size: clamp(22px, 2.4vw, 32px);
  font-weight: 600;
  letter-spacing: -0.01em;
  margin: 0;
  max-width: 32ch;
  margin: 0 auto;
}

.section--cta {
  text-align: center;
}
.section--cta .hero-cta-row {
  justify-content: center;
}

/* ──────────────────────────────────────────────────────────
   FOOTER
   ────────────────────────────────────────────────────── */
footer {
  padding: 40px var(--gutter);
  border-top: 1px solid var(--rule);
}
footer .inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  font-size: 14px;
  color: var(--muted);
}
footer p { margin: 0; }

/* ──────────────────────────────────────────────────────────
   UTILITIES
   ────────────────────────────────────────────────────── */

/* RULE 10 (mobile-pass): grid-reorder bridge.
   Wrap children with .contents-wrap when you need a parent on
   desktop but flat children participating in a grid on mobile. */
.contents-wrap {
  display: contents;
}

/* RULE 3 (mobile-pass): desktop-only chrome.
   Decorative ambient elements get this class; they vanish on phone. */
.desktop-only {
  display: block;
}

/* ============================================================
   MOBILE OPTIMIZATIONS — the 10 mobile rules in CSS form.
   All mobile-specific overrides below this line.
   ============================================================ */

/* ---- Phone landscape / small tablet (≤720px) ---- */
@media (max-width: 720px) {

  /* RULE 2 (mobile-pass): collapse hero grid to single column.
     minmax(0, 1fr) prevents min-content overflow. Children
     keep min-width: 0 + max-width: 100%. */
  .hero-grid {
    grid-template-columns: minmax(0, 1fr);
    gap: 36px;
  }
  .hero-grid > * {
    min-width: 0;
    max-width: 100%;
  }

  /* RULE 7 (mobile-pass): inline-flex data rows stack vertically.
     Any element whose natural width exceeds ~320px gets a
     stacked phone variant. Hero CTA goes full-width for thumbs. */
  .hero-cta-row {
    flex-direction: column;
    width: 100%;
    min-width: 0;
  }
  .hero-cta-row .btn {
    width: 100%;
    max-width: 100%;
    min-width: 0;
    box-sizing: border-box;
    text-align: center;
  }

  /* RULE 3 (mobile-pass): desktop-only chrome hidden by default. */
  .desktop-only {
    display: none;
  }

  /* Footer stacks. Side-by-side doesn't fit 335px content area. */
  footer .inner {
    flex-direction: column;
    align-items: flex-start;
  }
}

/* ---- Phone portrait (≤600px) ---- */
@media (max-width: 600px) {

  /* RULE 6 (mobile-pass): section gutter 20px on phone portrait,
     not 32px. 32px eats 17% of a 375px viewport in padding alone. */
  :root {
    --gutter: 20px;
  }

  /* RULE 5 (mobile-pass): display-weight headline clamp floor 34px,
     not 44px. Two-word headlines need to fit one line at 375px. */
  :root {
    --text-display: clamp(34px, 8vw, 88px);
  }
  .hero-h {
    font-size: clamp(32px, 8.5vw, 72px);
  }

  /* Hero image cap tightens on phone portrait. */
  .hero-box-img {
    max-height: 50vh;
    max-width: 420px;
  }

  /* Section padding scales down. */
  .section {
    padding: 56px var(--gutter);
  }

  /* RULE 9 (mobile-pass): word-break on inline <code> + similar
     so long file paths / command flags don't blow the viewport. */
  code, kbd, samp, pre {
    word-break: break-word;
    overflow-wrap: anywhere;
  }
}

/* RULE 8 (mobile-pass): position: fixed (NOT sticky) for elements
   meant to be hidden until scroll. Sticky claims layout space at
   scrollY=0 even when visually translated off-screen. Fixed = no
   flow space. Default page has no sticky nav; this rule is here as
   a reference for student edits that add one.

   USAGE:
     .floating-nav {
       position: fixed;
       top: 12px; left: 12px; right: 12px;
       transform: translateY(-110%);  // hidden state
       transition: transform 240ms;
     }
     .floating-nav.is-visible {
       transform: translateY(0);
     }
*/
```

**Notes on rule coverage:**
- RULE 1 (overflow-x: hidden on html/body) → global resets section, lines under "GLOBAL RESETS".
- RULE 2 (minmax(0, 1fr) + min-width:0 children) → `.hero-grid` desktop AND mobile.
- RULE 3 (desktop-only chrome → display:none on mobile) → `.desktop-only` utility + media query.
- RULE 4 (min-height: 100dvh + flex centering + image vh caps) → `.hero` + `.hero-box-img`.
- RULE 5 (display headline clamp floor 34px on phone) → `:root --text-display` override at ≤600px.
- RULE 6 (section gutter 20px on phone portrait) → `:root --gutter` override at ≤600px.
- RULE 7 (inline-flex rows → flex-direction: column at ≤720px) → `.hero-cta-row` override.
- RULE 8 (fixed, not sticky, for hide-on-scroll elements) → commented reference at end. No nav ships by default, but the doc-comment ensures vibe edits get it right.
- RULE 9 (word-break on inline code) → `code, kbd, samp, pre` at ≤600px.
- RULE 10 (grid-reorder via grid-template-areas + display:contents bridge) → `.contents-wrap { display: contents; }` utility. No grid-areas in the default page (it's single-column on mobile already), but the bridge is ready when student adds desktop multi-column sections.

---

## 8. `app/layout.tsx` — head defaults

Write this complete file to `app/layout.tsx`. The 6 perf rules are embedded here. Conditionally include `dns-prefetch` based on CTA target (Q3 answer).

```tsx
// app/layout.tsx — CCMB Session 1 default <head>.
// Perf defaults from perf-v2.md are baked in:
//   - preconnect to font hosts (parallel TLS handshake)
//   - fonts via <link rel="stylesheet"> in <head>, never @import
//   - LCP image preload with fetchPriority="high"
//   - dns-prefetch for offsite CTA host (conditionally added)

import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "[BUSINESS_NAME] — [ONE_LINE_PITCH]",
  description: "[META_DESCRIPTION — 1-2 sentences, 150-160 chars, who you serve + what you do]",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        {/* PERF RULE 2 (perf-v2): preconnect to every external font host.
            Opens TLS handshake in parallel with HTML parsing so the
            actual stylesheet fetch lands on a warm connection.
            crossOrigin="anonymous" is required for font/CDN requests. */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        {/* If the brand kit uses Fontshare, also preconnect to it. Default
            template uses system fonts (no external host); leave the line
            below commented for when the student adds Fontshare in a future
            edit. */}
        {/* <link rel="preconnect" href="https://api.fontshare.com" crossOrigin="anonymous" /> */}

        {/* PERF RULE 4 (perf-v2): fonts via <link rel="stylesheet"> in <head>,
            NEVER @import in globals.css. @import is a chain dependency that
            blocks discovery on globals.css. <link> here is discoverable at
            HTML parse time and fetches in parallel with everything else.
            Default template ships system fonts. Uncomment + edit when the
            student adds web fonts. */}
        {/* <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=..." /> */}

        {/* PERF RULE 3 (perf-v2): preload the LCP image. Signals "this is
            critical" so the browser fetches it in parallel with HTML
            parsing instead of waiting until it parses the <img> tag mid-body.
            fetchPriority="high" puts it ahead of other fetches in the queue.
            Matches the <img> in app/page.tsx hero. */}
        <link
          rel="preload"
          as="image"
          href="/[HERO_IMAGE_FILENAME]"
          type="image/webp"
          fetchPriority="high"
        />

        {/* PERF RULE 6 (perf-v2): dns-prefetch for offsite CTA host.
            DNS lookup completes before the user clicks the CTA. Cheaper
            than preconnect (no TLS) — right for "user MIGHT click."
            CONDITIONALLY ADDED: only included when [CTA_TARGET] points
            to an offsite domain (Calendly, SamCart, Stripe Checkout, etc.).
            For mailto: or same-origin CTAs, omit this tag. */}
        [CONDITIONAL_DNS_PREFETCH]
      </head>
      <body>{children}</body>
    </html>
  );
}
```

**Bracket-fill notes:**

- `[BUSINESS_NAME]` and `[ONE_LINE_PITCH]` from `CLAUDE.md`.
- `[META_DESCRIPTION]` — write 150-160 chars in student voice. Avoid the forbidden phrases.
- `[HERO_IMAGE_FILENAME]` matches the same filename used in `app/page.tsx`. Both must be WebP per Section 10.
- `[CONDITIONAL_DNS_PREFETCH]` rules:
  - If `[CTA_TARGET]` starts with `mailto:` → omit the line entirely (delete the comment too — keep `<head>` clean).
  - If `[CTA_TARGET]` is same-origin (just a hash anchor like `#contact`) → omit.
  - If `[CTA_TARGET]` is offsite (Calendly, SamCart, etc.) → render `<link rel="dns-prefetch" href="https://[host]" />` where `[host]` is parsed from the URL.

---

## 9. `vercel.json` — perf headers default

Write this complete file to `vercel.json` at the project root. Pulled verbatim from `ccmb-landing/vercel.json`.

```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",

  "//": "PERF RULE 5 (perf-v2): explicit Cache-Control for static assets.",
  "//1": "Vercel's default ETag-based caching is fine for correctness but",
  "//2": "costs a 304 round-trip on every return visit. `immutable` +",
  "//3": "max-age=1yr means the browser uses disk cache instantly — no",
  "//4": "conditional GET. Safe because Next.js content-hashes its chunks",
  "//5": "and /public/ assets are commit-tracked in git.",

  "headers": [
    {
      "source": "/(.*)\\.(webp|avif|jpg|jpeg|png|gif|svg|ico|woff|woff2|ttf)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/_next/static/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

Do not modify the regex patterns. They're tested.

---

## 10. Image pipeline rules

When the student provides a hero image, process it before placing in `public/`.

### 10.1 Convert to WebP (PERF RULE 1)

Use whatever image-conversion tool is available in the environment. Preferred order:
1. `cwebp` (Google's WebP CLI) — `cwebp -q 90 input.jpg -o public/hero.webp` for the LCP hero (90, not 85, because it's the LCP). Other images use q85.
2. `sips -s format webp` on macOS as fallback.
3. ImageMagick `convert input.jpg -quality 90 public/hero.webp` if available.

**Quality settings:**
- Hero (LCP image): q90
- Any other raster image: q85
- SVG: pass through, no conversion needed.

### 10.2 Size to display dimensions + 2x retina

The hero image displays up to 560px wide on desktop (`.hero-box-img max-width: 560px`). Cap source at 1120px wide (2x retina). Anything larger is wasted bytes.

If the source is wider than 1120px, downscale during the WebP conversion:
```bash
cwebp -q 90 -resize 1120 0 input.jpg -o public/hero.webp
```
(The `0` for height = preserve aspect ratio.)

### 10.3 Originals never enter `public/`

After conversion, delete or move the original `.jpg`/`.png`. `public/` ships WebP only. The exception is `.svg` (which stays SVG) and `.ico` (for favicons — out of S1 scope).

### 10.4 Fallback if conversion fails

If the student provides a broken URL, a non-image file, or all conversion tools fail:
- Fall back to a placeholder. Create `public/placeholder.svg` with a 16:9 flat-color block at `var(--accent)` or `#f8f4e9` cream:
  ```xml
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 900">
    <rect width="1600" height="900" fill="#f8f4e9"/>
    <text x="50%" y="50%" text-anchor="middle" font-family="system-ui" font-size="64" fill="#1c1c1c">
      [BUSINESS_NAME]
    </text>
  </svg>
  ```
- Update `app/page.tsx` and `app/layout.tsx` to reference `/placeholder.svg` instead of the WebP filename.
- In the `<link rel="preload">` tag, change `type="image/webp"` to `type="image/svg+xml"`.
- Tell the student in the post-deploy message: "Used a placeholder image. Drop a real one in your folder named `hero.jpg` and ask me to swap it."

---

## 11. Deploy flow

### 11.1 Pre-deploy check

Confirm all three files exist and are non-empty:
- `app/page.tsx`
- `app/layout.tsx`
- `app/globals.css`
- `vercel.json`
- `public/[HERO_IMAGE_FILENAME]` (or `public/placeholder.svg`)

Run a quick build sanity check (don't wait the full build, just catch obvious syntax issues):
```bash
npx next build
```
If this fails, surface the error to the student in plain English (not the raw stack trace) and ask whether to attempt an auto-fix or stop.

### 11.2 Deploy command

Use the Vercel CLI in production mode:
```bash
npx vercel --prod --yes
```

The `--yes` flag accepts defaults for project name (uses folder name slugged) and scope (the student's connected account). Vercel CLI will:
- Detect the Next.js framework.
- Build remotely.
- Return a URL on success.

### 11.3 Vercel disconnected fallback

If the CLI command fails with an auth error (`Error: Not authorized` or similar), pause and coach the student:

> Hold on — Vercel isn't connected. Quick fix:
>
> 1. Open Claude Desktop → Settings → Connectors → Vercel.
> 2. If grey/disconnected, click **Reconnect** and authorize in the browser tab.
> 3. Confirm it goes green.
> 4. Paste back: `Vercel reconnected, continue.`

Wait for confirmation. Re-run the deploy. Do NOT auto-retry without student input — connection state is theirs to confirm.

### 11.4 Capture the URL + confirm 200 OK

After successful deploy, the CLI prints something like `https://yourname-ccmb.vercel.app`. Capture this exact URL.

Run a quick HTTP HEAD or GET to confirm the URL returns 200:
```bash
curl -sI [URL] | head -1
```

Expect `HTTP/2 200`. If you get 404, 500, or anything else, surface to the student and offer to re-deploy after a 30-second pause (sometimes Vercel's edge takes a moment to propagate).

---

## 12. Post-deploy student handoff

Once 200 OK is confirmed, print these three blocks in order. No prose padding. No "Congratulations!" No "I hope you enjoyed."

**Block 1 — the DONE line:**

```
DONE. Live at [URL]. Open it. That's yours.
```

**Block 2 — the skills-installed confirmation:**

```
You now have 3 new skills installed app-wide at ~/.claude/skills/:

  /ccmb-landing-page    — generate landing pages from any CLAUDE.md
  /ccmb-headline-writer — 10 headline variations for any topic
  /ccmb-sentence-editor — tightens copy, kills hedging

They work in any Claude Code project on your computer, forever.
```

**Block 3 — the fresh-chat hint:**

```
To use the new skills via slash commands, open a fresh Claude Code chat
(in any folder) and type "/" to see them in the menu. Skills installed
mid-chat aren't auto-discovered until a new session starts.
```

That's it. Stop. Do not append a summary, a "next steps" list, or a "let me know if you want anything else." The student moves to Step 7 of the runbook (review + edit).

---

## 13. Edit-flow (post-deploy changes)

The student will likely come back with edits during the live session. Cap at 3 rounds per the runbook S1-D5.

### Each edit round:

1. **Read current `app/page.tsx` fresh.** Don't trust working memory — the student may have edited the file directly between rounds.
2. **Apply the requested change.** Single-purpose. If they ask for "make the hero bigger and change the color and add a section" — do all three, but in one commit per round, not three round-trips.
3. **Re-deploy:**
   ```bash
   npx vercel --prod --yes
   ```
4. **Confirm new URL is live (200 OK).** Vercel auto-aliases new deployments to the same project URL — the URL string typically stays the same.
5. **Print one line:** `Updated. Reload [URL] to see the change.`

### Don't preserve old versions unless asked.

The student has git if they want history. Don't create `.bak` files. Don't keep "previous version" comments in the code. Edits are destructive by default.

### After 3 rounds:

If the student requests a 4th edit, tell them:

> We're at the live-session edit cap. Take this to a fresh chat after session, paste your CCMB folder context, and use vibe-editing patterns. The cheat sheet is at `references/vibe-editing.md` in the marketplace.

---

## 14. Cross-reference

For longer-form edits after Session 1 ends, the student gets the **vibe-editing cheat sheet**:

`references/vibe-editing.md` (in this repo at `https://github.com/heymitch/ccmb-marketplace/blob/main/references/vibe-editing.md`)

That cheat sheet covers:
- Starting a fresh chat with stale context handoff
- Specific edit patterns ("change X to Y" beats "make it better")
- Show-don't-tell prompts
- When to invoke `/ccmb-sentence-editor` vs editing inline
- Redeploy ritual
- When to re-run the full Session 1 trigger vs vibe-edit

The student-facing runbook references this cheat sheet at the end of its "Bonus — Vibe editing your page" section. Your job in S1 is to ship a working site; the cheat sheet handles everything after.

---

*End of Session 1 instruction bundle.*
