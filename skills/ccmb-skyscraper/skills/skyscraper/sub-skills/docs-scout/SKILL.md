---
name: docs-scout
description: |
  Native-first scout for the skyscraper plugin. Consults curated known-natives.md
  corpus, then Claude Code docs, Anthropic marketplace, claudeskills.com, and
  the user's locally installed skills. Returns Candidate[] with tier='native'.
allowed-tools: [Read, WebSearch, WebFetch, Glob, Bash]
---

# docs-scout

You are dispatched by the skyscraper orchestrator. Input: `{problem, domain_keywords, ccmb_session_ctx, budget_remaining}`. Return: JSON with `candidates: Candidate[]` and `warnings: string[]`.

## Workflow

### 1. Read `known-natives.md`

Path: `../../references/known-natives.md` (relative to this file).

Parse the three buckets. For each entry, intersect its `domains` array with the input `domain_keywords`. If ≥1 keyword matches (case-insensitive substring on either side), build a Candidate:

```json
{
  "name": "<entry name>",
  "source_url": "<docs_url or url field>",
  "extracted_urls": [],
  "tier": "<entry tier>",
  "why_relevant": "Matches keywords: <intersection>",
  "evidence": "<entry what field, truncated 300 chars>",
  "domain_match": ["<intersected keywords>"],
  "freshness": null
}
```

### 2. WebFetch Claude Code docs

For each of these URLs, fetch and scan the page text for ≥2 `domain_keywords`. If matched, add a Candidate (tier=native):

- `https://docs.claude.com/en/docs/claude-code/skills`
- `https://docs.claude.com/en/docs/claude-code/plugins`
- `https://docs.claude.com/en/docs/claude-code/hooks`
- `https://docs.claude.com/en/docs/claude-code/mcp`
- `https://docs.claude.com/en/docs/claude-code/subagents`
- `https://docs.claude.com/en/docs/claude-code/slash-commands`

`name` = "Claude Code: <capability>", `evidence` = matched paragraph (300 chars), `source_url` = the docs URL.

### 3. WebSearch native marketplaces

Run these queries (substitute `<keywords>` with the joined `domain_keywords`):

- `site:claudeskills.com <keywords>`
- `site:anthropic.com claude skill <keywords>`
- `site:github.com claude-code skill <keywords>`

For each, take top 5 hits. For each hit, if title OR snippet contains ≥1 `domain_keyword`, add as Candidate (tier=native).

### 4. Local glob (already-installed skills)

```bash
ls ~/.claude/plugins/**/skills/**/SKILL.md 2>/dev/null
ls ~/speakeasy-agent/**/skills/**/SKILL.md 2>/dev/null
```

Use the Glob tool with patterns:
- `~/.claude/plugins/**/SKILL.md`
- `~/speakeasy-agent/**/skills/**/SKILL.md`
- `~/speakeasy-agent/projects/ccmb/.claude/skills/**/SKILL.md`

For each match: Read the frontmatter (first ~15 lines). Parse the `description:` field. If it contains ≥2 `domain_keywords`, add as Candidate:

```json
{
  "name": "<frontmatter name>",
  "source_url": "file://<absolute path>",
  "extracted_urls": [],
  "tier": "native",
  "why_relevant": "ALREADY INSTALLED LOCALLY. Description matches: <keywords>",
  "evidence": "<frontmatter description truncated>",
  "domain_match": ["<matched>"],
  "freshness": null
}
```

### 5. Cap + return

Sort by `evidence_score` (per source-ladder.md), keep top 10.

Return:

```json
{
  "candidates": [...],
  "warnings": []
}
```

## Failure handling

- If `known-natives.md` unreadable: skip step 1, continue. Add `"known-natives.md missing"` to warnings.
- If any WebFetch returns 4xx/5xx: skip that URL silently. Continue.
- If any WebSearch errors: skip that query silently. Continue.
- If zero candidates after all 4 steps: return `{"candidates": [], "warnings": [...]}`. Orchestrator handles.

## Caveats

- NEVER fabricate URLs that you didn't actually fetch or find.
- If a docs page doesn't exist, don't invent it — the docs URLs above are real per the project's CLAUDE.md memory and known-natives corpus.
- `extracted_urls` stays empty for native-tier candidates; the source IS the resource.
