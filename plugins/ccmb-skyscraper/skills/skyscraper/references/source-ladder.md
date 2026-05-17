# Source ladder

Top of ladder always wins ties. Within a tier, sort by `evidence_score` descending.

## Tiers (ascending = better)

1. **native** — Claude Code platform primitives, installed skills, Anthropic marketplace entries, CCMB's own plugins. The "you already have this" tier.
2. **sanctioned** — Apify Store actors, official open-source canon (yt-dlp, playwright, Firecrawl, etc.), claudeskills.com listings.
3. **community** — Reddit threads, YouTube tutorials, blog posts where someone shows working code or links the repo.
4. **open-web** — generic WebSearch hits (catch-all). Lowest priority.

## Promotion rules (link-extractor → tier promotion)

A community-tier candidate gets promoted if its `extracted_urls` contain:

- `github.com` / `gist.github.com` / `npmjs.com` / `pypi.org` URL → promote to **sanctioned** (the repo IS the skyscraper, not the thread)
- `apify.com/<org>/<actor>` URL → promote to **sanctioned**
- `claudeskills.com` / `docs.claude.com` / `anthropic.com` URL → promote to **native**

If a candidate has multiple extracted_urls hitting different rules, take the highest-tier promotion.

## evidence_score formula

```
evidence_score = (
  2 * count(extracted_urls on the allowlist) +
  1 * count(query keywords appearing in evidence text) +
  1 if freshness within 6 months else 0
)
```

Higher is better. Used as the within-tier secondary sort key.

## Cap

Merged list cap = top 8. recipe-architect runs on top 3-5 (top 5 if `budget_remaining > 0.10`, top 3 otherwise).

## Tie-breaking

If two candidates have identical tier + evidence_score:
1. Prefer the one with more `extracted_urls`
2. Prefer the more recent `freshness`
3. Prefer the one whose `name` matches more `domain_keywords`
4. Stable sort by insertion order (don't randomize)
