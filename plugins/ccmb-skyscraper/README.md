# Skyscraper Bonus

5th CCMB bonus plugin. Run `/skyscraper "<marketing problem>"` to scan existing
solutions (native Claude Code skills, Apify Store, Reddit, YouTube) before
vibe-coding from scratch.

See `../../../skyscraper-bonus-design.md` for the full spec and
`../../../skyscraper-bonus-plan.md` for the implementation plan.

## Install

1. Drop this folder into your Claude Code plugins dir, or zip and install via marketplace.
2. (Optional) Copy `.env.example` → `.env`, fill in any API keys you have.
3. Run `/skyscraper "<your problem>"` or wait for the auto-hook nudge.

## Source ladder

1. **Native** — Claude Code docs, installed skills, Anthropic marketplace
2. **Sanctioned** — Apify Store, official integrations
3. **Community** — Reddit, YouTube
4. **Open-web** — WebSearch catch-all

Top of ladder always wins ties. The repo URL extracted from a Reddit comment
beats the Reddit thread itself — the real skyscraper is the repo, not the
discussion about it.

## Commands

- `/skyscraper "<problem>"` — main scan
- `/skyscraper "<problem>" --fresh` — bypass 24h cache
- `/skyscraper "<problem>" --force` — run on non-marketing problems
- `/skyscraper-setup` — show which API keys are present, daily budget remaining

## Silencing the auto-hook

Say "silence skyscraper" in any prompt. Writes `.claude/.skyscraper-silenced`
in the current dir. Delete that file to re-enable.
