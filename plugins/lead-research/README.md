# Lead Research

A Claude Code plugin that turns a raw opt-in list into a decision-ready,
confidence-rated contact CSV — with researched org/role/contact fields,
LinkedIn/X handles, and optional one-sentence personalized openers.

Built for **organic opt-in leads** (newsletter sign-ups, lead magnets,
content upgrades). It prefers a connected CRM or paid enrichment connector
when one is available, and falls back to native parallel web research when
not.

## Install

1. In Claude Code: **Customize → Personal Plugins → Add Plugin (+) → Upload Plugin**
2. Upload `lead-research.zip`
3. The `/lead-research` command and the `lead-research` skill become available.

## Use

Run the command:

```
/lead-research path/to/opt-ins.csv
```

or describe the list:

```
/lead-research enrich my webinar opt-ins, segment by job function
```

Or just speak naturally — the skill auto-triggers on lead-research requests.

### Trigger phrases

- "research these leads" / "enrich this contact list"
- "enrich contacts with personalized openers" / "add personalized first lines"
- "build a contacts CSV with parallel research agents"
- anything asking to research/enrich a lead or opt-in spreadsheet

## What it does

- Detects connectors (CRM / enrichment) and routes the source + enrichment intelligently
- Locks a fixed 16-column schema before researching (no mid-flight drift)
- Segments the population and dispatches one parallel research agent per segment
- Verifies inferred emails / LinkedIn URLs via web search (no logged-in scraping)
- Merges into one validated, confidence-rated CSV (the confidence column is a priority queue)
- Optionally adds personalized openers that each cite a specific artifact

## What it explicitly does NOT do

- **Send anything / write to a CRM** — separate sibling skill
- **Triage replies, book calls, track deals** — separate sibling skill
- **Decide who your segments/ICP are** — do audience research first, then come back
- It is **not** specialized for cold outreach; organic opt-in enrichment is the focus

## What's inside

```
lead-research/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── lead-research.md
├── skills/
│   └── lead-research/
│       ├── SKILL.md       # orchestrator: routing table, workflow, anti-patterns
│       ├── SCHEMA.md      # canonical 16-column schema + confidence rubric
│       └── PLAYBOOK.md    # parallel-agent contract, verify/personalize/merge
└── README.md
```

## License

Personal / purchaser use only.
Author: Mitch Harris · mitch@ship30for30.com
