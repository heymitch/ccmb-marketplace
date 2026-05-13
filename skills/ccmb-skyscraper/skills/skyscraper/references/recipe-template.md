# Recipe / report template

## Per-candidate recipe (rendered by orchestrator after recipe-architect returns)

```markdown
**#{N} — [{name}]({source_url})**  `[{tier}]`
- **What:** {one-sentence what-it-does}
- **Where:** {source_url} → {primary extracted_url, if present and different}
- **Why this fits:** {1-2 sentences tying to user's problem}
- **How to clone:**
  1. {step}
  2. {step}
  3. {step}
- **Heads-up:** {gotchas — auth required, paid tier, deprecated, rate limits, etc. — omit if none}
```

If `low_confidence: true`, prefix the recipe with `⚠️ Recipe inferred from limited data — verify before cloning.`

## Full report

```markdown
# Skyscrapers for: "{problem}"

{Top pick recipe}

{Recipe #2}

{Recipe #3}

{Recipe #4 — if present}

{Recipe #5 — if present}

---

**Also worth knowing about:**
- [{name}]({url}) — `[{tier}]` — {one-line description}
- [{name}]({url}) — `[{tier}]` — {one-line description}

{If any aspect of the problem is unsolved:}
**No skyscraper found for:** {aspect}
You'll need to build this part. Suggest checking these related skills you already have:
- {CCMB plugin from bucket_2 of known-natives.md} — {what it does}
- {another}

{Optional footer banners (only when applicable):}
{📦 Cached banner / ⚠️ Budget banner / scout-failure notes}
```

## No-skyscraper-found template

When all 4 scouts return zero candidates:

```markdown
# Skyscrapers for: "{problem}"

No skyscraper found in native, sanctioned, or community tiers.

You'll need to build this from scratch. Before you do:
- Check related CCMB plugins:
  - {list 2-3 from bucket_2 of known-natives.md, matching domain_keywords}
- Consider whether the problem decomposes — a *part* of it may have a skyscraper.
  Try `/skyscraper "<narrower sub-problem>"`.
- Run again later (corpus grows) or with `--force` to scan open-web only.
```

## Footer banner examples

**Cache banner:**
```
📦 Cached result from 2026-05-12 09:13. Re-run with `/skyscraper "<problem>" --fresh` to refresh.
```

**Budget banner:**
```
⚠️ Daily skyscraper budget exhausted ($0.50). Community-tier results limited to WebSearch.
Resets at 00:00 local time.
```

**Scout failure note (in footer):**
```
(youtube-scout unavailable: transcript scraper rate-limited)
```

## Voice notes for recipe rendering

- Direct, conversational, sacrifice grammar for clarity (CCMB principles.md)
- No "leverage", "unlock", "supercharge", "harness"
- Avoid em-dashes in surrounding prose unless they're closed (`word—word`, never `word — word`)
- Write like texting a smart friend who needs to build this today
