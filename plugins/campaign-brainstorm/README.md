# `/campaign-brainstorm`

First skill in the CCMB Campaign Pack bonus. Plans a launch — strategic foundation, channel mix, asset checklist, Claude-native MarTech stack — in one dual-mode interview.

## How students use it

```
/campaign-brainstorm
```

Agent runs silent context detection (reads CLAUDE.md, TASTE.md, voice/voice-template.md, MCP config, package.json deps, installed CCMB plugins), prints a one-line manifest of what it found, then asks:

> "Quick brief (smart mode, ~6-8 Qs) or full workshop (~15 Qs across 5 framework layers)?"

Output: `campaigns/<slug>/brief.md` in cwd. First run also creates `campaigns/INDEX.md` listing all campaigns.

## What's in the brief

16 frontmatter fields (machine-parseable, downstream skills consume) plus markdown body (human-readable narrative). See `references/brief-schema.md`.

## Downstream auto-read (v1.1)

Once retrofitted (separate ship), CCMB content skills auto-read the brief if cwd is at or below `campaigns/<slug>/`. Pass `--no-brief` to escape. Brief is optional — every skill works without it.

## MarTech rule

The skill never proposes paid SaaS by default. Three-tier preference: (1) already-installed MCPs/deps → use it. (2) CCMB-native default (Notion MCP, Vercel Cron, Kit OAuth) → recommend. (3) Paid options (HubSpot paid, Ayrshare, Mailchimp paid) → mention only if asked or detected.

## Source spec

`projects/ccmb/campaign-brainstorm-design.md` in the speakeasy repo.
