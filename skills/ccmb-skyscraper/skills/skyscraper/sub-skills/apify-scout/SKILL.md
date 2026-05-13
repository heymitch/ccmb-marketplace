---
name: apify-scout
description: |
  Sanctioned-tier scout for the skyscraper plugin. Searches Apify Store for
  relevant actors. Uses Apify REST API if APIFY_API_TOKEN set; otherwise falls
  back to WebSearch site:apify.com. Returns Candidate[] with tier='sanctioned'.
allowed-tools: [WebSearch, WebFetch, Bash]
---

# apify-scout

Dispatched by orchestrator. Input: `{problem, domain_keywords, ccmb_session_ctx, budget_remaining}`. Return: `{candidates: Candidate[], warnings: string[]}`.

## Workflow

### 1. Check for `APIFY_API_TOKEN`

```bash
APIFY_TOKEN=$(grep ^APIFY_API_TOKEN ~/speakeasy-agent/.env 2>/dev/null | cut -d= -f2-)
```

If empty, skip to step 3 (WebSearch fallback).

### 2. Apify REST API path

URL-encode the joined `domain_keywords` (space-separated, max 100 chars). Call:

```bash
curl -s "https://api.apify.com/v2/store?search=<encoded>&limit=15" \
  -H "Authorization: Bearer $APIFY_TOKEN"
```

Parse the JSON response. For each actor in `data.items`:

```json
{
  "name": "<actor.title or actor.name>",
  "source_url": "https://apify.com/<actor.username>/<actor.name>",
  "extracted_urls": [],
  "tier": "sanctioned",
  "why_relevant": "<keyword overlap reasoning, 1-2 sentences>",
  "evidence": "<actor.description, truncated 300 chars>",
  "domain_match": ["<keywords intersecting actor.description and domain_keywords>"],
  "freshness": "<actor.modifiedAt>"
}
```

If response status is 429 → set warning `"apify rate-limited"`, return what's collected.
If response status is 402 → set warning `"apify quota exhausted"`, return what's collected.

### 3. WebSearch fallback (if no token or step 2 failed)

```
WebSearch: "site:apify.com <domain_keywords>"
```

Take top 8 hits. For each:
- WebFetch the URL.
- Extract actor name from `<h1>` or page title.
- Extract description from `<meta name="description">` or first paragraph.

Build Candidate with same shape as step 2 (freshness=null in fallback).

### 4. Filter by relevance

Drop any Candidate whose `evidence` doesn't contain ≥1 `domain_keyword` (case-insensitive). This catches false positives from broad keyword matches.

### 5. Cap + return

Max 8 candidates. Sort by evidence_score descending. Return:

```json
{
  "candidates": [...],
  "warnings": [...]
}
```

## Failure handling

- Token absent → step 3 fallback. Add warning `"APIFY_API_TOKEN absent — using WebSearch fallback (set token for richer metadata)"`.
- Apify API 5xx → step 3 fallback. Add warning `"apify api error — using WebSearch fallback"`.
- WebSearch fails → return empty candidates. Add warning `"both apify api and websearch failed"`.

## Budget accounting

Apify Store browsing (step 2 `GET /v2/store`) is **free** — no compute units consumed. Do NOT charge `budget_remaining` for this scout's operations.

## Caveats

- NEVER echo `APIFY_TOKEN` value in any output, warning, or evidence.
- If a candidate's URL doesn't start with `https://apify.com/`, drop it (not really from Apify Store).
- Truncate evidence to 300 chars even if more is available — keep payload light.
