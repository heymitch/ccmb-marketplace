# docs-scout fixtures

Structural assertions — the live web changes hourly. Run by the orchestrator at runtime when validating scout outputs.

## Fixture 1: query "polish email subject lines"
- Expect: ≥1 candidate named `headline-writer` (from known-natives.md bucket 2)
- Expect: tier="native" on that candidate
- Expect: `extracted_urls` is `[]` for native candidates
- Expect: `domain_match` includes "email" or "subject-line"

## Fixture 2: query "parallel agent orchestration"
- Expect: ≥1 candidate matching `superpowers:dispatching-parallel-agents` OR Claude Code Subagents docs
- Expect: source_url matches `docs.claude.com` OR `superpowers` path
- Expect: tier="native"

## Fixture 3: query "make a quantum-safe pixel tracker"
- Expect: zero or near-zero candidates (no native solution exists)
- Expect: no fabricated URLs — every source_url must be verifiable
