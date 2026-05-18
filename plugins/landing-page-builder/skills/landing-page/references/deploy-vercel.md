# Deploy to Vercel + Pluggable Email Capture

The page goes live on the **student's own** Vercel account. No shared accounts, no hardcoded form IDs, no fixed domains.

## Pluggable email capture

The form posts to whatever email tool the student already uses. Ask which one and get the endpoint/ID. Never hardcode a provider.

| Provider | What to ask for | Form action |
|---|---|---|
| Kit / ConvertKit | Form ID | `POST https://app.kit.com/forms/{FORM_ID}/subscriptions` |
| Mailchimp | Embedded form action URL | the `action` URL from their embed code |
| Formspree | Form ID | `POST https://formspree.io/f/{FORM_ID}` |
| Custom / API route | endpoint URL | their endpoint |
| None yet | — | ship a no-op form + clearly-marked `TODO: add capture endpoint` and a one-line how-to |

Build the form as a **native HTML form** (not a third-party script embed):
- POSTs to the provider endpoint
- Shows "Check your email for access" on success
- Captures UTM params from the URL into `localStorage` for later attribution
- Degrades to a normal form submit if JS fails

The capture provider + endpoint live in the page schema's `capture:` block (see `page-structure.md`). Store nothing secret in client code — these endpoints are public form posts by design.

## Deploy

### Path A — Vercel MCP (preferred if connected)
Use the Vercel MCP deploy tool. Pass the built project directory. Get the production URL back.

### Path B — Vercel CLI (no MCP)
```bash
# from the project directory, student logged into their own Vercel
npx vercel --prod
```
First run prompts the student to log in / link a project. The result is `https://<their-project>.vercel.app`. Custom domains are a paid-Vercel step — mention it, don't block on it.

## Before deploying — required

1. Build locally and fix every error/warning that affects render.
2. Confirm every image slot from Phase 4 is resolved (real asset or marked placeholder, no broken links).
3. Confirm meta + `og:image` are set so shared links render.
4. **Show the student a preview (local dev URL or screenshot) and get an explicit "ship it".** Never deploy on assumption.

## After deploying

- Return the live URL.
- Write the live URL and the chosen deploy method back to `landing-page-brief.md` under `## Landing Page`.
- If capture was a no-op TODO, remind the student in one line how to wire it and redeploy.
