# Link extractor — shared spec

Implemented INLINE in `reddit-scout` and `youtube-scout` (not a separate sub-skill). This file is the spec they reference.

## Regex

```python
URL_PATTERN = r"https?://[^\s<>\"'\)]+"
```

Apply to: post body + every comment body + every reply body + video description + pinned comment + transcript text.

## Allowlist

Only keep URLs whose domain matches one of:

```
ALLOWLIST = [
    "github.com", "gist.github.com",
    "npmjs.com", "pypi.org",
    "apify.com",
    "claudeskills.com", "anthropic.com", "docs.claude.com",
    "modelcontextprotocol.io",
    "huggingface.co", "replicate.com",
]
```

Match on registrable domain (so `www.github.com/foo` matches `github.com`).

## Tier promotion (per source-ladder.md)

| URL domain | Promote candidate to |
|---|---|
| github.com / gist.github.com / npmjs.com / pypi.org | sanctioned |
| apify.com | sanctioned |
| claudeskills.com / docs.claude.com / anthropic.com | native |
| modelcontextprotocol.io | native |
| huggingface.co / replicate.com | sanctioned |

If multiple allowlist URLs appear in a single candidate, take the highest-tier promotion.

## Safety

Discard URLs that:
- Match IP-literal pattern (`https?://\d+\.\d+\.\d+\.\d+`)
- Match localhost / 127.0.0.1 / 0.0.0.0
- Have port numbers > 1024 in the URL (likely dev/dummy)
- Are obvious typosquats: any allowlist domain with a single-character substitution (`g1thub.com`, `apifyy.com`, `anthropc.com`, etc.)

Flagged URLs are dropped silently (not promoted to extracted_urls).

## Output

For each candidate, populate:

```json
"extracted_urls": ["https://github.com/foo/bar", "https://apify.com/x/y"]
```

Deduped. Domain lowercased. Full path preserved.

## Example

Input text (a Reddit comment):
```
Yeah I used the actor at https://apify.com/trudax/reddit-scraper-lite
and adapted https://github.com/foo/scraper. Worked great. Avoid
https://192.168.1.1/admin though.
```

Output `extracted_urls`:
```json
["https://apify.com/trudax/reddit-scraper-lite", "https://github.com/foo/scraper"]
```
(The IP-literal URL is dropped.)

Tier promotion: github.com + apify.com both → sanctioned. Take the highest, which is sanctioned. Final tier on the candidate: sanctioned.
