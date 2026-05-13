---
name: sample-gatherer
description: Intelligently gather writing samples from wherever the user's writing lives.
user-invocable: false
---

# Sample Gatherer

## Purpose

Collect writing samples from writer's actual content sources. Support multiple source types (Notion, Google Docs, local files, Substack, paste, inbox).

## Flow

**1. Check inbox/ first**
Check `inbox/` for any files that look like writing samples — File Master may have already sorted some there. If found, surface them: "Looks like you've already got some writing samples in your inbox — [list filenames]. Want to use these, or pull from somewhere else too?"

**2. Identify Available Sources**

Query for content sources where writer actively publishes or drafts:
- Notion workspace pages
- Google Drive documents
- Local file system directories
- Substack newsletter
- Direct paste input

Present available options based on API access and user preference.

**3. Fetch from Notion**
If selected, use Notion MCP tools to search recent pages. Display available pieces with dates. Accept user selection.

**4. Fetch from Google Drive**
If selected, use Google Docs MCP tools to search documents. Display results. Accept user selection.

**5. Fetch from Local Folder**
If selected, prompt for folder path. Glob for .md, .txt, .docx files. Display results. Accept user selection.

**6. Fetch from Substack**
If selected, prompt for Substack URL. Web fetch recent posts and display. Accept user selection.

**7. Accept Pasted Samples**
If pasting, accept input one or more samples at a time.

**8. Validate Sample Count**
- Minimum 3 samples required to proceed
- 5+ samples preferred for comprehensive analysis
- If under 3, prompt for additional samples

**9. Save Samples to Workspace**
Save each collected sample to `voice/` with a clean filename based on source and date (e.g., `voice/linkedin-post-march.md`, `voice/newsletter-feb.md`). One file per sample.

After saving, update `CLAUDE.md` Training Data section with the new sample count.

**10. Return Samples**
Pass collected samples to voice-dna-extractor with source metadata and counts.

## Rules
- Never block on a missing source — if Notion isn't connected, just move on: "No worries, let's try another spot."
- Always offer paste as fallback
- Ask for their BEST writing, not just any writing
- Minimum 3 to proceed, but don't be rigid about it
- Never read files without confirming the path first
- Keep it conversational — this is a chat, not an intake form
- Always check inbox/ before asking where writing lives — the answer might already be there
