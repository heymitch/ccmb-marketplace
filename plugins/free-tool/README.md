# Free Tool

Build a **Free Tool** — a deployable lead-magnet mini-app (quiz, calculator,
assessment, or diagnostic) engineered as an *ungameable, shareable research
instrument with a tiered opt-in funnel*.

It's three things at once: a result people want to screenshot, a clean data
instrument (no obvious "right" answers), and a consented lead funnel.

## Prerequisite

Run the **lead-magnet skill** first. It provisions the Supabase + SQL storage
and base funnel. This skill builds the instrument on top and follows that
storage's conventions. It does **not** set up storage itself.

## Install

1. Open **Customize → Personal Plugins → Add Plugin (+) → Upload Plugin**
2. Upload `free-tool.zip`
3. The `/free-tool` command and the `free-tool-builder` skill become available

## Usage

Run the command:

```
/free-tool readiness assessment for church leaders on AI
```

Or just say one of the trigger phrases in chat:

- "build a free tool"
- "make a lead-magnet quiz / calculator / assessment"
- "create a diagnostic funnel"
- "design an archetype quiz"
- "build an ungameable quiz"

## What it does / doesn't

**Does:** frames the instrument, designs ungameable result tiers + scoring
(pattern-coherence grade, monoculture cap, drift gate), authors the item set
and result page, wires a tiered opt-in funnel under an outreach-only consent
contract, builds the UI on the workspace's existing design tokens, and ships
with a live smoke test.

**Doesn't (separate concerns):**
- **Storage / Supabase / schema setup** → the lead-magnet skill (run first)
- **Design system / visual identity** → inherits the workspace's tokens
- **Deploy mechanics** (Vercel / git-PR) → the workspace pipeline
- **Brand-voice copy editing** → ships flagged stubs for a separate voice pass

## What's inside

```
free-tool/
├── .claude-plugin/plugin.json
├── commands/
│   └── free-tool.md            # /free-tool command
├── skills/
│   └── free-tool-builder/
│       ├── SKILL.md            # orchestrator: workflow, decision tables, anti-patterns
│       ├── PLAYBOOK.md         # scoring formulas, grade table, data model, consent copy
│       └── PATTERNS.md         # code patterns: pure scoring+TDD, RLS/PostgREST, path bug, chrome
└── README.md
```

## The one nugget

> **Make every option attractive within its tier. Grade the pattern, not the
> answers.** Obvious "best" answers destroy both data quality and
> shareability. Inverting that is the whole game.

---

License: Personal / purchaser use only. Not for redistribution.
Author: Mitch Harris · mitch@ship30for30.com
