# SCHEMA.md — Canonical Lead-Research CSV

This is the canonical output schema, preserved verbatim in structure from the
originating build. **Lock this before any research.** Adding columns after
enrichment means re-running agents.

16 columns, in this exact order:

| # | column | purpose |
|---|---|---|
| 1 | `name` | Person (one row per person; an org can have multiple people, and a person can appear under multiple orgs if relevant) |
| 2 | `segment` | The segmentation bucket this lead falls in (the dimension you split the population on — tier, persona, source, theme, etc.) |
| 3 | `segment_note` | The calibration attribute for that segment — how you'd tailor messaging to them (one or two words) |
| 4 | `primary_org` | The org you'd actually be reaching through |
| 5 | `role` | Their role/title at that org |
| 6 | `org_website` | Canonical URL |
| 7 | `primary_email` | General inbox (info@, press@, partnerships@, support@) |
| 8 | `direct_email` | Only if **publicly listed**. If pattern-inferred, write the address followed by `(format inferred — verify)`. If none, `none found`. |
| 9 | `contact_form_url` | If no email exists |
| 10 | `linkedin` | Full URL — sourced from web-search snippets only, never logged-in scraping. `none found` if absent. |
| 11 | `x_handle` | `@handle` or `none found` |
| 12 | `platform_type` | Their primary content surface type: Newsletter / Substack / YouTube / Podcast / Web / Initiative / Product / etc. |
| 13 | `platform_url` | URL of that primary surface |
| 14 | `personalized_opener` | ONE sentence that proves you know their specific work. Must cite a concrete artifact. Blank if none found (never filler). |
| 15 | `notes` | One sentence: what specifically ties them to the topic + best contact path / gatekeeper / quirk |
| 16 | `confidence` | `high` / `med` / `low` — see rubric below. Never blank. |

## Notes on the segment columns

Columns 2–3 (`segment` / `segment_note`) are the only domain-flexible fields.
In the originating build they were theological camps + posture; for a generic
lead population they might be:

- `segment` = ICP tier / persona / opt-in source / content theme / region
- `segment_note` = the one-word calibration cue (e.g. `high-intent`,
  `educate-first`, `price-sensitive`, `technical`)

Everything else stays exactly as named so the file merges cleanly across
projects and maps predictably into a CRM later.

## Confidence rubric

| Value | Meaning |
|---|---|
| `high` | Contact path is publicly listed and verified; person confirmed current; opener cites a real artifact. Act on these first. |
| `med` | Real person/org confirmed, but the best contact is form-only, an inferred email pattern, or thin signal. Verify before sending. |
| `low` | Not yet researched, or could not confirm the person/contact. Treat as a TODO queue, not a contact. |

The `confidence` column is a **priority queue**, not metadata. Sorting by it
gives an immediate outreach order: work `high` for momentum, batch `low` into
one verification pass, only touch `med` after first contact via a safer
channel.

## CSV hygiene

- Quote any field containing a comma, quote, or newline; double internal quotes.
- Validate before declaring done:

```bash
python3 -c "
import csv
rows=list(csv.reader(open('FILE.csv')))
w=len(rows[0])
bad=[i for i,r in enumerate(rows) if len(r)!=w]
print('all rows', w, 'cols' if not bad else f'MISMATCH at {bad}')
"
```
