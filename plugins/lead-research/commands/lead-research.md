---
description: Enrich an opt-in lead list into a confidence-rated CSV with researched fields and personalized openers
argument-hint: "[path to leads CSV] or describe the list + how to segment it"
---

Invoke the **lead-research** skill to enrich a lead list.

Input from the user:

$ARGUMENTS

Follow the skill workflow exactly:

1. Detect available connectors (CRM / enrichment MCP tools) and decide source + enrichment routing.
2. Lock the canonical CSV schema from `SCHEMA.md` BEFORE researching anything.
3. Segment the list.
4. Dispatch one parallel research agent per segment using the verbatim prompt contract in `PLAYBOOK.md`.
5. Verify every inferred field (emails, LinkedIn URLs) via web-search snippets only — never logged-in scraping.
6. Merge into a single confidence-rated CSV; validate column-count consistency.
7. Add personalized openers only when a specific artifact exists for the contact (see the personalization rule in `PLAYBOOK.md`).

If no input list is provided, ask for the opt-in source (CSV path, connected CRM, or a description) and the segmentation dimension before proceeding.
