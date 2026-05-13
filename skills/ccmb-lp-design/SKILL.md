---
name: ccmb-lp-design
description: Generate a reusable brand design system — color tokens, typography, spacing, component primitives — in 4-6 minutes via a short interview, then cache it so every future landing page reuses it. Use when starting a new brand, when no design system exists yet, when the user wants every page to feel like one product, or before running /ccmb-lp-copy or /ccmb-lp-build. Triggers — "/ccmb-lp-design", "design my brand", "create a design system", "make a brand kit", "I need brand colors and fonts", "design tokens".
---

# CCMB LP Design

## 1. What this skill does

Generates a brand design system as **code, not Figma**. You answer 4-5 short questions, Claude picks a coherent palette + type + spacing + radii, writes `design-tokens.json` and `design-system.md` to a cache folder, and renders a sample Hero in `preview.html` so you can eyeball it before committing. Total time: 4-6 minutes.

The output is the source of truth for every page you build after this. `/ccmb-lp-copy` reads it to match copy tone to mood. `/ccmb-lp-build` reads it to wire `tailwind.config.js` and component primitives. The same brand on every page, with zero manual sync.

Run once per brand. Re-run when you rebrand, want to A/B a different mood, or fork a sub-brand off your main one.

## 2. When to invoke

- Starting a fresh brand from scratch (blank workspace, no Vercel deploys yet).
- Before the first run of `/ccmb-lp-copy` or `/ccmb-lp-build` — they'll prompt you back here if the cache is empty.
- Rebranding — colors, fonts, or mood are changing and you want every future page to inherit the new direction.
- Forking a sub-brand — a product-specific palette that should be cousin-consistent with your main brand without being identical.
- Iterating on mood — you shipped one page, the brand feels off, you want to redo the system before more pages compound the problem.

**Do not run** if you already have a cached system and you're just shipping another page. Run `/ccmb-lp-copy` and `/ccmb-lp-build` instead. The design step is the slow step; cache hits are why subsequent pages ship in 9-12 minutes.

## 3. What it produces

After this skill runs, your `~/.ccmb-lp/` cache folder contains:

- **`design-tokens.json`** — machine-readable tokens. Keys: `colors` (background, surface, primary, accent, text_primary, text_secondary, text_tertiary), `fonts` (display, body), `radii` (sm/md/lg/full), `spacing_scale` (the rhythm in rem units), `shadows`, `mood_keywords`. This is what `/ccmb-lp-build` writes into `tailwind.config.js`.
- **`design-system.md`** — human-readable spec. Why each color was picked, what the fonts pair, when to use which radius, voice/visual mood mapping. Editable. You can vibe-edit this between runs of `/ccmb-lp-copy` to shift tone without re-running the design interview.
- **`preview.html`** — a single-file HTML render of a sample Hero (headline, subhead, CTA, product image slot, footer) using the chosen tokens. Open it in a browser. If it doesn't feel like your brand, say so — the skill re-rolls without re-asking the interview questions.
- **`component-shapes.md`** — short notes on Hero, KitForm, Benefits, Footer layouts at this brand's mood (which one feels right for "warm and editorial" vs "stark and technical"). `/ccmb-lp-build` reads this to pick the right Hero variant.

The cache lives at `~/.ccmb-lp/` (user-global, not folder-scoped). Multiple brands? Use sub-folders: `~/.ccmb-lp/<brand-slug>/`. The skill asks for a brand slug if it detects a non-empty cache.

## 4. The 5 inputs the skill needs

Two come from `CLAUDE.md` if present. The rest from a 4-5 question interview. If `CLAUDE.md` is missing the skill **does not refuse** — it asks the questions inline. You're building a brand; the brand context can live in the interview answers, which get written to `design-system.md` for future reference.

**From `CLAUDE.md` (if present):**

1. **Brand name + ICP** — who the brand serves. Shapes mood. "Designer founders shipping micro-SaaS" lands different from "general contractors picking power tools."

**From the interview:**

2. **Mood in 3 words.** Not adjectives like "professional" or "clean" (everyone says those). Real words: "warm editorial library", "neon arcade", "stark technical lab", "Sunday-morning kitchen", "midnight blue jazz club". Three words that *feel like* the brand, not describe it.
3. **Two-to-three reference URLs.** Sites the user would be proud to look like. Don't say "I want to look like Apple" — paste 2-3 URLs. The skill will fetch them mentally, extract the patterns (palette mood, type pairing, density, white space rhythm), and synthesize.
4. **Color preference or constraint** — "let Claude pick" / "I want it to be dark mode" / "must include this hex from my logo: #F35A1F" / "no blue, my last brand was blue." One of those four.
5. **Type preference or constraint** — "let Claude pick" / "serif headlines + sans body, like the New Yorker" / "monospace everywhere, very technical" / "must use Inter, our company font."

If the user says "let Claude pick" for both 4 and 5, the skill picks based on mood. That's the default for fast iteration.

## 5. Execution flow

What happens when you invoke the skill — 9 steps from interview to preview.

1. Check `~/.ccmb-lp/design-tokens.json`. If exists and non-empty, ask: "You already have a design system cached. Re-do it (`overwrite`), fork to a sub-brand (`new <slug>`), or just preview the current one (`preview`)?" Wait for choice.
2. Read `CLAUDE.md` if present. Pull brand name and ICP if available. Skip those interview questions if answered.
3. Run the 4-5 question interview from §4. Cap at 5 questions. If the user pastes a wall of context, the skill extracts answers and confirms back ("I read: mood = neon arcade, refs = X/Y/Z, color = dark mode + must include #F35A1F, type = let me pick. Right?").
4. Generate tokens. Claude picks:
   - **Background:** the dark or light foundation. Always include a `surface` color one step away from background for cards / sections.
   - **Primary:** the main accent — buttons, CTAs, highlights. High contrast against background.
   - **Secondary accent:** a second hue for variety. Used sparingly — links, hover states, decorative glows.
   - **Text:** three tiers (primary at full contrast, secondary at ~50%, tertiary at ~30%). White-on-dark or near-black-on-light.
   - **Fonts:** display + body pair. Body must be readable at 16px on mobile. Display can be expressive.
   - **Radii:** consistent scale. Soft (8-12px) for editorial, sharp (0-4px) for technical, pill (full) for playful.
   - **Spacing:** 4px or 8px base unit. Always include `xs / sm / md / lg / xl / 2xl` keys.
   - **Shadows:** 0-3 levels. Optional — flat designs skip shadows entirely.
5. Write `design-tokens.json` to `~/.ccmb-lp/[<slug>/]design-tokens.json`.
6. Write `design-system.md` to the same folder — with the *rationale* for each pick, not just the values. ("Coral primary because the mood is `Sunday-morning kitchen` and warm earth tones beat conventional 'tech blue' here. Paired with deep navy surface instead of pure black to keep the editorial feel.")
7. Render `preview.html` — a single-file HTML page with inline `<style>`, no build step. Shows: Hero (headline + subhead + image slot + CTA), a sample KitForm, a Benefits grid, a Footer. Uses *placeholder copy* (`Your Headline Here`, etc.) — the skill never fabricates brand copy at this stage. Open it: `open ~/.ccmb-lp/[<slug>/]preview.html`.
8. Print the preview path and ask: "Does this feel like your brand? `yes` to lock it in, `re-roll` to regenerate with the same answers, `tweak [thing]` to adjust ('darker', 'more contrast', 'different primary'), or `redo` to re-run the interview."
9. On `yes`, write `component-shapes.md` with notes on which Hero / Benefits / Footer variants the mood points toward. Print: "Design system locked. Run `/ccmb-lp-copy` next." Done.

The interview, generation, preview, and tweak loop should total 4-6 minutes. If the user is on tweak round 3, the skill suggests: "We're iterating in circles. Re-do the interview or just `yes` this — you can always vibe-edit `design-system.md` later."

## 6. The mood-to-tokens mapping (how Claude picks)

The skill maps mood keywords to token directions. Not a deterministic lookup — guidance for Claude's generation.

| Mood family | Likely direction |
|---|---|
| Warm / editorial / library / Sunday | Off-white or cream background, deep navy or burgundy surface, terracotta or mustard accent, serif display + sans body, soft radii (10-16px), no shadows, generous spacing |
| Stark / technical / lab / brutalist | Near-black background, dark slate surface, single high-contrast accent (often green or cyan), monospace display + system sans body, sharp radii (0-4px), no shadows, tight spacing |
| Neon / arcade / synthwave / late-night | True black background, dark purple or navy surface, electric magenta or cyan accent (often two accents), display sans + body sans, medium radii (8-12px), glow shadows, medium spacing |
| Calm / clinical / Notion-flavored | True white background, light gray surface, single subdued accent (often blue or green), sans throughout, soft radii (6-10px), subtle shadows, generous spacing |
| Playful / bouncy / Saturday-morning | Cream or pastel background, brighter pastel surface, two cheerful accents (warm + cool), rounded display + readable sans, pill or large radii (16-24px), playful shadows, medium spacing |
| Premium / luxury / quiet | Off-black or deep neutral background, slightly lighter surface, single muted accent (often gold or copper), serif display + serif body or refined sans, soft radii (4-8px), no shadows or one deep shadow, generous spacing |

If the user's mood doesn't fit any family cleanly, the skill **picks the closest two and blends.** It always names the blend in `design-system.md` ("Hybrid of warm editorial and premium quiet — explains why the radii are softer than pure technical but the type is more reserved than full editorial.")

## 7. What the preview shows (and doesn't)

`preview.html` is a static HTML page with:

- A hero section (headline placeholder, subhead placeholder, CTA button using primary color, optional image slot showing a gray placeholder block)
- A 3-column benefits grid (placeholder titles and body)
- A form section (email input + button using KitForm visual style)
- A footer (links placeholder, brand name placeholder)

It does **not** show your real copy. It shows the *visual system.* Don't get hung up on whether the placeholder headline reads well — judge: does the *feel* match the mood you asked for?

If the feel is wrong, say what's wrong. The skill takes vague feedback ("too corporate", "feels generic", "needs more warmth") and re-rolls. It also takes specific feedback ("primary should be more orange, less red") and applies it surgically.

## 8. Failure modes and recovery

- **No `CLAUDE.md` and the user skips the brand name question.** The skill defaults the brand slug to `default` and proceeds. `~/.ccmb-lp/default/` is the cache. User can rename later (`mv ~/.ccmb-lp/default ~/.ccmb-lp/<real-slug>`).
- **User pastes 8 reference URLs.** The skill picks 3 — first, most distinctive, and one that contrasts (to avoid generating an average of similar sites). Tells the user which 3 it used and why.
- **Preview renders blank or broken in browser.** Almost always a CSS variable scope issue. The skill checks: is `:root` defining all referenced variables? Are font imports using `<link>` not `@import`? Fixes and re-renders.
- **User wants Figma export.** Out of scope. This skill generates code-as-source-of-truth. If the user needs Figma, point them at the `figma-to-vercel` skill family instead — it's a different pipeline.
- **User has a logo they want the palette extracted from.** Supported. User pastes a logo file path or URL → skill samples 3-5 dominant colors → uses those as palette seeds. The mood interview still runs, but constrained by the extracted palette.

## 9. Composition with other skills

- **`/ccmb-lp-copy`** — reads `~/.ccmb-lp/design-system.md` to match copy tone to visual mood. Will prompt you to run this skill first if cache is empty.
- **`/ccmb-lp-build`** — reads `~/.ccmb-lp/design-tokens.json` to wire `tailwind.config.js` and reads `component-shapes.md` to pick variants. Will prompt you here first if cache is empty.
- **`/ccmb-landing-page`** (existing monolith) — does design + copy + build in one pass. Use that if you want the fast single-shot path. Use this skill family if you want explicit separation and reusable design across multiple pages.

## 10. Versioning

Fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-design/SKILL.md`. Installs to `~/.claude/skills/ccmb-lp-design/SKILL.md` and works in any folder.

Update with: "Update my CCMB skills to the latest version."
