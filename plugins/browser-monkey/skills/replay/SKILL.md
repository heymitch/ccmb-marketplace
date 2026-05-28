---
name: replay
description: >
  Replay phase of the Sniffer and Monkey system. Loads monkey.js from the working folder and executes proven fetch() calls directly via browser_evaluate — no Playwright UI interaction needed.
  Say "replay [task] on [site]", "use the API to [task]", "run monkey for [task]", "skip the UI and [task]", "fast mode for [task]", or "do this without clicking around".
  Also triggers automatically when Monkey routes to this phase because endpoints.json and monkey.js already exist.
user-invocable: true
---

# Replay — Fast Execution Phase

The Replay skill loads proven `monkey.js` functions and executes them directly via `browser_evaluate`. This bypasses all Playwright UI interaction — no clicking, no form filling, no waiting for page loads. Just direct API calls using the browser's ambient session auth.

## When Replay Runs

Replay only runs when a `monkey.js` already exists in the working folder for the target site. If not, route back to the Sniffer skill.

## How Replay Works

1. Read `monkey.js` from the working folder
2. Identify which function matches the user's task (or build a new one from `endpoints.json`)
3. Open or confirm a browser tab on the target domain (for ambient auth)
4. Execute the fetch() call via `browser_evaluate`
5. Confirm the result (HTTP status, response data)
6. If successful and this is a new function, offer to save it back to `monkey.js`

## Step 1: Load monkey.js

Read the file from the working folder:

```
[working-folder]/[site-name]/monkey.js
```

Parse the available functions. Each function has a JSDoc comment describing what it does, what parameters it takes, and what HTTP status a success looks like.

## Step 2: Match Task to Function

Read the user's request and match it to an existing function in `monkey.js`. Examples:

| User says | Function to call |
|-----------|-----------------|
| "Create a new Substack draft called X" | `createDraft(title, subtitle)` |
| "Update post 189289551 with this content" | `updateDraft(id, title, body)` |
| "Get my recent posts" | `getPosts()` |

If no function matches, check `endpoints.json` — if a matching endpoint exists, build a one-off fetch() call inline. After it succeeds, offer to save it as a named function in `monkey.js`.

## Step 3: Confirm the Browser Tab

Replay always runs fetch() inside a live browser tab on the target domain. This is required for ambient session auth (cookies).

Check if there's already an open tab on the target domain. If not, navigate to the site's home page or dashboard. The user must be logged in — if not, stop and ask them to log in first.

You do NOT need to navigate to the specific page — just any page on the correct domain. The session cookies will be present.

## Step 4: Execute via browser_evaluate

Inject the relevant function(s) from `monkey.js` and call them:

```javascript
// Example for Substack draft creation
async (page) => {
  // Inject the helper
  async function createDraft(title, subtitle, bodyText) {
    const ORIGIN = location.origin;
    // First, mint a new draft ID by navigating (only once)
    // Or pass an existing ID
    const body = JSON.stringify({
      draft_title: title,
      draft_subtitle: subtitle,
      draft_body: JSON.stringify({
        type: "doc",
        content: [{ type: "paragraph", content: [{ type: "text", text: bodyText }] }]
      })
    });
    const res = await fetch(`${ORIGIN}/api/v1/drafts/${DRAFT_ID}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: body,
      credentials: "include"
    });
    return { status: res.status, data: await res.json() };
  }
  return await createDraft("My Title", "My Subtitle", "Body text here");
}
```

Always use `credentials: "include"` for all fetch calls. Never hardcode auth tokens.

## Step 5: Handle the Response

Check the HTTP status code:

| Status | Meaning | Action |
|--------|---------|--------|
| 200–299 | Success | Report success, show relevant response data |
| 401 | Not authenticated | Tell user to log into the site, then retry |
| 403 | Forbidden | Endpoint may require different auth scope — report to user |
| 404 | Not found | The ID or resource doesn't exist — check parameters |
| 422 | Invalid payload | Request body format is wrong — check `endpoints.json` for correct shape |
| 429 | Rate limited | Wait and retry, or tell user to slow down |
| 5xx | Server error | Report to user, don't retry automatically |

## Step 6: Save Proven Functions Back to monkey.js

After a successful call that used a new or modified function, prompt the user:

> "That worked (HTTP 200). Want me to save this as `[functionName]` in monkey.js so future sessions can use it instantly?"

If yes, append the proven function to `monkey.js` in the correct format (see `references/monkey-js-template.md`).

The rule: **only save functions that have returned HTTP 2xx at least once in this session.** Never save speculative code.

## Step 7: Multi-Step Tasks

For tasks that require multiple API calls (e.g., create a draft, then add an image, then publish), chain them:

1. Execute call 1, confirm success
2. Extract needed values from response (e.g., new resource ID)
3. Execute call 2 with those values
4. Continue until the full task is complete

Always confirm success at each step before proceeding. If any step fails, stop and report which step failed and what the error was.

## Step 8: Offer to Save the Workflow as a Skill

Step 6 saves a single proven API call back to `monkey.js`. This step is one level up: when the user just completed a **multi-step workflow they're likely to repeat** — e.g., "pull my Substack stats and write them to Supabase," "refresh all my dashboard metrics," "export this week's numbers to a CSV" — offer to codify the whole orchestration into a reusable slash command.

After a successful **end-to-end** job, prompt:

> "That whole flow worked. Want me to save it as a slash command — something like `/ss-stats` — so next time you just type that and the entire pull → transform → write happens in one step?"

If yes, scaffold a skill at `~/.claude/skills/[name]/SKILL.md` that:

1. Runs the proven `monkey.js` function(s) via Replay (the atomic API calls)
2. Transforms the response into the shape the destination needs
3. Writes to the destination (Supabase row, CSV, dashboard table)
4. Reports a one-line summary

Naming: short, memorable, prefixed for the site/job — `/ss-stats` (Substack stats), `/kit-pull`, `/refresh-metrics`. Confirm the name with the user before writing.

The rule: **only offer this after the full workflow has succeeded end-to-end at least once this session.** Same principle as Step 6 — codify proven workflows, never speculative ones.

This is the compounding payoff of the whole system: the Sniffer discovers the API, Replay proves the calls, `monkey.js` banks the call, and a **skill banks the orchestration** — turning a workflow you did once into a one-word command you own forever.

## What to Tell the User

Keep it fast and clear:

- "Running directly via API — no UI needed." (before executing)
- "Done. HTTP 200. [brief summary of what happened]" (after success)
- "Hit a 401 — you'll need to log into [site] in the browser first." (on auth failure)

## Reference: Common Patterns

See `references/monkey-js-template.md` for function formats.
See `references/url-variable-rules.md` for how to handle dynamic URL segments like `:id` and `:uuid`.
See `endpoints.json` in the working folder for the specific endpoint shapes for each site.