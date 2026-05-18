# PLAYBOOK.md — Dispatch, Verify, Personalize, Merge

Operational detail for Steps 3–8. Read this before dispatching agents.

---

## Step 3 — Segment

Split the population into **3–6 segments** along one dimension (tier,
persona, opt-in source, content theme, region). Segments should be roughly
balanced — heavily uneven segments skew the deliverable. State the segment
counts before dispatching.

---

## Step 4 — Parallel-agent dispatch contract

Dispatch **one background research agent per segment**, in a single message
(all agents fire concurrently). Every agent gets the **identical** schema
contract — this is what prevents column drift.

Use this verbatim prompt template, filling only the bracketed slots:

```
I'm enriching a lead list. Your job is to research the [SEGMENT NAME] segment
and return a fully enriched row per contact, matching a fixed schema so I can
merge into one CSV.

Contacts to enrich (or: find N more in this segment matching [criteria]):
[LIST or CRITERIA]

For EACH person return a markdown table row with EXACTLY these columns in
this order:

name | segment | segment_note | primary_org | role | org_website |
primary_email | direct_email | contact_form_url | linkedin | x_handle |
platform_type | platform_url | personalized_opener | notes | confidence

Field rules:
- primary_email: general inbox (info@/press@/partnerships@/support@).
- direct_email: ONLY if publicly listed. If you can only infer the format,
  write it followed by "(format inferred — verify)". Else "none found".
  Never present an inferred address as clean.
- linkedin: find via web SEARCH ("[name] LinkedIn [org]"); take the URL from
  the result snippet. Do NOT open LinkedIn pages. "none found" if absent.
- personalized_opener: ONE sentence citing a SPECIFIC artifact of theirs (a
  named book/essay/episode/product). If you cannot find a specific artifact,
  leave it BLANK — do not write generic flattery.
- confidence: high / med / low per the rubric (publicly-verified = high;
  form-only or inferred email or thin signal = med; unconfirmed = low).
- Confirm the person is CURRENT (not departed/deceased) before high.

Method: WebSearch + WebFetch only. Check the contact's site /contact,
/about, /press, /partnerships, plus their podcast/Substack/YouTube
"business inquiries". Verify topic engagement with a "[name] [topic]" search.
No logged-in scraping. No guessed emails presented as real.

Output: the markdown table, then a short prose section listing anyone you
considered but dropped and why, plus any verification flags.
```

Run agents in the background. **Never read an agent's raw JSONL output file**
— it overflows context. Wait for the completion summary.

---

## Step 5 — Verify inferred fields

For anything an agent marked inferred or low-confidence (especially email
formats and LinkedIn URLs), run quick `WebSearch` checks yourself:

- Confirm the LinkedIn URL exists and the employment matches (from the
  snippet, not by opening the page).
- Confirm an email *pattern* via public directory/aggregator snippets — if
  the pattern is confirmed but the exact address isn't, keep it `med` and
  annotate the cell.
- Correct any URL/title the agent got wrong; downgrade confidence if you
  can't confirm.

---

## Step 6 — Merge + validate

1. Concatenate all segment rows under one header in canonical column order.
2. Quote fields containing commas/quotes; double internal quotes.
3. Run the column-count validator from `SCHEMA.md`. A single mismatch means a
   bad quote — fix before continuing.
4. Print the confidence + segment breakdown.

---

## Step 7 — Personalized openers (only if requested)

The opener is the highest-leverage cell and the easiest to ruin.

**The rule:** one sentence, references a *specific* artifact (a named book,
a specific essay/episode title, a specific product or initiative). It should
read like a human who actually consumed their work wrote it.

**Formula:** `[specific artifact of theirs] + [why it's relevant to the
reader/audience or what you'd do with it]`.

**Hard constraint:** if no specific artifact can be cited, the opener stays
blank and the row is flagged. Generic flattery ("love your work on
leadership") collapses the entire differentiation — a blank is better than
filler because it tells the user "do not send this one yet."

---

## Step 8 — Report

Close with a short report:

- **Route taken** (connector vs. native research) and why.
- **Segment counts** and total rows.
- **Confidence breakdown** (high / med / low).
- **Flags** — inferred emails, dropped/stale contacts, unverifiable details.
- **Rebuild note** — the file is single-source; re-running agents on a
  segment regenerates only that segment's rows. Cross-source drift risk:
  if the list also lives in a CRM, the CSV is a point-in-time snapshot —
  note the as-of date.
