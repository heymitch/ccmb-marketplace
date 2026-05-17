---
name: skyscraper-setup
description: Show skyscraper status — which API keys are present, what features are unlocked, daily budget remaining. Never modifies .env.
---

# /skyscraper-setup

Read `~/speakeasy-agent/.env` to check which keys are present. **Do not echo values — only presence.**

For each key, print:

- `APIFY_API_TOKEN`
  - Present → "✅ Apify Store rich metadata, Reddit scraper, YouTube transcript scraper enabled"
  - Missing → "⚪ WebSearch fallback for Apify/Reddit/YouTube (slower, shallower). Add via: `echo 'APIFY_API_TOKEN=<your-token>' >> ~/speakeasy-agent/.env`"

- `YOUTUBE_API_KEY`
  - Present → "✅ YouTube description + comments enrichment enabled"
  - Missing → "⚪ YouTube description-only (no comments) via WebFetch fallback. Add via: `echo 'YOUTUBE_API_KEY=<your-key>' >> ~/speakeasy-agent/.env`"

- `REDDIT_USER_AGENT`
  - Optional. Only mention if using direct Reddit JSON path.

- `SKYSCRAPER_BUDGET_USD`
  - Present → "✅ Daily budget: $<value>"
  - Missing → "⚪ Using default daily budget: $0.50"

Then read `~/.cache/skyscraper/budget.json` (if it exists). Print today's spend:

```
Today's Apify compute used: $X.XX of $Y.YY budget
```

If the file doesn't exist, print: `Budget tracking starts on first /skyscraper run.`

Finally, print the **mode banner**:

- All three keys present → `🟢 FULL MODE — 4 scouts + transcripts + Apify metadata`
- 1-2 keys present → `🟡 PARTIAL MODE — degraded behavior noted per missing key`
- Zero keys present → `⚪ WEBSEARCH-ONLY MODE — works but slower, less depth`

## Rules

- NEVER print API key VALUES — only presence/absence.
- NEVER auto-modify `.env` — only show how to add a key, let the user run the command themselves.
- If `~/speakeasy-agent/.env` doesn't exist, print: `No .env file found. Create one at ~/speakeasy-agent/.env to enable optional features.`
