# Page Structure

Two modes. Pick based on the offer (Phase 1).

## Mode: lead-magnet

One screen. Everything in the hero.

```
┌─────────────────────────────────────────┐
│  Headline (left)    │  Asset image      │
│  Subheadline (left) │  (right)          │
├─────────────────────┴───────────────────┤
│   "Enter your email to get the [asset]" │
│   [ email input ] [ Get the [asset] ]   │
│   No spam. Unsubscribe anytime.         │
├─────────────────────────────────────────┤
│              Footer                     │
└─────────────────────────────────────────┘
```

- No CTA button separate from the form — the form is the CTA.
- No benefits/FAQ/pricing/urgency. Resist the urge to add sections.
- Subhead sits under the headline in the left column, not centered full-width.

## Mode: full

For paid products, cohorts, services. The proven low-ticket-offer (LTO) structure — 11 sections, in this order. Include only what the offer earns; don't pad.

1. **Hero** — headline (the promise) + subheadline (specifics + for-whom) + one CTA that scrolls to the offer/checkout. Optional: a VSL embed or a high-quality product mockup.

2. **Archetypes** ("which one are you") — 2–3 *specific* reader types who should buy. Each: a one-line identity + the pain that defines them + the outcome they want. Reader self-identification raises relevance and is a real conversion lift. The more specific the archetype, the stronger. (Internally this is the "Quiz" section in classic LTO templates — it is not an interactive quiz, it's self-identification.)

3. **Instructor** — who created this and *why they're worth listening to*. Story + authority + trust. This is the creator's credibility lever and is psychologically distinct from customer proof — keep them separate.

4. **Proof** — tangible result bullets: objective milestones, numbers, outcomes that establish competence on this exact topic. Hard facts, not adjectives. Plus customer testimonials if real. Missing testimonials → `[TESTIMONIAL PLACEHOLDER]`, never fabricated.

5. **Problems** — 7–10 major pain points the audience actually feels, in their own words. A scannable list. This is the agitation.

6. **Mistakes** — the 3 biggest mistakes people make trying to solve this on their own, and how the product avoids each. This is the mechanism: it pre-frames objections and positions the product as the corrective, not just "a solution." Pull the 3 from `landing-page-brief.md` (the `Top 3 objections` / mistakes fields).

7. **Everything Included** — detailed breakdown of modules/lessons/assets with the key takeaway of each. Attach a dollar value estimate per component where credible — value-stacking anchors the price before it's shown.

8. **Bonuses** — additional fast-action bonuses. One strong, outcome-tied bonus beats three weak ones. State the value of each.

9. **Last Nudge** — the close. Restate the core promise, the transformation, the single CTA. Add a deadline/urgency line *only if a real deadline exists* — skip it otherwise. No fake scarcity.

10. **FAQ** — generate via `references/faq-generator.md`: 15 Q&As split logistical (how it works) vs buying objections (will this work for *me*). Every answer clarifies *and* nudges toward the buy. Source from `landing-page-brief.md`; real proof only.

11. **Guarantee** — the risk reversal as its own section. Default: 14-day, no-questions-asked. State it plainly; the page should feel safe to buy from right before and after the CTA.

### Section-order note (read before writing)

This order leads with **Instructor + Proof early (3–4), before Problems/Mistakes (5–6)**. That is correct for **warm traffic** — a creator selling to their own list/audience who already trust them (the typical CCMB student case). For **cold traffic**, you earn the right to talk about yourself by agitating the problem first: move Problems + Mistakes ahead of Instructor + Proof. Decide this with the user based on where their traffic comes from — make it a choice, not an accident.

## Content schema (hand to `frontend-design` as the structure)

```
slug, mode ("lead-magnet" | "full")
meta:        title, description, og_title, og_description, og_image
hero:        headline, subheadline, cta_text, (vsl_embed?|mockup?)
archetypes:  items[ {label, identity_line, pain, desired_outcome} ]
instructor:  name, story, authority_points[]
proof:       milestones[], testimonials[ {text, name, title} ], stats[ {number, label} ]
problems:    items[]                       # 7–10
mistakes:    items[ {mistake, why_it_fails, how_product_avoids_it} ]   # 3
included:    modules[ {title, takeaway, value?} ]
bonuses:     items[ {title, description, value} ]
last_nudge:  headline, restated_promise, cta_text, deadline?
faq:         items[ {q, a} ]
guarantee:   terms                          # default: 14-day no-questions
capture:     provider, endpoint_or_form_id  # pluggable — see deploy-vercel.md
footer:      company_name, year
```

`frontend-design` owns how this *looks*. This file owns what sections exist and in what order.

## Copy rules (apply to every section)

- Headline = the result, not the hype. No "revolutionary / unlock / 10x / game-changing".
- One idea per section. Cut anything that doesn't move the reader toward the CTA.
- Specific numbers and nouns beat adjectives.
- Closed em-dashes (`word—word`). Direct sentences, no throat-clearing.
- Never fabricate proof, names, logos, milestones, or stats. Placeholders are clearly marked.
- Value estimates (sections 7–8) must be defensible, not invented inflation.
