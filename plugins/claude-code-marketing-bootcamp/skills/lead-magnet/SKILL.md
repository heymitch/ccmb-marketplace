---
name: lead-magnet
description: Run the full Lead Magnet Launch System — Claude Code-native. Walks idea → name → mockup → landing copy → preview → onboarding sequence → promo email → build the asset → wire opt-in + deliver. Covers document/asset-style magnets (PDF, checklist, template, swipe file, cheat sheet, short guide, spreadsheet, prompt pack). Kit (ConvertKit) canonical; Substack and other providers as adapters. Use when the user wants a lead magnet, opt-in incentive, free guide/PDF/asset, content upgrade, thank-you asset, to launch a lead magnet, or to turn content into an email-capture funnel. NOT for interactive "free tools" (quiz/calculator/assessment) — those have a separate skill.
---

# Lead Magnet Launch System

A lead magnet is not a file. It's a **position in a funnel**: something valuable enough to trade an email for, delivered the instant the email is captured, that begins onboarding the subscriber.

This skill is the Claude Code-native execution of the Lead Magnet Launch System playbook. It runs all 8 steps. You make the decisions; Claude does the heavy lifting. The user can run the whole sequence or jump to any step.

Canonical methodology, prompts, copy formulas, and promotion surfaces live in [PLAYBOOK.md](PLAYBOOK.md). Build/deploy code patterns live in [PATTERNS.md](PATTERNS.md). **Read PLAYBOOK.md before Step 1.**

## The Launch Brief (do this first, maintain throughout)

Open a running **Launch Brief** — a markdown block you keep updated and echo back on request. It is the resumable state of the build. If the session runs out, the user pastes it into the next one to resume.

```
## Launch Brief — <project>
Audience:            <who>
Frustrations:        <1-3>
Category:            <from table below>
Idea:                <chosen idea>
Name:                <chosen name>
Format / build path: <Docs→PDF | code-native HTML | Sheets>
Platform:            <Kit | Substack | other>  (Kit canonical)
Landing copy:        <done? link>
Preview:             <done? link>
Onboarding seq:      <done? where>
Promo email:         <done? where>
Asset:               <done? path/URL>
Wiring + deploy:     <done? route>
Next step:           <n>
```

## Lead magnet categories

Classify the idea before building — category drives the build path.

| Category | Examples | Build path |
|---|---|---|
| **Printable / PDF asset** | Reference guide, glossary, one-pager | Code-native HTML w/ print CSS **or** Docs→PDF |
| **Checklist** | "5-minute X audit" | Docs→PDF or code-native one-pager |
| **Template / framework** | Fill-in doc, named method | Docs→PDF or public Doc link |
| **Swipe file / resource list** | Curated examples, link list | Docs→PDF or public link |
| **Cheat sheet** | Dense single-page reference | Code-native (print CSS) or Docs→PDF |
| **Short guide** (<2,000 words) | Narrow how-to | Docs→PDF or code-native |
| **Spreadsheet / tracker** | Planner, simple calculator | Google Sheets (shareable link) |
| **Scripts / prompts** | Swipeable prompt pack | Docs→PDF or public link |

**Out of scope:** interactive **free tools** (quiz, assessment, calculator,
generator — anything with scoring/logic/a result screen) are a **separate
skill**. If the idea is a free tool, say so and stop — don't build it here.

Avoid (don't convert): long ebooks, video courses, vague "ultimate guides."

**Build path decision:** if the target is a repo/site we can deploy (Vercel etc.) and the category is Printable/cheat sheet, prefer **code-native** — it's the differentiated acceleration. Otherwise the manual **Docs→PDF + Kit** path in PLAYBOOK.md is faster and fine.

## The 8 steps

Run in order, or jump on request. Update the Launch Brief after each.

1. **Brainstorm lead magnets** — use the idea-generation prompt in PLAYBOOK.md §1. Apply the three traits (specific / quick to consume / immediately useful) and the formula: *Help [specific person] achieve [specific outcome] in [specific timeframe] using [specific format].* Output 10, recommend 3.
2. **Name it** — generate names; pick one specific enough to imply the outcome (PLAYBOOK.md §2).
3. **Mockup image prompt** — produce a prompt for a cover/preview image. Generate the image only if an image tool is available; otherwise hand off the prompt.
4. **Landing page copy** — headline / subheadline / what's-inside bullets / who-it's-for, using the copy formula in PLAYBOOK.md §3.
5. **Visual preview of the landing page** — a code-native HTML mock built on the host design system (reuse its token file; do not duplicate tokens). See PATTERNS.md §1 for design-system reuse + print-safe inversion if printable.
6. **Onboarding sequence** — the 5-email Kit sequence (immediately / day 2 / day 4 / day 7 / day 10) per PLAYBOOK.md §4. Email 1 delivers the asset.
7. **Promotional email** — the announcement (+ optional reminder + social-proof) emails, PLAYBOOK.md §5. Note these double as social posts.
8. **Build the asset** — produce the actual lead magnet for its category. For code-native: build the HTML, then **wire the opt-in and deliver** (PATTERNS.md §2 fire-and-redirect for Kit/Substack), **register the deploy route** (PATTERNS.md §3), and **save the page↔asset pairing to memory** (PATTERNS.md §4). Then verify (print preview if printable, test opt-in on a deploy preview, mobile stacking).

## Platform: Kit canonical, adapters documented

Default to **Kit (ConvertKit)**: landing page (Grow → Landing Pages & Forms), automation (Automate → Visual Automations, trigger = subscribes to form), sequence (Send → Sequences). Full Kit steps in PLAYBOOK.md §6.

If the repo already wires a different provider (e.g. Disciple AI uses Substack's `?nojs=true` endpoint), use that as an **adapter** — same fire-and-redirect pattern, swap the `action` + hidden fields (PATTERNS.md §2). Detect before assuming.

## Promotion: the 4 evergreen surfaces

After the asset ships, place the offer on all four (PLAYBOOK.md §7): welcome email, email preamble, about page, recurring social PS. The funnel is inert until it's promoted.

## Anti-patterns

- ❌ Building before classifying the category — category dictates the build path.
- ❌ Code-native when there's no repo to deploy and a Doc→PDF would ship today.
- ❌ Duplicating the host design system instead of linking its token file.
- ❌ Pure black-and-white "for print" — invert color positions, keep brand hues (PATTERNS.md §1).
- ❌ Adding a backend when the email provider already handles email (use fire-and-redirect).
- ❌ Shipping the asset and skipping Step 6/7 + the 4 promotion surfaces — an undelivered, unpromoted asset is dead weight.
- ❌ Losing state — keep the Launch Brief current; it's the resume point.

## Reference

- [PLAYBOOK.md](PLAYBOOK.md) — canonical traits, formula, the exact idea/content prompts, landing + email copy formulas, Kit setup, the 4 promotion surfaces.
- [PATTERNS.md](PATTERNS.md) — code-native build: print-safe inversion CSS, fire-and-redirect form (Kit + Substack adapter), vercel.json route, memory template.
