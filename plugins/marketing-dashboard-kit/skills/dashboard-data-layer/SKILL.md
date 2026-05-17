---
name: dashboard-data-layer
description: Use when a connector map exists and you need a single JSON endpoint that aggregates marketing data from Supabase plus live feeds and degrades gracefully per source. Second step of marketing-dashboard-kit, before building dashboard UI. Triggers - "wire the data", "/api/metrics", "connect Supabase to the dashboard", "aggregate my marketing data".
---

# Dashboard Data Layer

## Overview

The dashboard must never be a renderer with numbers hard-coded into HTML — those rot on first refresh. Instead, the dashboard is a dumb renderer and **one endpoint, `/api/metrics`, is the projection layer**. Every data source is a swappable adapter inside it. Each adapter reports a `status` so the UI can show a live/pending dot instead of fabricating data.

Core principle: **One endpoint, many adapters, honest status per source. The UI never changes as sources come online — only an adapter's status flips from `pending` to `live`.**

**REQUIRED SUB-SKILL:** Use `supabase-sql` for the SECURITY DEFINER aggregate function and key-safety. This skill assumes you already produced a connector map via `discover-connectors`.

## The contract

`/api/metrics` returns this shape. The keys are the contract between data and UI — `build-dashboard-ui` binds to them. Full annotated contract: [references/metrics-contract.md](references/metrics-contract.md).

```json
{
  "updated_at": "2026-05-14T18:38:08Z",
  "funnel":   { "visits": null, "quiz_started": 12, "quiz_completes": 9, "optins": 4, "booked": null },
  "emails":   [ { "num": 1, "delivered": null, "open_rate": null } ],
  "substack": { "post_count": 7, "latest_post": "..." },
  "sources":  {
    "funnel":   { "status": "live",    "note": "Supabase RPC · live" },
    "emails":   { "status": "pending", "note": "ConvertKit webhooks · pending wiring" },
    "substack": { "status": "live",    "note": "RSS · live" }
  }
}
```

`null` means "this number has no connector yet" — the UI renders `—`, never `0` and never a fake value. `0` means "connector is live and the real count is zero." This distinction is the whole point.

## Build order

1. **Schema** — create the tables the funnel needs (or reuse what the quiz/form already writes). Reuse beats new: if `quiz_submissions` / `quiz_contacts` / `quiz_events` already exist, the data layer reads them, it does not recreate them.
2. **Aggregate function** — one SECURITY DEFINER function returning the funnel JSON. See `supabase-sql`. Test it with a direct SQL call before wiring the endpoint.
3. **`/api/metrics`** — verify auth (see `deploy-gated-site`), then call each adapter in parallel, assemble the contract, set per-source status.
4. **Adapters** — one async function per source. Each returns `{configured, error?, ...data}`. Source status is derived: `configured && !error → live`, else `pending`.

## The adapter pattern (graceful degradation)

```js
async function fetchQuizFunnel() {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) return { configured: false };
  try {
    const r = await fetch(`${SUPABASE_URL}/rest/v1/rpc/dashboard_funnel_metrics`, {
      method: 'POST',
      headers: { apikey: SUPABASE_ANON_KEY, Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
                 'content-type': 'application/json' },
      body: '{}',
    });
    if (!r.ok) return { configured: true, error: 'rpc_failed' };
    return { configured: true, ...(await r.json()) };
  } catch { return { configured: true, error: 'fetch_failed' }; }
}

// In the handler:
const [quiz, sub] = await Promise.all([fetchQuizFunnel(), fetchSubstack()]);
const funnelLive = quiz.configured && !quiz.error;
return res.status(200).json({
  funnel: { quiz_started: funnelLive ? quiz.quiz_started : null, /* ... */ },
  sources: {
    funnel: funnelLive
      ? { status: 'live', note: 'Supabase RPC · live' }
      : { status: 'pending', note: 'Set SUPABASE_ANON_KEY / deploy the RPC' },
  },
});
```

**Why `Promise.all`:** sources are independent; one slow feed shouldn't serialize the others. **Why try/catch returns instead of throws:** a dead feed degrades that one tile to `—`, it doesn't 500 the whole dashboard. A dashboard you check at 6am must never white-screen because Substack's RSS hiccuped.

## Per-connector-type adapter recipes

| Connector type | Adapter shape |
|---|---|
| Supabase aggregate | POST to `/rest/v1/rpc/<fn>` with anon key (see `supabase-sql`) |
| RSS (Substack) | `fetch(feed)` → regex `<item>` count + first `<title>`. No subscriber data exists. |
| Hosted webhook (Calendly/Kit) | Webhook writes rows to an `events` table; the adapter is just a Supabase aggregate over those rows |
| Manual (cold outreach) | Adapter reads a `cold_outreach` table; humans update it by CSV import / SQL |

Webhook endpoints (`/api/webhooks/<source>`) validate a `?secret=` against an env var, then insert into `events`. The metrics adapter never talks to the platform — it only ever reads your own tables. This keeps the read path uniform: **everything funnels through Supabase aggregates.**

## Common mistakes

- **Hard-coding numbers in the dashboard HTML.** The endpoint is the only source of truth.
- **Returning `0` when you mean "no connector".** Use `null`. The UI distinguishes `—` from `0`.
- **One adapter throwing 500s the whole endpoint.** Each adapter try/catches and degrades locally.
- **Metrics adapter calling the marketing platform's API directly.** Webhooks write to your DB; the adapter reads your DB. Uniform, cacheable, resilient.
- **Skipping the auth check on `/api/metrics`.** It exposes business numbers. It must verify the session cookie (see `deploy-gated-site`).

## Next in the chain

Hand the finished contract to **build-dashboard-ui**. The auth check this endpoint performs is defined by **deploy-gated-site** (build that skill's `/api/login` + cookie scheme alongside this).
