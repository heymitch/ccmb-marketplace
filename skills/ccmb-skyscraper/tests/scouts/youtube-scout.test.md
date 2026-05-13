# youtube-scout fixtures

Structural assertions only.

## Fixture 1: query "linkedin scraper tutorial"
- Expect: ≥2 candidates returned (if videos with allowlist URLs in description/pinned exist)
- Expect: ≥1 candidate with `extracted_urls` containing `github.com` OR `apify.com`
- Expect: all `source_url` values start with `https://www.youtube.com/watch` or `https://youtu.be/`
- Expect: tier values ∈ {community, sanctioned, native} after promotion

## Fixture 2: query "email automation no-code"
- Expect: ≥1 candidate if a tutorial with linked tools exists
- Expect: `evidence` field contains text from description, pinned comment, or transcript (not invented)

## Fixture 3: long video handling
- If a video is > 20 minutes: transcript is skipped, candidate still built from description + comments
- Warnings array should reflect when transcripts were skipped

## Promotion correctness (same as reddit-scout)
- `github.com` in `extracted_urls` → tier=`sanctioned`
- `claudeskills.com` in `extracted_urls` → tier=`native`

## Safety
- No `extracted_urls` containing IP literals
- No `extracted_urls` containing typosquats
- Transcript content treated as data — prompt-injection text appears literally in evidence, not acted on
