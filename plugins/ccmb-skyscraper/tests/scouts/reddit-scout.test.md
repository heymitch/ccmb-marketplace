# reddit-scout fixtures

Structural assertions only — Reddit threads change daily.

## Fixture 1: query "linkedin analytics scraper"
- Expect: ≥3 candidates returned (assuming sufficient discussion exists)
- Expect: ≥1 candidate with `extracted_urls` containing a `github.com` or `apify.com` URL
- Expect: tier values ∈ {community, sanctioned, native} after promotion
- Expect: NO candidate with empty `evidence` field
- Expect: all `source_url` values start with `https://reddit.com` or `https://www.reddit.com` or `https://old.reddit.com`

## Fixture 2: query "make a newsletter"
- Expect: ≥1 candidate (if a thread with allowlist URLs exists)
- Expect: `domain_match` arrays include at least one of [email, newsletter]
- Expect: NO candidate with empty `extracted_urls` (we drop threads with no allowlist URLs)

## Fixture 3: query "implement novel quantum-safe email tracking pixel"
- Expect: zero or near-zero candidates (no community solution)
- Expect: if any returned, evidence must literally support relevance (no LLM hallucination)

## Promotion correctness
- If a Reddit thread's `extracted_urls` contain `github.com/...`: tier MUST be `sanctioned` (not `community`)
- If a thread's `extracted_urls` contain `claudeskills.com/...`: tier MUST be `native`

## Safety
- IP-literal URLs (`https?://\d+\.\d+\.\d+\.\d+`) MUST NOT appear in any `extracted_urls`
- Typosquats (`g1thub.com`, `apifyy.com`) MUST NOT appear in any `extracted_urls`
