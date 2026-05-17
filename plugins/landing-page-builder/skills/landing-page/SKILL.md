---
name: landing-page
description: Build and deploy a landing page for your product or lead magnet — offer stack, copywriting, designed layout, images, and a live Vercel URL. Walks you through it section by section. Say "build my landing page", "make a sales page", "create a lead magnet page", "put my offer online", "/landing-page".
user-invocable: true
version: 1.0.0
---

# Landing Page Builder

> Say "build my landing page" or "make a sales page for my product"

Takes your offer and ships a live, well-designed landing page with email capture. You decide the copy and the offer; the design comes from Claude's `frontend-design` skill so the page looks intentional, not AI-generic.

## Preflight (Silent)

### 1. Config check
Read `landing-page-brief.md` for brand name, niche, product name, price, key outcome, audience avatar, objections, desired outcomes.
- **Missing or blank:** Ask the user inline for: what they're selling, who it's for, the price, and the one outcome it delivers. Save answers back to `landing-page-brief.md` before proceeding.
- **Exists:** Load context.

`landing-page-brief.md` lives at the workspace root. It is the single source of product context for this skill — create it on first run, reuse it after.

### 2. Voice check
Write in the user's own voice, not generic marketing voice. Defaults: closed em-dashes (`word—word`), directness over hedging, no fabricated proof or hype words. If a `## Voice Profile` block exists in `landing-page-brief.md`, load it and wrap all copy generation with `<VOICE>{profile}</VOICE>`. If the user has writing samples, ask for one and match it.

### 3. Tool check (concierge)
Silent scan for deployment path:
- **Vercel MCP available** (Settings > Integrations > Vercel) → deploy via MCP.
- **No Vercel MCP** → use the Vercel CLI path in `references/deploy-vercel.md` (`npx vercel`).
- Check `landing-page-brief.md` > `## Tool Preferences` for a saved deploy preference. If present, skip the question.

### 4. All clear — proceed.

## The Process

Walk the user through this in order. **One phase at a time. Get approval before moving on.** Never generate the whole page silently and dump it.

### Phase 1 — Offer Stack (do this FIRST, before any copy)

Copy is downstream of the offer. A vague offer produces a pretty page that doesn't convert.

Read `references/offer-stack.md` and walk the user through building their offer:
- Core promise (the one transformation)
- Deliverables (what they actually get)
- Stack items + value framing
- Price + price justification
- Risk reversal / guarantee
- Bonus(es), if any
- The single CTA (one action, named as a verb)

Output: a filled offer-stack block. Show it. Get a yes before writing copy.

### Phase 2 — Copywriting

Read `references/page-structure.md` for the section recipes, the page schema, and the section-order note. Pick the mode:
- **Lead-magnet mode:** one screen — headline + subhead + image + inline email form + footer. No pricing, no FAQ. The form *is* the CTA.
- **Full mode:** the 11-section LTO structure — Hero → Archetypes → Instructor → Proof → Problems → Mistakes → Everything Included → Bonuses → Last Nudge → FAQ → Guarantee. For paid products, cohorts, services.

**Before writing (full mode), do two things:**
1. **Ask for a swipe.** Request one sales/landing page the user admires. Model its *structure and tone* — never copy its words. If they have none, proceed with the default structure.
2. **Set traffic type.** Ask where traffic comes from. Warm (their own list/audience) → keep the default order (Instructor + Proof early). Cold → move Problems + Mistakes ahead of Instructor + Proof. This is a deliberate choice per the section-order note, not a default.

Write copy **section by section, in the user's voice**, using the offer stack from Phase 1. Rules:
- Headline = what they get / what they can do, not hype. No "revolutionary", "unlock", "game-changing".
- One idea per section. Specific beats clever.
- Archetypes must be *specific* reader identities, not "anyone who wants X".
- Keep Instructor (creator authority) and Proof (results/testimonials) separate — they're different levers.
- Mistakes section pulls the 3 from `landing-page-brief.md`; each gets "why it fails → how the product avoids it".
- FAQ section: generate with `references/faq-generator.md` — 15 Q&As, logistical + objection split, every answer clarifies and nudges.
- Proof, milestones, testimonials, and value estimates: real and defensible only. Missing → `[TESTIMONIAL PLACEHOLDER]`. Never fabricate or inflate.
- Closed em-dashes (`word—word`). Direct, not hedged.

Show each section's copy, iterate to approval, then move on.

### Phase 3 — Layout & Design (hand off to `frontend-design`)

Do **not** hardcode a brand or reach for default styling. Invoke the bundled **`frontend-design`** skill and build the page through it, passing:
- The approved copy and section order from Phase 2
- The audience + tone from `landing-page-brief.md`
- Constraint: single-page, mobile-responsive, fast, accessible, deployable as a static or Next.js page

Let `frontend-design` commit to a distinctive aesthetic direction for *this* product. The landing-page skill owns structure and copy; `frontend-design` owns typography, color, motion, and composition.

### Phase 4 — Images (ask, don't invent)

Explicitly ask the user what visual assets they have or want. Do not silently fabricate or leave broken `<img>` tags. For each image slot the layout needs (hero/product shot, logo, headshot, testimonial avatars, og:image):
- Ask: "Do you have a [X], should I generate one, or use a clean placeholder?"
- If generate: use an available image skill/tool and place into `public/`.
- If placeholder: use a clearly-marked, on-brand placeholder block (never a broken link).
- Always set a real `og:image` + meta tags for link sharing.

Confirm every image slot is resolved before deploy.

### Phase 5 — Deploy to Vercel

Read `references/deploy-vercel.md` and follow it. Summary:
1. Wire email capture using the **pluggable capture** pattern — the form posts to whatever provider the user uses (Kit / ConvertKit / Mailchimp / Formspree / custom). Ask for their form endpoint or ID; never hardcode one. If they don't have one yet, ship a no-op form with a clearly-marked TODO and a one-line instruction for adding it later.
2. Build locally, fix errors.
3. **Show the user a preview and get explicit approval before deploying.**
4. Deploy to *their* Vercel account (MCP or `npx vercel --prod`). Return the live URL.
5. Save the live URL + deploy method to `landing-page-brief.md`.

## Rules

- Offer stack before copy. Copy before design. Design before deploy. Never skip the order.
- Design comes from the `frontend-design` skill, not from hardcoded styles or a fixed brand.
- One phase at a time with approval gates. Never deploy without explicit sign-off.
- Real proof only. Placeholders are clearly marked; nothing is fabricated.
- No personal accounts, no hardcoded form IDs, no fixed domains — everything is the student's own.
- Closed em-dashes, direct voice, no hype words.
