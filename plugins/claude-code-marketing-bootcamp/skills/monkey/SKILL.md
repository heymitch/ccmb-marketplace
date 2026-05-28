---
name: monkey
description: >
  Main entry point for the Sniffer and Monkey browser automation system. Routes to the right phase based on what exists in the working folder.
  Say "monkey [site]", "automate [task] on [site]", "use monkey for [site]", "run monkey", "sniff and replay", "browser shortcut for [site]", or "do [task] via API on [site]".
  Also triggers when a user wants to automate a browser task they've done before, or asks if a site has been sniffed already.
user-invocable: true
---

# Monkey — Router Skill

The Monkey skill is the entry point for the Sniffer and Monkey system. It checks the working folder, decides which phase to run, and hands off to the right sub-skill.

## The Two-Phase Model

**Phase 1 — Sniffer** (first time on a site): Intercept and catalog all fetch/XHR calls the site makes. Write `endpoints.json` (the API surface map) and a skeleton `monkey.js` to the working folder. This runs once per site.

**Phase 2 — Replay** (every time after): Load `monkey.js` from the working folder. Execute the proven fetch() calls directly via `browser_evaluate`. No Playwright UI interaction needed. This is 10–100x faster than clicking through the UI.

## Routing Logic

When this skill is invoked, follow this decision tree:

### Step 1: Check for a working folder

Use the `Glob` or `Bash` tool to check if the user has a working folder selected (files accessible at `/sessions/.../mnt/`). If no folder is selected, tell the user:

> "To use Monkey, you'll need a working folder — this is where I save the API map and scripts between sessions. Select a folder in Cowork settings, then try again."

### Step 2: Identify the target site

Ask the user (or infer from their message) which site or service they want to automate. Extract the base domain (e.g., `substack.com`, `notion.so`).

### Step 3: Check what's already in the working folder

Look for these files in the working folder (or a subfolder named after the site):
- `endpoints.json` — the API surface map
- `monkey.js` — proven, executable fetch() functions

```bash
ls /path/to/working-folder/[site-name]/
```

### Step 4: Route to the right phase

| What exists | Action |
|-------------|--------|
| Neither file | → **Invoke the Sniffer skill** |
| `endpoints.json` but no `monkey.js` | → **Invoke the Sniffer skill** (sniffer will also build monkey.js on first proven run) |
| Both files present | → **Invoke the Replay skill** |

### Step 5: After the first successful Replay

If the user just ran a Replay task successfully for the first time on a given endpoint, prompt them:

> "That worked. Want me to save this as a permanent function in monkey.js so future sessions can skip the setup entirely?"

If yes, append the proven function to `monkey.js` in their working folder.

## What to Tell the User

Keep it simple. Don't expose file paths or implementation details unless asked. Frame everything as:

- "I've seen this site before — I can do this directly without navigating the UI."
- "This is a new site — I'll watch what API calls it makes first, then we can automate it."
- "I found your Monkey scripts for [site]. Running now."

## Important Rules

- Never hardcode credentials or API keys in `monkey.js` — auth is always ambient (browser session cookies)
- The working folder is the source of truth — always read from it, always write back to it
- `monkey.js` is written from proof, not speculation — only add functions that have returned HTTP 2xx at least once
- If a site blocks browser automation, stop and tell the user

## ⛔ MUTATION SAFETY RULES — NON-NEGOTIABLE

These rules exist because blind API probing permanently destroyed a production automation ([GI TEMPLATE] Free Email Course Automation) and created unwanted records. **These rules can never be loosened without explicit user instruction.**

---

### 🚫 RULE 1: NEVER DELETE. EVER.

**There is no scenario in which Monkey fires a DELETE request.** Not for cleanup, not for testing, not for "throwaway" records, not even if the user seems to imply it. DELETE is permanently off the table.

- **Never add DELETE functions to `monkey.js`**
- **Never probe DELETE endpoints for existence** — DELETE needs no body; it executes immediately on any valid ID
- **Never suggest deletion as a cleanup step** — tell the user to do it manually in the UI if needed
- If the user explicitly says "delete X", respond: "I don't fire DELETE requests — you'll need to delete that manually in the UI."

---

### 🚫 RULE 2: NEVER EDIT LIVE RECORDS. USE SANDBOX-FIRST.

**Before modifying any live/active/production record, a sandbox copy must exist.**

The sandbox pattern:
1. **Duplicate** the live record via a POST (create a copy)
2. **Edit the duplicate** — all PATCH/PUT work happens on the copy
3. **Present the result** to the user for review
4. **User decides** whether to promote it (manually, in the UI) or discard it

This applies to:
- Live automations → duplicate first, edit the copy
- Active email sequences → duplicate first, edit the copy
- Published broadcasts/campaigns → duplicate first, edit the copy
- Any record with `active: true`, `live: true`, or `status: "published"` → sandbox first, always

> ✅ Right: `POST /automations` (duplicate) → `PATCH /automations/{new_id}` (edit copy)
> ❌ Wrong: `PATCH /automations/{live_id}` (directly editing the live record)

---

### 🚫 RULE 3: NO BLIND POST/DELETE PROBING.

The empty-body `{}` existence probe (400 = exists, 404 = not found) is **only safe for PATCH and PUT**.

| Method | Empty-body probe safe? | Why |
|--------|----------------------|-----|
| GET    | ✅ Always safe        | Read-only |
| HEAD   | ✅ Always safe        | Read-only |
| PATCH  | ✅ Safe for existence | `{}` → 400 if endpoint exists but needs fields |
| PUT    | ✅ Usually safe       | Same pattern |
| POST   | ❌ NEVER              | `{}` may succeed with defaults, creating real records |
| DELETE | ❌ NEVER (see Rule 1) | Executes immediately, no body required |

**Discover POST endpoints by observation only** — let the sniffer capture the real call the UI makes. Never probe blind.

---

### ✅ RULE 4: HITL BEFORE EVERY MUTATION.

Before firing **any** non-GET, non-HEAD request:
1. State: method, URL, full body
2. State: what will be created/changed if it succeeds
3. State: whether it targets a live record or a sandbox copy
4. Wait for explicit **`go`** from the user

No exceptions. Single-word approvals ("go", "yes", "do it") are sufficient — but the user must give one.