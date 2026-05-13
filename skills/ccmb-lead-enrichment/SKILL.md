---
name: ccmb-lead-enrichment
description: Waterfall enrichment for an existing list of leads — takes a CSV/paste of names+companies+URLs, queries free public sources (web search, GitHub, public APIs, About pages) in ICP-tuned order, and outputs a ranked CSV with rationale per row. No Apollo, no Clay subscription, no external connector. Use when the student has a list and needs to rank/qualify it against their current offer. Triggers — "/ccmb-lead-enrichment", "enrich my list", "score my leads", "waterfall enrichment", "rank my prospects", "qualify this list", "who should I reach out to first".
---

# CCMB Lead Enrichment

## 1. What this skill does

Takes your existing list of people — past clients, LinkedIn export, podcast guests, anyone you already know exists — and **enriches each row by waterfalling across free public sources** until enough data is collected to score the row against your current ICP. Output is a ranked CSV with rationale, ready for the S5 outreach pipeline.

**The architectural move:** waterfall sources are picked per ICP, not fixed. A developer-founder ICP queries GitHub + Twitter + personal blog. A B2B-SaaS-founder ICP queries company About + Crunchbase public + podcast appearances. **When your offer changes, re-run this skill against the same list — you get a completely different ranking from completely different signals.** The list compounds across pivots.

**What it is, plainly:** scraping + lookup, run on your local machine, with output saved to your local `leads/` folder. Read-only. Personal qualification use. Your account, your risk, your list — no redistribution.

## 2. When to invoke

- Anytime you have 20+ names you want to rank by ICP fit.
- After pivoting your offer (re-run against your existing client list — different ICP, different waterfall, different ranking).
- Monthly habit: take last month's LinkedIn-new-connections export, enrich, identify the 5 worth a conversation.
- Before any cold outreach session — feeds S5 (`/ccmb-email-nurture`) with the ranked prospects.

**Do not run** if you don't have a list. The skill enriches what you give it. Synthetic discovery (skill builds candidates from your ICP alone) is a cohort 2+ feature. For cohort 1: bring 20+ names minimum.

## 3. What it produces

A ranked CSV at `./leads/[date]-[icp-slug].csv` with these columns:

```
rank, score, band, full_name, company, role, company_size, signals_matched,
top_signal, rationale_summary, sources_used, public_urls, enrichment_confidence
```

Plus:
- **Top 5 printed to stdout** for immediate human-eyeball review
- **`leads/enrichment-log.md`** appended with run metadata (date, ICP used, source coverage, time spent)
- **Home page auto-update** if S1 is shipped — Dogfood spec-grid reads `leads/` and reflects new count on next build

The CSV slots into the same scoring engine `lib/lead-research.ts` ships with S4. Same downstream contract. S5 reads `leads/cohort-*.csv` for outreach drafting.

## 4. The 3 inputs the skill needs

**1. Your list** — any reasonable format. Skill auto-detects:
- CSV with headers (name, company, url, etc.)
- Pasted lines ("Sarah Chen, Acme Inc, sarah@acme.com")
- Markdown table
- Plain unstructured paste ("Sarah Chen runs Acme. Bob Johnson is at Foo Corp.")
- LinkedIn Connections export CSV (the skill knows the LI export shape)

Minimum 20 rows. Recommended 50-200 for meaningful pass.

**2. Your ICP** — either:
- Already produced by `/ccmb-icp-translator` (preferred, structured)
- Or written inline in 1-3 sentences when the skill asks ("solo marketing consultants doing $5-15K/mo who haven't productized yet, US-based, post-pivot from agency work")

ICP determines the waterfall (see §5). Vague ICP = useless ranking.

**3. Depth cap (optional)** — per-row time budget. Default 60 seconds. Higher = richer signal but slower runs. A 50-row list at default = ~10-15 min total.

## 5. The waterfall — how source selection works

The skill ships with a **playbook library** at `references/waterfall-playbooks.md`. Each playbook = ICP shape → ordered source list. The translator step in §7 picks the closest playbook to your ICP and runs it.

### The 5 default playbooks (cohort 1)

| Playbook | When it fires | Source order |
|---|---|---|
| **developer-founder** | ICP mentions "developer," "technical founder," "open-source," "engineer," "CTO" | GitHub → personal blog → Twitter → company HN/Reddit mentions → WebSearch generic |
| **b2b-saas-founder** | ICP mentions "SaaS," "B2B software," "founder + product," "PMF" | Company About → Crunchbase public profile → podcast guest search → LinkedIn URL note (read-only) → Twitter → WebSearch |
| **creator-thought-leader** | ICP mentions "creator," "newsletter," "audience," "writer," "course creator" | Personal site/newsletter → YouTube channel → Twitter → recent podcast appearances → WebSearch |
| **service-provider-consultant** | ICP mentions "consultant," "agency," "freelancer," "service provider" | Personal site → testimonials/case studies page → Twitter → LinkedIn URL note → WebSearch |
| **generic-fallback** | Used when no playbook matches with confidence | WebSearch broad → first-result page → social profile discovery → WebSearch refined with company name |

Each source returns a partial-data row. The skill **accumulates fields across sources**, stopping when:
- All ICP-required signals are matched, OR
- Per-row time budget exhausted, OR
- All playbook sources tried

This is the waterfall behavior. Per-row data accumulates; the skill doesn't pick a winner from one source.

### Custom playbooks

Power users can add playbooks to `~/.ccmb-lp/playbooks/` (or per-folder at `./.ccmb-lp/playbooks/`). Skill checks user-defined playbooks first, falls back to bundled defaults.

## 6. Source registry (Tier 1, free)

The actual mechanisms the skill calls. All free, all read-only, all public-data-only.

| Source | Mechanism | What it returns |
|---|---|---|
| **WebSearch** | Claude Code built-in `WebSearch` tool | Search snippets, social URLs, About page URLs, public bio fragments |
| **WebFetch** | Claude Code built-in `WebFetch` tool | Fetches a known URL, returns parsed text. Used to read About pages, blog posts, profile pages |
| **GitHub Public API** | HTTP GET `api.github.com/users/{username}` | Bio, company, blog URL, twitter handle, public repo count, recent activity. **No auth required for public data** at 60 req/hr — plenty for cohort scale |
| **Reddit Public API** | HTTP GET `reddit.com/user/{username}/.json` | Bio, karma, recent posts, top subreddits. No auth required, generous rate limits |
| **YouTube Data API** | HTTPS via Google API key (free tier 10K req/day) | Channel info, subscriber count, recent uploads, descriptions. Requires student to add their own API key |
| **Companies House (UK)** | Public REST API, free | UK company directors, registered addresses, filing history |
| **SEC EDGAR (US)** | Public REST API, free | US public company filings, executive names |
| **Public RSS feeds** | Fetch and parse | Newsletter/blog content for "what they write about" signal |

**LinkedIn handling:** the skill **never scrapes LinkedIn directly** (LI blocks aggressively + TOS risk is real). When a LinkedIn URL is encountered, it's noted in the output CSV but not crawled. Students can manually click through to LI URLs for the rows they care about most.

**Out of scope for cohort 1:**
- Cloudflare Worker proxy (Tier 2 — post-cohort bonus)
- Apify Store actors (Tier 3 — post-cohort bonus)
- Email finder APIs (Hunter, Findymail, etc. — paid, separate decision)
- LinkedIn scraping via any mechanism (legal + reliability risk)

## 7. Execution flow

10 steps from "give me your list" to "ranked CSV in your repo."

1. **Detect input.** Read the user's pasted/uploaded list. Parse via `references/parsing-rules.md` — handles CSV, markdown table, LI export, plain paste. If parse fails, ask the user to paste 1-2 example rows in a different format.
2. **Confirm the list.** Print row count + first 3 examples. Ask: "I see N rows, first one is '[name] at [company]'. Proceed?"
3. **Get the ICP.** Check for `~/.ccmb-lp/icp.json` (from `/ccmb-icp-translator`). If absent, ask inline: "Describe your ICP in 1-3 sentences." Run a quick translator-style prompt to extract required signals + weights + exclude rules.
4. **Pick the playbook.** Match ICP to one of the 5 default playbooks (§5). Print: "Using [playbook-name] playbook because your ICP mentions [keyword]. Want to override?"
5. **Confirm depth cap.** Default 60 sec/row. Print estimated total time. If list > 100 rows, suggest 30 sec/row for batch speed.
6. **Run the waterfall per row.** For each row:
   - Run playbook sources in order
   - Accumulate fields across sources
   - Stop early if all ICP-required signals matched
   - Skip remaining sources if per-row timeout hit
   - Log which sources were consulted to `sources_used` column
7. **Score each row.** Reuse the existing `lib/lead-research.ts` scoring engine — same engine as the v2 spec, unchanged. Outputs `score`, `band` (A/B/C/D), `signals_matched`, `top_signal`, `rationale_summary`.
8. **Rank + write CSV.** Sort by score descending. Write `./leads/[YYYY-MM-DD]-[icp-slug].csv`. Append metadata to `./leads/enrichment-log.md`.
9. **Print top 5.** Stdout summary: top 5 names + scores + one-line rationale each. Pause for user review.
10. **Commit reminder.** Suggest: "Commit your CSV: `git add leads/ && git commit -m 'enrichment [date] [icp-slug]'`. Real cohort flow keeps lead history versioned."

Total wall-clock for 50 rows: ~10-15 min. For 200 rows: ~30-50 min.

## 8. Quality gates (always run before writing CSV)

### Gate 1: PII hygiene
- Confirm output file pattern. `leads/cohort-*.csv` (real data) → gitignored per S4 spec. `leads/example-*.csv` (synthetic) → committed.
- If the user's list contains email addresses, the skill notes this in the output but does NOT publish emails in any logs or stdout summaries. Email is in the CSV only.
- No third-party transmission of the list. The skill calls public sources for *individual lookups*, never bulk-submits the list to any external service.

### Gate 2: Confidence threshold
- Every output row has an `enrichment_confidence` column (high / medium / low).
- **Low** = skill found <2 signals across all sources. Probably can't be ranked reliably. Flagged in stdout summary so user knows not to trust the score.
- **Medium** = 2-3 signals matched. Score is directional.
- **High** = 4+ signals matched. Score is trustworthy.

### Gate 3: Principle-1 sanity
- Skill suggests (doesn't force) running the same list against a contrast ICP. "Run again with a different ICP and compare top 5? Tests that your ranking is signal, not noise."
- This is the same contrast-ICP move from the v2 smoke test. Worth doing on first run.

## 9. Failure modes and recovery

- **Source rate-limited mid-run.** GitHub at 60 req/hr is the most likely choke. Skill detects the 429, pauses the playbook, falls through to next source, logs the gap. Never crashes a run.
- **Per-row timeout hit on most rows.** Indicates the playbook is mismatched. Skill suggests re-running with the `generic-fallback` playbook OR with a higher depth cap.
- **Empty list or 0 rows parsed.** Skill stops, prints: "Parsed 0 rows. Paste 1-2 example rows so I can adjust." No fabrication.
- **ICP too vague.** If the ICP translator extracts <3 distinct signals, skill prints: "Your ICP gave me [N] signals to score against. Below 3, ranking is mostly noise. Want to write 2 more sentences of ICP detail?" Pauses.
- **WebSearch returns no results for a row.** Logs `sources_used = "websearch:0_results"`. Row gets `enrichment_confidence = low`. Score reflects what little was found, doesn't fabricate.
- **Output CSV path already exists.** Skill appends a `-v2` suffix. Never overwrites a previous run.
- **User cancels mid-run.** Already-enriched rows are written to a partial CSV at `leads/[date]-[icp-slug]-partial.csv`. Re-running resumes from where it stopped.

## 10. Composition with other skills

- **`/ccmb-icp-translator`** — upstream. If present, this skill reads its output. If absent, the inline interview substitutes.
- **`/ccmb-email-nurture` (S5)** — downstream. Reads the ranked CSV, drafts source-aware outreach for top-N rows.
- **`/ccmb-headline-writer`** — orthogonal but useful. Generate outreach subject lines for top-ranked prospects in batch.
- **The scoring engine `lib/lead-research.ts`** — unchanged from the v2 spec. This skill produces input for it; the engine produces the ranking output. Same contract.

## 11. The cohort 2+ roadmap (not shipping in v1)

Documenting upgrade paths for clarity, not promising delivery.

- **Tier 2: Cloudflare Worker proxy** — when Tier 1 sources don't get enough JS-rendered data. Student pays ~$0-5/mo for Workers. Worker handles the headless-browser rendering, skill calls Worker. Unlocks dynamic SaaS About pages, some additional public data.
- **Tier 3: Apify Store actors** — pay-per-run for specific high-value lookups (Google Maps business data, public Crunchbase deeper data). Student opts in per-lookup, not per-month.
- **Discovery mode** — skill builds candidate list from ICP alone via Tier 1 broad search. The "Clay killer" path. Real engineering project.
- **Click-to-send** — outreach automation after enrichment. Bonus extension to the S5 nurture skill.

## 12. Versioning

Fetched from `https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/skills/ccmb-lead-enrichment/SKILL.md`. References at `.../skills/ccmb-lead-enrichment/references/`.

Update with: "Update my CCMB skills to the latest version."
