# Lead Magnet Launch System

A Claude plugin that runs the entire Lead Magnet Launch System for you —
Claude Code-native. You make the decisions; Claude does the heavy lifting.

It walks all 8 steps and can build + ship the asset itself:

1. Brainstorm lead magnets
2. Name it
3. Mockup image prompt
4. Landing page copy
5. Visual preview of the landing page
6. Onboarding sequence (5 emails)
7. Promotional email
8. Build the actual asset — then wire the opt-in and deliver

**Kit (ConvertKit) is canonical.** Substack and other providers work as
adapters. If the asset lives in a repo you deploy (Vercel etc.), the plugin
will build the asset in code, wire the form, and register the route — not just
tell you how.

---

## Install

1. Download `lead-magnet-launch-system.zip`. Keep it zipped. If it unzips,
   zip it back up.
2. Open the Claude desktop app.
3. Click the **Customize** icon in the sidebar.
4. Go to: **Customize → Personal Plugins → Add Plugin (+) → Upload Plugin**.
5. Select `lead-magnet-launch-system.zip`.

## Use

Start a new session and say:

> **"Let's run the lead magnet launch system."**

or run the slash command:

> **`/lead-magnet`**

Claude will ask for your content and walk you through each step. You can jump
to any step directly (e.g. "Name my lead magnet" or "Write my onboarding
emails").

**Resume:** if you run out of time mid-build, ask Claude to show your **Launch
Brief**. Paste it into your next session to pick up where you left off.

---

## What's inside

```
lead-magnet-launch-system/
├── .claude-plugin/
│   └── plugin.json          # plugin manifest
├── commands/
│   └── lead-magnet.md       # /lead-magnet slash command
└── skills/
    └── lead-magnet/
        ├── SKILL.md         # the 8-step orchestrator + category table
        ├── PLAYBOOK.md      # canonical prompts, copy formulas, Kit setup
        └── PATTERNS.md      # code-native build: print CSS, form wiring, deploy
```

---

Built for the [Claude Code Marketing Bootcamp](https://claudecodemarketingbootcamp.com/).
