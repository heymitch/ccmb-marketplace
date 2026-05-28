# Skyscraper

Scan what already exists before you build from scratch. Give it a marketing problem; it fans out parallel scouts and returns a ranked report of existing solutions + how to clone or adapt them.

## Install

After adding the marketplace (`heymitch/ccmb-marketplace`), install from the plugin list or:

```
/plugin install skyscraper@ccmb-marketplace
```

## Use

Say "scan for existing solutions" or `/skyscraper "<your problem>"`. Run it whenever you're about to build a custom tool — the cheapest tool is the one you didn't have to build.

## What's inside

- `skills/skyscraper/SKILL.md` — the orchestrator (parallel scout fan-out → ranked report)
- `skills/skyscraper/sub-skills/` — the scouts: `apify-scout`, `reddit-scout`, `youtube-scout`, `docs-scout`, `recipe-architect`
- `skills/skyscraper/references/` — `known-natives.md`, `source-ladder.md`, `recipe-template.md`, `link-extractor.md`
- `commands/skyscraper-setup.md` — `/skyscraper-setup` shows which optional API keys (e.g. `APIFY_API_TOKEN`) are present and what they unlock. Never modifies `.env`.

## Optional API keys

Skyscraper works on free WebSearch fallback out of the box. Adding `APIFY_API_TOKEN` unlocks richer Apify Store metadata + Reddit/YouTube scrapers. Run `/skyscraper-setup` to see status.
