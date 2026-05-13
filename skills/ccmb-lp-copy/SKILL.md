---
name: ccmb-lp-copy
description: Generate conversion-optimized landing page copy as a structured `copy.json` — reader's promise, hero, benefits, social proof, CTA, FAQ — using proven LP frameworks (PAS, AIDA, StoryBrand, Hormozi Grand Slam Offer, Schwartz 5 levels of awareness) matched to your product and audience. Use when you need landing page copy that converts, when you're staring at a blank page wondering what each section should say, when the headline isn't landing, or before /ccmb-lp-build. Triggers — "/ccmb-lp-copy", "write my landing page copy", "I need a headline that converts", "draft my hero", "what should my benefits section say", "write copy for my product".
---

# CCMB LP Copy

## 1. What this skill does

Turns a product brief into a structured `copy.json` file — the same shape `/ccmb-lp-build` reads to render a live page. The copy isn't generic template fill; the skill picks the right framework for your product, asks the right diagnostic questions for that framework, and drafts each section by pulling formulas from its bundled references. Headlines from `references/copy-patterns.md`. Frameworks from `references/frameworks.md`. Voice rules from `references/voice-rules.md`. Annotated examples from `references/swipe-file.md`.

Output: `./copy.json` in your current folder. Inputs: product brief (3-5 min interview) + optional `CLAUDE.md` for voice + optional `~/.ccmb-lp/design-system.md` for tone-mood mapping.

The skill is **opinionated.** It will reject your headline if it's a category cliché ("Revolutionize your workflow"). It will rewrite hype words even if you wrote them. It will refuse to ship a benefits section that lists features instead of outcomes. The whole point is to produce LP copy that doesn't read like LP copy.

## 2. When to invoke

- Before `/ccmb-lp-build` — every page run gets fresh copy through this skill.
- When you have a product but no copy yet — even before design — to lock the *argument* before the visual system.
- When an existing LP isn't converting and you want to rewrite from the framework up, not just polish sentences.
- When you've drafted a hero yourself and want a second pass that runs it through the voice + AI-pattern + framework filters.
- When you need just the headline + subhead (use `quick mode` — see §6).

**Do not run** if you only want to polish a single paragraph. That's `/ccmb-sentence-editor`. Do not run if you only want headline options. That's `/ccmb-headline-writer`. This skill writes the whole page argument.

## 3. What it produces

A single file: `./copy.json`. Shape depends on `mode`:

### Lead magnet mode (free download, email capture)

```json
{
  "slug": "your-skill-name",
  "mode": "lead-magnet",
  "meta": {
    "title": "Skill Name | Free Plugin",
    "description": "One-line description.",
    "og_title": "...",
    "og_description": "..."
  },
  "hero": {
    "headline": "Your Agent Can [Do The Thing]",
    "subheadline": "[What it does] — all through your agent. Install in 2 minutes."
  },
  "form": {
    "form_id": "USER_PROVIDED_OR_PLACEHOLDER",
    "button_text": "Get the Skill",
    "headline": "Enter your email to get the [Skill Name]",
    "subheadline": "Free download. No spam."
  },
  "footer": { "company_name": "..." }
}
```

### Full mode (paid product, course, cohort, service)

```json
{
  "slug": "...",
  "mode": "full",
  "meta": { ... },
  "hero": {
    "headline": "...",
    "subheadline": "...",
    "cta_text": "..."
  },
  "benefits": { "headline": "...", "items": [ { "title": "...", "body": "..." }, ... ] },
  "curriculum": { ... },        // optional, for courses
  "social_proof": { ... },      // optional
  "pricing": { ... },           // optional
  "urgency": { ... },           // optional
  "faq": { "headline": "...", "items": [ { "q": "...", "a": "..." }, ... ] },
  "form": { ... },
  "footer": { ... }
}
```

Every section is **draftable to "ship-ready" in this pass** — no `[FILL IN]` placeholders, no `[BRACKETS]`. If the skill can't write a real version of a section, it asks you the missing input rather than fabricating.

## 4. The 6-question interview

The skill leads with **6 diagnostic questions** that map onto the framework selector. Skip none. The point isn't to gather data — it's to *decide what the page argues* before drafting a word.

1. **What are you selling?** Name the offer. Not "marketing help" → "a 4-week cohort where founders ship their first paid AI product." Specificity collapses the rest of the interview.
2. **Who is it for?** Specifically. Not "small business owners." → "Solo consultants doing $5-15K/mo who don't have a productized offer yet." The skill rejects vague ICPs and asks again.
3. **What's the one-sentence argument?** Not the topic — the *take.* "AI tools won't replace consultants; consultants who can productize will replace ones who can't." This is the load-bearing question. If the user can't answer it, the skill refuses to draft and prompts them to work it out first (or use `/ccmb-headline-writer` to brainstorm).
4. **What's the price (if any)?** Free / lead magnet / `$X one-time` / `$X/month` / `book a call`. Price shapes framework — Hormozi Grand Slam Offer is for high-ticket; lead-magnet mode skips most of it.
5. **What's the strongest piece of social proof you have?** A metric (`47 founders shipped`), a testimonial, a known logo, a "featured in" line, or *"none yet"*. None-yet is fine — the skill drops the section cleanly rather than fabricating.
6. **What should the visitor DO?** Specific action + destination. "Book a 15-min call → calendly.com/me" / "Buy the course → checkout.gumroad.com/X" / "Get the free guide → email opt-in" / "Reply to me → mailto:". Vague CTAs ("get started") get rejected.

If `CLAUDE.md` has clear answers to 1, 2, or 3, the skill quotes them back and asks "right?" — doesn't re-ask. Saves time on repeat runs.

## 5. Framework selection (how the skill picks)

After the interview, the skill picks ONE primary framework. It does not blend. Mixing frameworks produces hedged copy. The picker:

| Product type | Primary framework | Why |
|---|---|---|
| Lead magnet, free tool, free skill install | **Single-promise hero** (no framework) | One headline, one subhead, one form. No room for PAS arc. |
| Low-ticket digital product ($7-97) | **PAS** (Problem → Agitate → Solution) | Short attention span; pain-first hook converts. |
| Mid-ticket course or cohort ($97-997) | **StoryBrand** (You're the hero, we're the guide) | Identity-driven; "be the founder who ships" beats feature lists. |
| High-ticket service or program ($1K+) | **Hormozi Grand Slam Offer** | Stack of value, risk reversal, urgency. Long-form scroll. |
| SaaS or recurring product | **AIDA** with feature/benefit translation | Attention via outcome, interest via category fit, desire via proof, action via free trial. |
| Anything for an unaware audience | **Schwartz 5 Levels of Awareness** — gate headline at the audience's actual level | Most-aware buyers: pitch the product. Least-aware: pitch the problem. |

The skill quotes its choice back: "Picking StoryBrand because your $497 cohort is identity-driven (founders shipping AI products) and the proof is testimonials not metrics. Switching to Hormozi if you push price above $1K." User can override ("Use PAS instead").

Full framework reference with each framework's structure: `references/frameworks.md`. The skill reads the relevant section for the picked framework, never all of them.

## 6. Modes

- **`full mode` (default)** — all 6 questions, complete page draft. ~12-18 min including framework selection and quality gates.
- **`quick mode`** — hero only (headline + subhead + CTA). 3 questions max. ~3-5 min. Use when you have everything else and just need the hook.
- **`rewrite mode`** — paste existing copy, skill identifies which framework it's loosely using (often none), suggests a framework, and rewrites. ~8-12 min. Use for an LP that isn't converting.

User picks mode at start ("`quick`" / "`full`" / "`rewrite`"). Default is `full` if unspecified.

## 7. Execution flow

1. Detect mode from user message. Default to `full`.
2. Check `./copy.json` — if exists, ask: overwrite / append (different slug) / cancel.
3. Read `CLAUDE.md` if present. Pull ICP, offer, voice phrases.
4. Read `~/.ccmb-lp/design-system.md` if present. Pull mood keywords for tone calibration.
5. Run the 6-question interview from §4 (or 3-question for `quick`). Confirm answers back in one sentence.
6. Pick framework per §5. Quote choice + rationale.
7. Read the relevant `references/frameworks.md` section.
8. Draft each section using formulas from `references/copy-patterns.md`:
   - **Headline:** apply 1-2 of the 25 patterns from `copy-patterns.md` §1 — pick what fits the framework.
   - **Subhead:** "what + how fast" template (`copy-patterns.md` §2). Cap at one sentence.
   - **Benefits:** 3-5 items, each = outcome + mechanism (`copy-patterns.md` §3). Reject feature lists.
   - **Social proof:** real metric / quote / logo only. If user said "none yet" — section omitted, not fabricated.
   - **FAQ:** 5-7 items from `references/objection-map.md` patterns. Address the 3 biggest objections inferred from price + ICP.
   - **CTA:** verb + outcome (`copy-patterns.md` §4). "Get the skill" / "Book a call" / "Buy the course" — not "submit" / "click here" / "download."
9. Apply `references/voice-rules.md` filters across the whole draft:
   - Closed em-dashes only (word—word, never word — word).
   - No hype list (revolutionary, game-changing, unleash, supercharge, transform your workflow, etc.) — the skill carries a kill list from `voice-rules.md`.
   - Directness > parallelism. Hedging gets cut.
   - Sign-your-name standard — would the user actually send this to a friend?
10. Optional: if `ai-hunter-v2` is installed in `~/.claude/skills/`, the skill suggests running it. Doesn't auto-invoke (cross-skill auto-call is brittle).
11. Write `./copy.json` with full structure.
12. Print the headline + subhead + CTA back to the user — the load-bearing 3 lines. Ask: "Land it as-is, tweak one line, or rewrite the hero?"
13. On approval, print: "Copy locked. Run `/ccmb-lp-build` next."

Target time: 12-18 min for `full`, 3-5 for `quick`, 8-12 for `rewrite`.

## 8. The 3 quality gates (always run)

After drafting, before writing the file, the skill runs three internal gates. A failure on any gate triggers a rewrite of just the failing section — not the whole page.

### Gate 1: Specificity check
- Every claim quantified or named where possible.
- "Helps you grow" → "Helps you ship your first paid product in 4 weeks."
- "Hundreds of founders" → exact number or "47 founders" or "300+ founders" — never "hundreds" or "many."
- No "scale," "leverage," "ecosystem," "synergy," "robust," "seamless," "best-in-class." Kill list in `voice-rules.md`.

### Gate 2: Reader-respect check (sign-your-name standard)
- Would the user actually paste this into a DM to a friend? If no, rewrite.
- No "Are you tired of X?" openers. (PAS allows pain-first, but ban the literal cliché.)
- No bracketed `[FILL IN]` anywhere. Either fill it real or remove the section.
- No "Imagine if..." subjunctive — concrete present tense.

### Gate 3: Framework integrity
- The chosen framework actually shows up. PAS pages must have a real problem statement and real agitation, not a soft "here's our solution" disguise.
- StoryBrand pages name the visitor as hero somewhere in the hero or first section — not the brand as hero.
- Hormozi pages have a value stack (3+ named bonuses with prices) and a risk reversal. If those are missing because the user doesn't have them yet, the skill drops to PAS and tells the user.

## 9. Composition with other skills

- **`/ccmb-lp-design`** — read its `design-system.md` for tone-mood pairing. If cache missing, this skill prompts user to run it but **can also proceed without it** (defaults to "neutral confident" tone).
- **`/ccmb-lp-build`** — reads the `copy.json` this skill writes. Hard dependency.
- **`/ccmb-headline-writer`** — for hero-only iteration. The user can run `headline-writer` first to brainstorm 10 options, pick one, then run this skill which uses the picked headline.
- **`/ccmb-sentence-editor`** — post-hoc paragraph polish. After this skill ships, use `sentence-editor` for the inevitable "this benefit body feels off" tweak.
- **`ai-hunter-v2`** (if installed) — the skill suggests running it as a final filter. Optional, not required.

## 10. Failure modes and recovery

- **User can't answer Q3 (one-sentence argument).** The skill refuses to draft. It explains why: drafting a page without a take produces "pretty essay that circles a concept without landing" (from the newsletter-process insight). It offers two paths: (a) brainstorm with `/ccmb-headline-writer`, (b) journal for 5 min and come back. Does not fabricate.
- **User's price + ICP suggests Hormozi but they have no bonuses to stack.** The skill drops to PAS and tells the user: "Hormozi needs 3+ bonuses with named values. You have one offer. Using PAS — it'll convert fine for cold traffic at this price."
- **User pastes their existing copy in `rewrite mode` and it's already strong.** The skill says so and suggests just running it through `/ccmb-sentence-editor` for polish instead of full rewrite. Saves the user 10 min.
- **`CLAUDE.md` voice is sparse.** The skill asks 2 extra calibration questions ("paste a paragraph you wrote that *sounds like you*" / "name 3 phrases you'd never say"). Uses those as voice anchor.
- **The headline draft is a category cliché.** Skill self-rejects and rolls. ("Revolutionize your X" / "The ultimate guide to Y" / "Unlock the secret to Z" → all auto-rejected per `voice-rules.md` kill list.)
- **User wants 10 headline options instead of one.** Redirect to `/ccmb-headline-writer` — that skill exists for exactly this.

## 11. References (bundled in this skill folder)

| File | Contents |
|---|---|
| `references/frameworks.md` | PAS, AIDA, StoryBrand, Hormozi Grand Slam Offer, Schwartz 5 Levels of Awareness — full structures + when to use which |
| `references/copy-patterns.md` | 25 headline formulas, hero patterns, CTA patterns, benefits/social-proof/FAQ section formulas |
| `references/voice-rules.md` | Em-dash style, hype kill list, directness rules, sign-your-name standard, AI-pattern flags |
| `references/swipe-file.md` | 6 annotated high-converting LPs with the structural moves called out |

Skill reads only the references relevant to the picked framework + the always-on `voice-rules.md`. Progressive disclosure — full bundle is bigger than context budget per call.

## 12. Versioning

Fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/SKILL.md`. References fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lp-copy/references/<filename>`.

Update with: "Update my CCMB skills to the latest version."
