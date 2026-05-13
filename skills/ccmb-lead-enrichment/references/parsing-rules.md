# Parsing Rules — How the skill handles messy input

The skill accepts any reasonable list format and parses it into a normalized internal shape before running the waterfall. These rules cover the formats encountered in real cohort runs.

**Normalized internal shape:**

```typescript
type RawProspect = {
  full_name: string          // required, the only field that MUST be parseable
  company?: string           // optional, useful for company-About lookups
  role?: string              // optional, scoring signal if present
  email?: string             // optional, used for username derivation (e.g., @github)
  url?: string               // optional, primary public URL if known
  notes?: string             // optional, anything else the user passed in
  source_row?: string        // optional, original raw input for debugging
}
```

The waterfall enriches `RawProspect[]` into the fuller scoring shape downstream.

---

## Format 1 — CSV with headers

**Example input:**
```
Name,Company,Role,LinkedIn URL
Sarah Chen,Acme Inc,Head of Marketing,https://linkedin.com/in/sarahchen
Bob Johnson,Foo Corp,Founder,https://linkedin.com/in/bjohnson
```

**Parsing:**
- Header row mapped case-insensitively. Synonyms recognized:
  - `name | full name | full_name | contact` → `full_name`
  - `company | organization | org | employer` → `company`
  - `role | title | position | job title` → `role`
  - `email | email address | contact email` → `email`
  - `url | website | linkedin | linkedin url | link | profile` → `url`
- Extra columns preserved in `notes` as JSON
- Empty cells = field absent (not empty string)

**Mistakes the skill catches:**
- No header row → asks user to confirm first row is data
- Quote-escaping broken → falls back to TSV split + warns
- BOM at start → stripped silently

---

## Format 2 — Markdown table

**Example input:**
```
| Name | Company | Role |
|---|---|---|
| Sarah Chen | Acme Inc | Head of Marketing |
| Bob Johnson | Foo Corp | Founder |
```

**Parsing:** Same column mapping as CSV. Separator row (`|---|---|`) detected and skipped. Leading/trailing pipes stripped.

---

## Format 3 — LinkedIn Connections export

**Specific to LI's official export format.** Has a known structure:

```
First Name,Last Name,URL,Email Address,Company,Position,Connected On
Sarah,Chen,https://www.linkedin.com/in/sarahchen,,Acme Inc,Head of Marketing,15-Jan-2026
```

**Parsing:**
- `First Name` + `Last Name` → `full_name` (concatenated with space)
- `URL` → `url`
- `Company` → `company`
- `Position` → `role`
- `Email Address` → `email` (often empty in LI exports; that's fine)
- `Connected On` → `notes.connected_on` (useful for "recent connections" filtering)

Skill auto-detects this format if header row exactly matches. No user confirmation needed.

---

## Format 4 — Plain paste, structured lines

**Example input:**
```
Sarah Chen, Acme Inc, Head of Marketing
Bob Johnson, Foo Corp, Founder, bob@foocorp.com
Maria Lopez at TechFlow (CTO)
```

**Parsing:**
- Comma-separated: split, first chunk = `full_name`, second = `company`, third = `role`, anything @-shaped = `email`, anything http-shaped = `url`
- "Name at Company (Role)" pattern → regex extract
- "Name - Company - Role" pattern → split on " - "

Skill prints back its parse: "I read row 1 as: Sarah Chen | Acme Inc | Head of Marketing. Confirm or correct?"

---

## Format 5 — Plain prose paste

**Example input:**
```
I want to enrich: Sarah Chen (she runs marketing at Acme), Bob Johnson the founder
of Foo Corp, and Maria Lopez who's CTO at TechFlow.
```

**Parsing:** Skill uses LLM extraction (its own reasoning) to pull `(name, company, role)` tuples. Slow per row but works.

**When to use this format:** when you genuinely have unstructured notes. For 50+ rows, convert to CSV first — LLM extraction is the slowest input path.

---

## Format 6 — Just names (worst case but supported)

**Example input:**
```
Sarah Chen
Bob Johnson
Maria Lopez
```

**Parsing:**
- Each line = one `full_name` with all other fields empty
- Waterfall must work harder per row — no company hint, no role hint
- Skill warns: "Names-only input means the waterfall has less starting context. Expect ~30% more enrichment time per row and lower confidence in matches."

If a name is ambiguous ("John Smith"), the skill flags the row with `enrichment_confidence: low` regardless of what it finds.

---

## Handling duplicates

After parse, before waterfall:

1. Group rows by `(full_name.toLowerCase(), company?.toLowerCase())`.
2. Within group: merge fields (non-empty wins). Keep one row.
3. Print to user: "Found N duplicates, merged into M unique rows. Proceeding with M."

---

## Handling rows the skill refuses to enrich

- **Empty `full_name`** → row skipped, logged to `enrichment-log.md` as "skip:no-name"
- **`full_name` matches a known generic pattern** (e.g., "Admin", "Contact Us", "Info") → row skipped, logged as "skip:generic-handle"
- **Row contains explicit "do not contact" or "DNC" anywhere** → row written to output CSV with `band: DNC`, no enrichment attempted

---

## Output column ordering (always)

The skill ALWAYS writes columns in this order, regardless of input shape:

```
rank, score, band, full_name, company, role, email, url, company_size,
signals_matched, top_signal, rationale_summary, sources_used,
enrichment_confidence, public_urls, notes
```

This locks the downstream contract — S5's email-drafting reads from a known shape regardless of which input format the student used.

---

## What the skill never parses

- Image attachments (screenshots of lists). Asks user to OCR first or paste as text.
- PDF attachments. Asks user to convert.
- Excel `.xlsx` directly. Asks user to "File → Save As → CSV."
- JSON arrays of objects. Asks user to flatten to CSV (probably a future enhancement, low-priority for cohort 1).

For each, skill prints a one-line "paste it as CSV or a plain list and I'll handle it from there" message. No auto-conversion of binary formats.
