# The /api/metrics contract (annotated)

This is the full shape `build-dashboard-ui` binds to via `data-k` attributes. Add keys as the user's funnel needs them; keep the `null` vs `0` discipline everywhere.

```jsonc
{
  // ISO timestamp; UI renders "Updated <relative>" in the header.
  "updated_at": "2026-05-14T18:38:08.063Z",

  // Top-of-funnel through conversion. null = no connector. number = real (0 is real).
  "funnel": {
    "visits":         null,   // GA4/Plausible/Vercel Analytics adapter
    "visits_delta":   null,   // optional period-over-period
    "quiz_started":   12,     // events where type='started'
    "start_rate":     null,   // quiz_started / visits (null until visits has a connector)
    "quiz_completes": 9,      // count(quiz_submissions)
    "complete_rate":  0.75,   // quiz_completes / quiz_started
    "optins":         4,      // count(quiz_contacts) — email captured
    "optin_rate":     0.444,  // optins / quiz_completes
    "open_to_meet":   1,      // quiz_contacts where interview_opt_in
    "otm_rate":       0.25,
    "booked":         null,   // Calendly webhook adapter
    "booked_rate":    null
  },

  // Email nurture, per email. All null until the ESP webhook is wired.
  "emails": [
    { "num": 1, "delivered": null, "open_rate": null, "ctr": null,
      "reply_rate": null, "unsubscribed": null, "bounced": null }
    // ...one object per email in the sequence
  ],

  // Cold outreach pipeline (manual CSV/SQL source is common).
  "cold": {
    "sent": null, "opened": null, "open_rate": null,
    "replied": null, "reply_rate": null,
    "booked": null, "booked_rate": null, "bounced": null
  },

  // Newsletter overlay. Substack RSS gives post_count + latest only.
  "substack": {
    "subscribers":  null,   // NOT available via Substack RSS — keep null or mark manual
    "post_count":   7,
    "latest_post":  "On making plans",
    "avg_open_rate": null,
    "avg_ctr":      null,
    "growth_30d":   null
  },

  // One entry per logical source. status drives the UI's live/pending dot.
  // status: "live" (reading real data now) | "pending" (path known, not wired)
  //         | "manual" (human-updated table)
  "sources": {
    "funnel":   { "status": "live",    "note": "Supabase RPC · dashboard_funnel_metrics · live" },
    "emails":   { "status": "pending", "note": "ConvertKit webhooks · pending wiring" },
    "cold":     { "status": "manual",  "note": "CSV import / SQL updates" },
    "substack": { "status": "live",    "note": "RSS · live" }
  },

  // Optional one-liner the UI shows under the benchmark tiles.
  "bench_note": "9 completed · 4 opt-ins"
}
```

## Rules

1. **`null` ≠ `0`.** `null` → UI shows `—` (no connector). `0` → UI shows `0` (live, genuinely zero).
2. **Rates are computed server-side** with safe division: `den > 0 ? num/den : null`. Never divide by zero into `NaN`; emit `null`.
3. **`sources` is mandatory and exhaustive.** Every panel on the dashboard maps to exactly one `sources` entry. No silent panels.
4. **`status` transitions are the only thing that changes** as the build progresses. The contract shape is stable from day one; you fill it in over time.
5. **Cache header:** `cache-control: private, max-age=60`. Private (it's behind auth), short TTL (numbers move, but not every second).
