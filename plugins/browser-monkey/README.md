# Browser Monkey

Two-phase browser automation for sources that have data but no API. Built for the CCMB Session 6 dashboard bonus — pull analytics from a dashboard (like Substack) into Supabase without a public API, then codify the pull as a one-word command.

## The three skills

| Skill | Role | When it runs |
|---|---|---|
| **`monkey`** | The router / entry point. You invoke this. It checks your working folder and routes you to the right phase. | Every time — say `monkey [site]` |
| **`sniffer`** | Discovery phase. Injects an interceptor into your logged-in browser tab, captures every real `fetch()`/XHR call the page makes, and writes `endpoints.json` (the API map) + a skeleton `monkey.js`. | First time on a site (once) |
| **`replay`** | Fast execution phase. Loads `monkey.js` and fires the proven calls directly via `browser_evaluate` — no clicking, no UI, 10–100× faster. | Every time after the first |

## The lifecycle

```
First visit:   monkey [site]  →  no map exists  →  Sniffer  →  writes endpoints.json + monkey.js
Every visit:   monkey [site]  →  map exists     →  Replay   →  fires proven call → structured JSON
```

Two levels of "save your work":
- **`monkey.js`** banks a proven atomic API call (Replay Step 6).
- **A slash command** banks the whole orchestration — Replay offers to scaffold a skill like `/ss-stats` after a successful end-to-end job (Replay Step 8).

## Why it's keyless

Replay reuses your **browser session's ambient auth** (cookies/tokens from being logged in). No API keys, no credentials in code. That's what makes it the right tool for sources that never issued you a key.

## Scope guard — read this

Use Browser Monkey only on sources that are **(a) no-API, (b) not known-anti-bot, and (c) your own logged-in account.**

- ✅ **Substack** — no analytics API, doesn't aggressively ban automation, you're reading your own dashboard.
- ❌ **LinkedIn** — permanently bans detected automation (unappealable), actively litigates scrapers. **Never point Browser Monkey at LinkedIn.** Enter LinkedIn numbers manually.

## Files

- `skills/{monkey,sniffer,replay}/SKILL.md` — the three skills
- `references/` — `endpoint-schema.md`, `monkey-js-template.md`, `url-variable-rules.md`

## Requirements

- Computer use enabled in Claude settings (so Claude can drive a browser)
- A working folder for `endpoints.json` / `monkey.js` to persist between sessions
- You logged into the target site in the browser (ambient auth)
