---
name: ccmb-lead-enrichment
description: Cascade enrichment for an existing list of leads — takes a CSV/paste of names+companies+URLs, queries free public sources (web search, GitHub, public APIs, About pages) in ICP-tuned order, and outputs a ranked CSV with rationale per row. Chains with /skyscraper when ICP shape is novel and no default cascade playbook fits. No Apollo, no Clay subscription, no external connector. Use when the student has a list and needs to rank/qualify it against their current offer. Triggers — "/ccmb-lead-enrichment", "enrich my list", "score my leads", "cascade enrichment", "waterfall enrichment", "rank my prospects", "qualify this list", "who should I reach out to first".
---

# CCMB Lead Enrichment

## 1. What this skill does

Takes your existing list of people — past clients, LinkedIn export, podcast guests, anyone you already know exists — and **enriches each row by cascading across free public sources** until enough data is collected to score the row against your current ICP. Output is a ranked CSV with rationale, ready for the S5 outreach pipeline.

**The architectural move:** cascade sources are picked per ICP, not fixed. A developer-founder ICP queries GitHub + Twitter + personal blog. A B2B-SaaS-founder ICP queries company About + Crunchbase public + podcast appearances. **When your offer changes, re-run this skill against the same list — you get a completely different ranking from completely different signals.** The list compounds across pivots.

**What it is, plainly:** scraping + lookup, run on your local machine, with output saved to your local `leads/` folder. Read-only. Personal qualification use. Your account, your risk, your list — no redistribution.

## 2. When to invoke

- Anytime you have 20+ names you want to rank by ICP fit.
- After pivoting your offer (re-run against your existing client list — different ICP, different cascade, different ranking).
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
- **`leads/enrichment-followup-[date].md`** (when relevant) — rows that would benefit from manual `/research:youtube` deep-dive or other heavyweight follow-ups, with the exact command to run for each
- **Home page auto-update** if S1 is shipped — Dogfood spec-grid reads `leads/` and reflects new count on next build

Output CSV now includes a `failure_reason` column for low-confidence rows (e.g., `name_too_common_no_business_anchor`, `email_domain_returned_no_about_page`, `rate_limited_mid_cascade:github`). Lets the student see *why* a row scored 0 without re-running the cascade.

The CSV slots into the same scoring engine `lib/lead-research.ts` ships with S4. Same downstream contract. S5 reads `leads/cohort-*.csv` for outreach drafting.

## 4. The 3 inputs the skill needs

**1. Your list** — any reasonable format. Skill auto-detects:
- CSV with headers (name, company, url, etc.)
- **Email lists** (just emails, one per line — handled via email-first cascade, see §6.5)
- Pasted lines ("Sarah Chen, Acme Inc, sarah@acme.com")
- Markdown table
- Plain unstructured paste ("Sarah Chen runs Acme. Bob Johnson is at Foo Corp.")
- LinkedIn Connections export CSV (the skill knows the LI export shape)
- **Apollo / ListKit / Cognism CSV exports** (legacy data the student already owns — works without an active subscription)
- **ESP subscriber exports** (Kit/ConvertKit/Mailchimp/MailerLite CSV downloads — usually email-primary)
- **Lead magnet capture data** (rows from your own `/api/lead` endpoint, S2 output)
- **Landing page form submissions** (any form export from S1 funnels)

Minimum 20 rows. Recommended 50-200 for meaningful pass.

**Most common cohort 1 case:** the student brings an email list — either from their own ESP (lead magnets + landing page captures from S1-S2) or from a legacy Apollo/ListKit subscription they cancelled but kept the data from. The cascade treats this case specially (§6.5) — email is *more structured* than a name, so the resolution flow starts from a different surface.

**2. Your ICP** — either:
- Already produced by `/ccmb-icp-translator` (preferred, structured)
- Or written inline in 1-3 sentences when the skill asks ("solo marketing consultants doing $5-15K/mo who haven't productized yet, US-based, post-pivot from agency work")

ICP determines the cascade (see §5). Vague ICP = useless ranking.

**3. Depth cap (optional)** — per-row time budget. Default 60 seconds. Higher = richer signal but slower runs. A 50-row list at default = ~10-15 min total.

## 4.5. Signal enrichability audit (always runs before cascade)

After the ICP is resolved (from `/ccmb-icp-translator` or inline interview), the skill classifies each ICP signal into one of three buckets **before any source is queried**:

| Bucket | Meaning | What happens in cascade |
|---|---|---|
| **ENRICHABLE** | A public source can directly answer this signal | Scored normally |
| **INFERRABLE** | No direct source, but a proxy can estimate (e.g., "founded year" inferred from About-page text or domain WHOIS) | Scored with `inferred:true` flag in CSV |
| **UNENRICHABLE** | No public source, no reliable proxy, no inference path | **Dropped from scoring with explicit user warning** |

### Common unenrichable signals to watch for

- **Exact age** (e.g., "under 40") — no public source gives reliable age. The skill cannot enrich this. Possible inference: graduation-year from LinkedIn bio (if visible), "founded company at age X" mentions in interviews, BUT these are unreliable for cohort 1.
- **Exact annual revenue** — privately-held companies don't disclose. Inference proxies (headcount × industry avg) are too noisy for scoring.
- **Personal demographics** (gender, ethnicity, religion) — neither enrichable nor inferrable from a B2B perspective. The skill refuses to enrich these regardless of student request — both because the data isn't reliable AND because it's a discrimination risk.
- **Decision-making authority** (e.g., "is the actual buyer") — usually an inference from role title. Title ≠ authority.

### What the skill prints

After classifying, before the cascade runs:

```
Signal audit for your ICP:
  ✓ ENRICHABLE: role, company size band, industry, tech stack signals, content signals
  ⚠️ INFERRABLE: founded year (from About page), team size band (from LinkedIn URL note + Crunchbase public)
  ✗ UNENRICHABLE: exact age, exact revenue, decision-making authority

Continue with ENRICHABLE + INFERRABLE only? The UNENRICHABLE signals
will be dropped from scoring — including them silently would mean your
ranking pretends to filter for something it can't actually filter for.

  [continue, drop unenrichable]    [rewrite ICP without these signals]    [cancel]
```

**On `continue`:** unenrichable signals are removed from the scoring weight table. The cascade runs only against signals that have a real path to data.

**On `rewrite`:** skill enters a mini-interview asking how to replace each unenrichable signal with an enrichable proxy. ("Instead of 'under 40,' try 'company founded after 2018' — same intent, real signal.")

**Why this exists:** the worst failure mode of any enrichment skill is the silent-fail — scoring engine processes a signal it can't actually source, every row gets the default value, and the student believes they filtered for something they didn't. This audit makes the failure mode loud instead of silent.

## 5. The cascade — how source selection works

The skill ships with a **playbook library** at `references/cascade-playbooks.md`. Each playbook = ICP shape → ordered source list. The translator step in §7 picks the closest playbook to your ICP and runs it.

### Playbook matching algorithm (precise)

The matcher used to be ambiguous about "≥2 keyword hits." Cohort 1 spec is now:

```
For each playbook P in library:
  P.score = count of (P.triggers ∩ ICP.keywords)
  // P.triggers is the playbook's own trigger keyword list
  // ICP.keywords is the keyword set extracted from the student's ICP

P.confidence = "high"   if P.score >= 3
             | "medium" if P.score == 2
             | "low"    if P.score == 1
             | "none"   if P.score == 0

If exactly one playbook has confidence >= "medium":
  Use it. Print: "Using [P.name] playbook (matched: [keywords])."

If multiple playbooks tie at confidence >= "medium":
  Print all tied options. Ask user to pick. No silent default.

If max confidence is "low" or "none":
  Offer /skyscraper chain (see "Chaining with /skyscraper" below). Do not silently fall through to generic-fallback.
```

**The critical change:** a single weak keyword hit ("low" confidence) is no longer enough to silently use a playbook. Real example from the dry-run: ICP "vintage typewriter restorers under 40 in Portland" had a single weak hit on `service-provider-consultant` because "restorer" is service-adjacent. **Under the old rule, this would have silently used the wrong playbook.** Under the new rule, single weak hits trigger skyscraper or fallback-with-warning.

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

This is the cascade behavior. Per-row data accumulates; the skill doesn't pick a winner from one source.

### Custom playbooks

Power users can add playbooks to `~/.ccmb-lp/playbooks/` (or per-folder at `./.ccmb-lp/playbooks/`). Skill checks user-defined playbooks first, falls back to bundled defaults.

### Chaining with `/skyscraper` for novel archetypes

When no default or custom playbook matches the ICP with confidence — the ICP archetype is genuinely novel for this student's business — the skill **does not silently fall through to `generic-fallback`.** Instead, it offers to chain with `/skyscraper`:

```
I don't have a playbook that fits your ICP — "[novel ICP shape]" doesn't match any of:
  developer-founder, b2b-saas-founder, creator-thought-leader,
  service-provider-consultant, generic-fallback.

Run /skyscraper to scan existing enrichment patterns for this archetype before I
build a custom playbook from scratch? (~30 sec, returns ranked sources to consult)

  [yes, run skyscraper]    [no, use generic-fallback]    [I'll write a custom playbook myself]
```

**On `yes`:** the skill dispatches `/skyscraper "enrichment sources for [ICP shape]"`. Skyscraper's 4 scouts (Reddit, YouTube, Apify, Docs) run in parallel, return a ranked report of existing patterns + tools + sources for this archetype. The enrichment skill synthesizes a one-time custom playbook from the report, runs the cascade, and offers to save the synthesized playbook to `~/.ccmb-lp/playbooks/` for reuse.

**Why this exists:** the codify loop applied to cascade authoring. When you encounter a novel ICP, don't vibe-code a new playbook — scan for existing patterns first. Often someone has already worked out which sources matter for "podcast hosts" or "Substack writers" or "indie iOS developers," and skyscraper finds that work.

**Composition requirement:** student must have the `ccmb-skyscraper` plugin installed. If not, skill skips the offer and uses `generic-fallback`. Doesn't error.

**Budget impact:** skyscraper uses its own daily budget (default $0.50/day via `SKYSCRAPER_BUDGET_USD` env var). Enrichment doesn't double-count.

## 6. Source registry (Tier 1, free)

The actual mechanisms the skill calls. All free, all read-only, all public-data-only.

| Source | Mechanism | What it returns |
|---|---|---|
| **WebSearch** | Claude Code built-in `WebSearch` tool | Search snippets, social URLs, About page URLs, public bio fragments |
| **WebFetch** | Claude Code built-in `WebFetch` tool | Fetches a known URL, returns parsed text. Used to read About pages, blog posts, profile pages. **Returns skeleton on JS-rendered pages — cascade auto-escalates to browser-use (§6.7) when this happens on an eligible source.** |
| **Browser-use (escalation only)** | `dev-browser` skill / `claude-in-chrome` MCP / `computer-use` MCP — first available, in that order | Real-browser render of JS-heavy pages. Fires only when WebFetch returns skeleton AND the source is in BROWSER_USE_ELIGIBLE_SOURCES (§6.7). Adds 5-15 sec/row, used on ~5-15% of rows in a typical run. Graceful skip if no browser tool installed. |
| **GitHub Public API** | HTTP GET `api.github.com/users/{username}` | Bio, company, blog URL, twitter handle, public repo count, recent activity. **No auth required for public data** at 60 req/hr — plenty for cohort scale |
| **Reddit Public API** | HTTP GET `reddit.com/user/{username}/.json` | Bio, karma, recent posts, top subreddits. No auth required, generous rate limits |
| **YouTube discovery** | WebSearch + WebFetch on channel pages | Channel URL, subscriber count from public search snippets, recent video titles from channel page. **No API key needed.** For deep transcript-level analysis on high-value rows, dispatches to `/research:youtube` (the existing competitor-research skill) — only fires when explicitly requested, not per-row |
| **Companies House (UK)** | Public REST API, free | UK company directors, registered addresses, filing history |
| **SEC EDGAR (US)** | Public REST API, free | US public company filings, executive names |
| **Public RSS feeds** | Fetch and parse | Newsletter/blog content for "what they write about" signal |

**LinkedIn handling:** the skill **never scrapes LinkedIn directly** (LI blocks aggressively + TOS risk is real). When a LinkedIn URL is encountered, it's noted in the output CSV but not crawled. Students can manually click through to LI URLs for the rows they care about most.

**Out of scope for cohort 1:**
- Cloudflare Worker proxy (Tier 2 — post-cohort bonus)
- Apify Store actors (Tier 3 — post-cohort bonus)
- Email finder APIs (Hunter, Findymail, etc. — paid, separate decision)
- LinkedIn scraping via any mechanism (legal + reliability risk)

## 6.5. Email-first cascade (the common cohort 1 case)

When the input list is email-primary — students bringing ESP exports, lead magnet captures, landing page submissions, or legacy Apollo/ListKit CSVs — the cascade runs a **pre-resolution step** before the playbook fires.

### The 4-step email-first pre-cascade

For each row with an email but missing name/company/role:

1. **Split email into `handle@domain`.**
   - `sarah.chen@acme.com` → `handle: sarah.chen`, `domain: acme.com`
   - `marcus@stripe.com` → `handle: marcus`, `domain: stripe.com`
   - `bob@gmail.com` → `handle: bob`, `domain: gmail.com` (personal — different path)

2. **Resolve domain to company (B2B path).**
   - If domain is NOT a personal email provider (gmail/yahoo/hotmail/outlook/icloud/protonmail/etc.):
     - `WebFetch({domain}/about)` and `WebFetch({domain})` — extract company name, headcount signals, founding year, team page
     - Store: `company`, `company_url`, `industry_signal`, `founded_year` (if findable)
   - Confidence: high — email domain = company is the strongest possible firmographic signal

3. **Resolve handle to name (when possible).**
   - If domain returned a `/team` or `/about` page with people listed: cross-reference handle patterns (`{first.last}`, `{first}`, `{flast}`, `{first}{l}`) against team-page names
   - Else: `WebSearch "{handle} {company}"` to find a public identity match
   - Else: skill flags `name_confidence: low` and records the handle as a placeholder name

4. **Hand off to playbook-driven cascade.**
   - With resolved `(name, company)` from steps 2-3, the normal playbook matcher fires (§5) and the standard cascade runs
   - Email-first rows get one extra source already populated (the company About page) — the playbook cascade adds the rest

### Personal email domains (gmail/etc.)

When the domain is a personal provider, the B2B resolution path doesn't apply. The skill falls back to:

1. **Handle analysis.** `marcus.chen.dev@gmail.com` → handle suggests "developer" / "code" signal. `sarah.studio@gmail.com` → suggests "creator/maker." These are weak hints, not scoring inputs.
2. **WebSearch on email directly.** `"marcus.chen.dev@gmail.com"` sometimes surfaces public mentions (GitHub commits, forum profiles, public bios with email listed). Often returns nothing.
3. **If nothing resolves:** row gets `enrichment_confidence: low` with `failure_reason: personal_email_no_public_footprint`.

Personal-email rows are the hardest case. Most ESP subscriber lists have 20-40% personal emails — students should expect that fraction to score lower regardless of the actual person.

### Legacy Apollo/ListKit imports

These vendor CSVs often have richer columns (`# Employees`, `Industry`, `Annual Revenue`, `Person LinkedIn URL`). When detected:
- **Pre-populate company + role + size from the CSV** — skip the resolution steps that the CSV already answers
- **Run playbook cascade only on the *missing* fields** — much faster runs
- **Treat the imported data as the baseline; only enrich what's missing**

This is the "no vendor lock-in" migration story: the student paid for the data once, they own it forever, the skill enriches what's there without making them re-subscribe.

## 6.7. Browser-use escalation (for JS-rendered pages)

WebFetch is fast (<1 sec) but blind to JavaScript. Lots of high-value pages — SaaS company About pages, YouTube channel pages, Crunchbase public profiles, Substack author pages — are SPA-rendered and return skeleton HTML to WebFetch. The cascade silently fails on those rows unless we escalate.

The fix: **when WebFetch returns skeleton, escalate to a real browser** that renders JS, captures the page state, and feeds back full content. Browser-use is 5-15 sec/row — slow enough that it shouldn't be the default, fast enough to be practical for ~5-15% of rows in a typical cascade run.

### Detection — when to escalate

The cascade decides per-row, per-source:

```
After a WebFetch call returns:
  useful_body_bytes = length(strip_boilerplate(response_body))

  if useful_body_bytes < 500 AND
     this_source_is_in(BROWSER_USE_ELIGIBLE_SOURCES) AND
     row_is_high_value(row.partial_score) AND
     row.time_budget_remaining > 20 sec:
       → escalate to browser-use
  else:
       → log failure_reason = "skeleton_html_browser_use_skipped" and continue cascade
```

`row_is_high_value` is a heuristic: row already has ≥1 confirmed signal from earlier cascade steps. We don't burn browser time on rows that returned nothing useful from the easier sources.

### BROWSER_USE_ELIGIBLE_SOURCES (pages where browser-use actually helps)

| Source | Why it benefits | Reliability |
|---|---|---|
| **SaaS company About pages** | Many are SPA-built (Vercel/Next.js with client-side rendering, framer.com sites, webflow with JS interactions) | High — works ~85% of time |
| **YouTube channel pages** | Subscriber counts + recent video metadata are JS-rendered | Medium-high — works ~70% of time; Social Blade public pages are a more reliable static alternative |
| **Crunchbase public profiles** | Firmographics rendered client-side from API | Medium — works ~60% of time; aggressive rate limiting after 5-10 requests |
| **Substack / Medium author pages** | Subscriber counts + post lists JS-rendered | High — works ~80% of time |
| **Etsy shops with dynamic listings** | Most shops static-render, but listing counts and "sold X items" badges are JS | Low priority — static fallback usually sufficient |
| **Notion-hosted personal sites** | Notion's public pages need JS to render content | Medium — works ~65% of time |

### NOT BROWSER_USE_ELIGIBLE (do not attempt — these will fail or get the student banned)

| Source | Why it's banned |
|---|---|
| **LinkedIn (any URL)** | Per SKILL.md §6 — never crawl, regardless of mechanism. TOS + ban risk. |
| **Instagram public profiles** | Aggressive bot detection. Even real browsers get login-walled within ~10 requests. Will burn time without returning data. |
| **Twitter/X profiles (non-API)** | Same bot detection problem. The static fallback (WebSearch snippets) is more reliable than real-browser rendering. |
| **Facebook pages** | Login wall on most public pages. Browser-use returns the wall, not the data. |
| **Sites with confirmed anti-bot WAF (Cloudflare Turnstile, hCaptcha, etc.)** | Skip. The browser-use round-trip will fail and waste time budget. Skill detects challenge pages and aborts. |

### Composition with available browser tools

The cascade picks the first available browser path, in this priority order:

1. **`dev-browser` skill installed** (`~/.claude/skills/dev-browser/` or via plugin) — preferred. Composes by dispatching the skill with the target URL + extraction mode. Skill handles Chromium launch, page state, returns text or screenshot.
2. **`mcp__claude-in-chrome__*` MCP tools available** — second choice. Calls `get_page_text` or `read_page` directly. Requires the student to have the Claude-in-Chrome browser extension connected.
3. **`mcp__computer-use__*` MCP tools available** — last resort. Slower (full screenshot + OCR-style extraction) but works for anything visible on the screen. Use only when 1 and 2 are unavailable AND the row is genuinely high-value.
4. **None available** — graceful skip. Row gets `failure_reason: js_heavy_page_no_browser_tool` and the cascade continues. **Skill never errors out for missing browser tooling.**

### Extraction modes

When browser-use fires, the skill picks a mode based on what's needed:

| Mode | When to use | Cost |
|---|---|---|
| **text** | Default. Read fully-rendered page text (DOM innerText or similar). Cheap, fast. | ~5-8 sec/row |
| **screenshot + transcribe** | When visual layout matters — subscriber count rendered as a badge, "since YEAR" displayed graphically, before/after gallery imagery for craft businesses. Skill takes a screenshot, then Claude reads the image and extracts structured data. | ~10-15 sec/row, higher token cost |
| **inspect** | Targeted DOM query for specific elements when text mode returns too much noise. E.g., "get the value of `[data-test=subscriber-count]`." | ~6-10 sec/row |

Default to **text** unless the playbook explicitly says otherwise. The synthesized skyscraper-chain playbooks should specify mode per source.

### Failure mode for browser-use

- **Browser tool returns an error mid-run** → row gets `failure_reason: browser_use_failed:[reason]`, cascade continues with next row.
- **Browser tool blocks the cascade for >30 sec on one row** → skill kills the call, marks `failure_reason: browser_use_timeout`, moves on.
- **Browser tool returns a challenge page (Cloudflare/captcha)** → skill detects via content signatures (`"Verify you are human"`, `"Checking your browser"`), marks `failure_reason: anti_bot_challenge_detected`, does not retry.
- **Browser tool returns a login wall** → skill detects via redirect to `/login` or `<form>` containing password fields, marks `failure_reason: login_wall_detected`.

### Cost budget for browser-use

Per cohort run, browser-use should fire on **5-15% of rows max**. If the detection heuristic is firing on >25% of rows, the playbook is wrong (cascade is hitting too many JS-heavy pages — probably means the WebSearch step is sending bad URLs).

Skill prints a warning if browser-use fires >25% of the time:

```
⚠️ Browser-use fired on 32/50 rows. That's high — usually means the playbook
is hitting too many JS-heavy pages. Consider:
  - Switching playbook (current: [name])
  - Adding a static fallback source before the browser-eligible one
  - Lowering the row_is_high_value threshold

This run will complete, but may take 2-3x longer than expected.
```

## 7. Execution flow

12 steps from "give me your list" to "ranked CSV in your repo."

1. **Detect input.** Read the user's pasted/uploaded list. Parse via `references/parsing-rules.md` — handles CSV, markdown table, LI export, plain paste, email lists, Apollo/ListKit/Cognism CSVs, ESP exports. If parse fails, ask the user to paste 1-2 example rows in a different format.
2. **Detect input type.** Specifically check: is this email-primary (most rows have email but missing name/company)? If so, mark for §6.5 email-first pre-cascade.
3. **Confirm the list.** Print row count + first 3 examples. Ask: "I see N rows, first one is '[email/name] at [company]'. Proceed?"
4. **Get the ICP.** Check for `~/.ccmb-lp/icp.json` (from `/ccmb-icp-translator`). If absent, ask inline: "Describe your ICP in 1-3 sentences." Run a quick translator-style prompt to extract required signals + weights + exclude rules.
5. **Run signal enrichability audit (§4.5).** Classify each ICP signal as ENRICHABLE / INFERRABLE / UNENRICHABLE. Print the audit to user. On `continue, drop unenrichable`: remove unenrichable signals from scoring weights. On `rewrite`: enter mini-interview to swap unenrichable signals for proxies. On `cancel`: stop.
6. **Pick the playbook (§5).** Run the precise matching algorithm.
   - High-confidence match (score ≥2 in exactly one playbook): use it, confirm with user.
   - Tied medium-confidence matches: ask user to pick.
   - Low or no confidence: offer `/skyscraper` chain or `generic-fallback` with warning.
7. **Confirm depth cap.** Default 60 sec/row. Print estimated total time. If list > 100 rows, suggest 30 sec/row for batch speed.
8. **Run email-first pre-cascade (§6.5) for email-primary rows.** Resolve domain → company, handle → name (when possible). Personal-email rows get the fallback path. Apollo/ListKit imports skip resolution where data is already present.
9. **Run the cascade per row.** For each row:
   - Run playbook sources in order (with pre-resolved company already populated for email-first rows)
   - **After each WebFetch call: check for skeleton HTML** (§6.7 detection rule). If detected AND source is browser-use eligible AND row is high-value AND time budget remaining > 20 sec → escalate to browser-use (dev-browser / claude-in-chrome / computer-use, first available). Else log `skeleton_html_browser_use_skipped` and continue.
   - Accumulate fields across sources
   - Stop early if all ENRICHABLE-bucket ICP signals matched
   - Skip remaining sources if per-row timeout hit
   - Log which sources were consulted to `sources_used` column (mark browser-use escalations with `browser_use:[tool]` suffix)
   - On any failure, log a `failure_reason` (name_too_common, rate_limited, no_public_footprint, skeleton_html_browser_use_skipped, browser_use_timeout, anti_bot_challenge_detected, etc.)
10. **Score each row.** Reuse the existing `lib/lead-research.ts` scoring engine — unchanged. Outputs `score`, `band` (A/B/C/D), `signals_matched`, `top_signal`, `rationale_summary`. INFERRABLE-bucket signals contribute to score with a discount weight.
11. **Rank + write outputs.** Sort by score descending. Write:
    - `./leads/[YYYY-MM-DD]-[icp-slug].csv` (main output)
    - `./leads/enrichment-log.md` (run metadata appended)
    - `./leads/enrichment-followup-[YYYY-MM-DD].md` (if any rows would benefit from `/research:youtube` deep-dives or other manual follow-ups — with the exact commands)
12. **Print top 5 + commit reminder.** Stdout summary: top 5 names + scores + one-line rationale each. Pause for user review. Suggest: "Commit your CSV: `git add leads/ && git commit -m 'enrichment [date] [icp-slug]'`."

Total wall-clock for 50 rows (email-first, B2B mix): ~10-15 min. For 200 rows: ~30-50 min. Apollo/ListKit imports run ~30% faster because resolution steps are pre-filled.

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
- **`/skyscraper`** — invoked automatically when the ICP archetype doesn't match any default or custom cascade playbook. Scouts return ranked existing patterns; the skill synthesizes a one-time playbook for the novel archetype. Optional — skill falls back to `generic-fallback` if `ccmb-skyscraper` isn't installed. See §5 "Chaining with /skyscraper."
- **`dev-browser` skill / `claude-in-chrome` MCP / `computer-use` MCP** — browser-use escalation per §6.7. Fires only when WebFetch returns skeleton HTML on a browser-use-eligible source. Picks the first available tool in that priority order. Graceful skip if none installed — cascade continues with `failure_reason: js_heavy_page_no_browser_tool` on affected rows. **No browser tool is required** for cohort 1; the cascade still works on the ~85% of rows that don't need JS rendering.
- **`/research:youtube`** — for the `creator-thought-leader` playbook, the cascade **does not auto-dispatch** this command. `/research:youtube` is designed for human invocation (writes transcript files to disk, requires a multi-step synthesis pass) and dispatching it mid-cascade would block the run for 5-10 min per row. Instead:
  - **The cascade writes a follow-up file at `./leads/enrichment-followup-[date].md`** listing rows that would benefit from deep YouTube transcript analysis (high-value rows where the routine WebSearch + WebFetch YT discovery returned channel-URL signal but not content-depth signal).
  - **The student manually runs `/research:youtube channel:@handle` after the cascade finishes** on the rows they actually want to deep-dive. ~5-10 min per dispatch, batched at the end, not blocking the cascade.
  - **This is the explicit composition contract for cohort 1.** Programmatic auto-dispatch is a cohort 2+ feature that would require refactoring `/research:youtube` to expose a non-interactive mode. Not in scope now.
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
