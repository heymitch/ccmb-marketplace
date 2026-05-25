---
name: lead-research
description: >-
  Enrich opt-in lead lists from organic content into a confidence-rated,
  research-backed CSV — adds primary org, role, contact paths, LinkedIn/X
  handles, and a one-sentence personalized opener per contact. Use when asked
  to research leads, enrich contacts, add personalized first lines or openers,
  build or fill in a contacts spreadsheet, or run parallel research agents to
  enrich a CSV. Prefers a connected CRM or paid enrichment connector when one
  is available; otherwise uses native web research. NOT for sending email or
  any CRM-write automation — that is a separate sibling skill. NOT for response
  triage, reply handling, scheduling, or deal tracking — that is a separate
  sibling skill. NOT specialized for cold outreach; the focus is enriching
  organic opt-in leads.
---

# Lead Research

Turn a raw opt-in list into a decision-ready, confidence-rated contact sheet.

The durable output is **one clean CSV** where every row is enriched, every
inferred value is flagged, and the `confidence` column doubles as a triage
queue. Personalized openers are an optional add-on, not the core.

## When this applies

- A CSV / export of opt-ins from organic content (newsletter, lead magnet, webinar, content upgrade)
- A list of names/orgs that needs contact + context enrichment
- A request to "research these leads," "enrich this spreadsheet," "add personalized openers," or "build a contacts CSV with parallel agents"

## When this does NOT apply (route elsewhere)

| Request | Not here — belongs to |
|---|---|
| Send the emails / load into CRM / sync records | Sending & CRM-automation skill |
| Handle replies, book calls, track deals | Response-triage skill |
| Decide who the segments/ICP should be from scratch | Audience-research work (do that first, then come back) |

This skill assumes the segments are roughly known going in and stops at a
finished CSV (+ optional openers). It never sends anything and never writes
to a CRM.

## Workflow (orchestrator)

```
0. CONFIG     → read the working dir's CLAUDE.md; load the voice archetype, ICP/targeting, and opener-style it points to (steer SEGMENT + OPEN). Absent → defaults.
1. DETECT     → what connectors exist? (decision table below)
2. LOCK       → fix the CSV schema BEFORE any research (see SCHEMA.md)
3. SEGMENT    → split the population into 3–6 segments
4. DISPATCH   → one parallel research agent per segment (verbatim contract in PLAYBOOK.md)
5. VERIFY     → web-search-check every inferred email / LinkedIn URL
6. MERGE      → single CSV, validate equal column count on every row
7. OPEN       → add personalized openers only where a specific artifact exists
8. RATE       → confidence high/med/low on every row; never leave blank
```

### Step 0 — Working-dir config (steers the run)

The skill runs in the user's working folder, so its `CLAUDE.md` is already in
context. Read it first and honor any pointers it gives to:

- **Voice archetype** + **opener-style** → used in Step 7 (openers).
- **ICP / targeting** (signals, qualify/exclude, segments) → used for SEGMENT
  (Step 3) and the agent criteria (Step 4) instead of asking.

This config is the **user's**, kept in their folder — never inside the plugin —
so marketplace updates can't overwrite it. If `CLAUDE.md` points to nothing,
fall back to the defaults in this skill.

### Step 1 — Connector routing decision table

Check the available tools/MCP connectors first, then route:

| Situation | Source the list from | Enrich with | Write results to |
|---|---|---|---|
| CRM connector present (HubSpot, Notion, Airtable, etc.) **and** holds the opt-ins | The connector | Connector's own enrichment if it has one, else parallel web research | Local CSV (this skill never writes back) |
| Paid enrichment connector present (data/contact MCP) | Provided CSV or connector | That connector first, web research to fill gaps | Local CSV |
| No relevant connector | Provided CSV / pasted list | Parallel web-research agents | Local CSV |

Always prefer a connected first-party source over scraping. Surface to the
user which route you took and why.

### Steps 2–8

The canonical schema (Step 2) and the verbatim parallel-agent prompt
contract, verification rules, personalization formula, and merge/validation
steps (Steps 3–8) live in the reference docs so they load only when needed:

- **`SCHEMA.md`** — the exact 16-column canonical schema (preserved from the originating build), column semantics, and the confidence rubric.
- **`PLAYBOOK.md`** — the parallel-agent dispatch contract, web-verification rules, the personalized-opener formula, and the merge/validate procedure.

Read `SCHEMA.md` before Step 2. Read `PLAYBOOK.md` before Step 4.

## Anti-patterns (learned the hard way — do not repeat)

1. **Inferred email shown as verified.** If an address is pattern-guessed
   (`first+last@domain`), it must carry `(format inferred — verify)` in the
   cell and the row's confidence is capped at `med`. Never present a guessed
   address as a clean contact.
2. **Stale or deceased contacts.** A research agent must confirm the person
   is current. A real list nearly shipped with someone who had passed away —
   the verification step exists because of this.
3. **Specific-and-wrong over vague-and-right.** If a precise detail (title,
   affiliation, institution) can't be verified, use the broader correct
   anchor. Wrong specificity reads as AI slop and kills credibility.
4. **Generic personalized openers.** If no specific artifact (named
   book/essay/episode/product) can be cited for a contact, leave the opener
   blank and flag it. Flattery filler defeats the entire purpose.
5. **LinkedIn scraping.** Only use LinkedIn URLs that appear in web-search
   result snippets. Never fetch logged-in or behind-auth pages.
6. **Reading agent transcript files.** Never `cat`/`tail` a sub-agent's JSONL
   output file — it overflows context. Trust the completion summary.
7. **Column drift across parallel agents.** Every agent gets the *identical*
   schema contract. Before declaring done, validate that every row has the
   exact same column count.
8. **Researching before locking the schema.** Schema first, always. Adding a
   column after enrichment means re-running agents.

## Definition of done

- One CSV, every row same column count (validate programmatically).
- Every row has a `confidence` value; inferred data flagged inline.
- Openers (if requested) each cite a specific artifact, or are blank+flagged.
- A one-paragraph report: route taken, segment counts, confidence breakdown, rebuild instructions.
