# apify-scout fixtures

Structural assertions only.

## Fixture 1: query "linkedin profile scraper"
- Expect: ≥2 candidates
- Expect: all source_urls start with `https://apify.com/`
- Expect: tier="sanctioned" on all
- Expect: evidence contains the word "linkedin" or "profile" (case-insensitive)

## Fixture 2: query "youtube transcript"
- Expect: ≥1 candidate
- Expect: evidence mentions "transcript" or "subtitle" or "caption"

## Fixture 3: query "implement novel cryptographic protocol"
- Expect: zero or near-zero candidates from Apify Store (out of scope)
- Expect: no fabricated actor URLs

## Token-fallback behavior
- When APIFY_API_TOKEN absent: warnings includes "APIFY_API_TOKEN absent — using WebSearch fallback"
- When token absent: source_urls still match `https://apify.com/` (from WebSearch site: hits)
