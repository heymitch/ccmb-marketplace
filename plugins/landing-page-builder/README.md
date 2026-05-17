# Landing Page Builder

A Claude plugin that takes your offer and ships a live, well-designed landing
or sales page — Claude Code-native. You make the decisions; Claude does the
copywriting, design, and deploy.

It runs five phases, in order, with approval gates:

1. **Offer Stack** — build/strengthen the offer before any copy (a weak offer
   is the #1 reason pages don't convert)
2. **Copywriting** — lead-magnet mode (one screen) or the proven 11-section
   sales-page structure: Hero → Archetypes → Instructor → Proof → Problems →
   Mistakes → Everything Included → Bonuses → Last Nudge → FAQ → Guarantee
3. **Design** — hands off to the bundled `frontend-design` skill so the page
   looks intentionally designed, not AI-generic. No hardcoded brand.
4. **Images** — asks what you have; never fabricates or ships broken images
5. **Deploy** — pluggable email capture (Kit / ConvertKit / Mailchimp /
   Formspree / custom) and a live URL on **your** Vercel account

Includes a 15-question FAQ generator (logistical + buying-objection split,
every answer clarifies *and* nudges) and a swipe-driven, traffic-aware copy
process (warm vs cold traffic changes the section order).

---

## Install

1. Download `landing-page-builder.zip`. Keep it zipped. If it unzips, zip it
   back up.
2. Open the Claude desktop app.
3. Click the **Customize** icon in the sidebar.
4. Go to: **Customize → Personal Plugins → Add Plugin (+) → Upload Plugin**.
5. Select `landing-page-builder.zip`.

## Use

Start a new session and say:

> **"Build my landing page."**

or run the slash command:

> **`/landing-page`**

Claude creates a `landing-page-brief.md` (your single source of product
context), then walks you phase by phase. You can jump to any phase
(e.g. "write my FAQ" or "deploy the page").

**Resume:** if you stop mid-build, ask Claude to show your
`landing-page-brief.md` and paste it into the next session to pick up where
you left off.

---

## What's inside

```
landing-page-builder/
├── .claude-plugin/
│   └── plugin.json                 # plugin manifest
├── commands/
│   └── landing-page.md             # /landing-page slash command
└── skills/
    ├── landing-page/
    │   ├── SKILL.md                # 5-phase orchestrator
    │   └── references/
    │       ├── offer-stack.md      # offer-first framework
    │       ├── page-structure.md   # 11-section LTO structure + schema
    │       ├── faq-generator.md    # 15-question FAQ (logistical + objection)
    │       └── deploy-vercel.md    # pluggable capture + Vercel deploy
    └── frontend-design/
        └── SKILL.md                # bundled design system (anti-AI-slop)
```

---

Built for the [Claude Code Marketing Bootcamp](https://claudecodemarketingbootcamp.com/).
