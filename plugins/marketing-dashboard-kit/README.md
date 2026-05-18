# marketing-dashboard-kit

A Claude Code plugin for the **Claude Code Marketing Bootcamp**. It turns "I want a dashboard for my marketing" into a deployed, password-protected, brand-matched analytics page reading live data — without the student needing to know auth crypto, Postgres RLS, or Vercel deploy internals.

## The chain

```
discover-connectors  →  dashboard-data-layer  →  build-dashboard-ui  →  deploy-gated-site
                              │
                              └── uses ──► supabase-sql  (standalone DB-safety tool)
```

| Skill | Does | Output |
|---|---|---|
| **discover-connectors** | Interviews the student on their funnel + resolves each platform to the cheapest connector (native MCP → API → RSS → webhook → manual) | a connector map |
| **dashboard-data-layer** | Stands up the Supabase store + a `/api/metrics` projection layer with one adapter per source, honest live/pending status | `/api/metrics` |
| **supabase-sql** | Standalone: how to read a DB safely — SECURITY DEFINER aggregates, RLS, anon vs service-role. Useful far beyond dashboards. | safe SQL patterns |
| **build-dashboard-ui** | Detects the student's existing design system and renders the contract in *their* brand, never a generic template | `dashboard.html` |
| **deploy-gated-site** | Edge-Middleware password gate + Vercel deploy, with the deploy-hygiene traps that silently ship stale code | live gated URL |

## How a student uses it

They say "build me a marketing dashboard." `discover-connectors` triggers first, the chain runs in order, each skill hands the next its artifact. Each student's dashboard ends up looking like their own site because `build-dashboard-ui` inherits their design tokens — same machinery, different skin.

## Design principles baked in

- **Never fake data.** `null` → `—` + a "pending" dot. `0` only when a live connector genuinely returns zero.
- **Never leak the database.** Aggregates go through a SECURITY DEFINER function callable by the public key; the service-role key never reaches a client.
- **Never ship stale.** Deploy from `main` via git, not `vercel --prod` from whatever folder is open.
- **Never a generic template.** Detect and inherit the existing design system before composing.

## Provenance

Distilled from a live end-to-end build (Disciple AI marketing dashboard). Every "common mistake" in these skills is a bug that actually happened and got fixed during that session — the `echo` env-var newline, the `trailingSlash` relative-path break, three stale-deploy incidents from worktree drift, and the service-role-exposure that was avoided with a SECURITY DEFINER RPC.
