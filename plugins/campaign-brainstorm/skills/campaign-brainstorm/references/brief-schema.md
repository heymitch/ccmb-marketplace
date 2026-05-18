# Campaign brief schema (the 16-field contract)

Every `campaigns/<slug>/brief.md` follows this structure. YAML frontmatter is the machine-parseable contract downstream skills consume. Markdown body is the human-readable narrative.

## Frontmatter (required keys, may have empty values)

```yaml
---
campaign_name: "Q3 SaaS Launch"
slug: q3-saas-launch
type: launch                          # launch | growth | event (v1 = launch only)
status: draft                          # draft | live | wrapped
created: 2026-05-13
launch_window:
  pre: 2026-06-01                     # pre-launch start
  launch: 2026-06-15                  # the day
  close: 2026-07-15                   # campaign window end

goal:
  statement: "200 paying customers for Pro tier by 2026-07-15"
  smart_check:
    specific: yes
    measurable: yes
    achievable: yes
    relevant: yes
    time_bound: yes

kpis:
  - {name: paid_signups, target: 200, source: stripe}
  - {name: free_trial_starts, target: 1000, source: app_db}
  - {name: lp_conversion_rate, target: 0.04, source: vercel_analytics}

audience:
  persona_name: "Bootstrapped SaaS Founder"
  size_estimate: 12000
  where_they_hang_out: [linkedin, twitter, indiehackers, reddit_r_saas]

offer:
  name: "Pro tier"
  price_usd: 99
  billing: monthly
  includes: ["unlimited projects", "team seats", "priority support"]

channels:
  - {name: linkedin, role: primary,   cadence: "1x/day, 30 days"}
  - {name: email,    role: primary,   cadence: "weekly broadcast + 7-email nurture"}
  - {name: twitter,  role: amplifier, cadence: "3x/day threads"}

assets:
  - {type: landing_page, status: needs_build, owner: ccmb-lp-build}
  - {type: lead_magnet,  status: planned,     owner: s2-magnet-factory}
  - {type: email_sequence, status: planned,   owner: s5-nurture, length: 7}

claude_stack:
  skills:       [ccmb-landing-page, ccmb-headline-writer, ccmb-sentence-editor]
  mcps:         [gmail, notion, slack]
  schedulers:   [vercel_cron]
  data_sources: [vercel_analytics, kit_api, stripe_webhooks]

remarketing:
  segments:
    - {name: "visited_lp_no_signup", trigger: "3+ LP visits, no form fill", sequence: "objection-4-email"}

budget_usd:
  total: 500
  allocation:
    - {channel: ads_linkedin, amount: 300}
    - {channel: contingency,  amount: 200}

risks:
  audience_objections: ["too expensive vs free", "trust new SaaS"]
  execution_risks:     ["no existing email list >500"]
---
```

## Body (markdown, freeform but workshop-guided)

Sections in this order:

1. **Why now** — the timing argument (1-2 paragraphs)
2. **The one-sentence argument** — the take, not the topic
3. **Messaging pillars** — 3-5 talking points with proof source per pillar
4. **Proof points** — testimonials, case studies, results, social proof
5. **The story arc** — pre-launch → launch → post-launch narrative
6. **Risk notes** — how each frontmatter risk gets mitigated
7. **Drift check** — re-read this brief at the midpoint (suggested date)

## Validation rules

- `slug` MUST be kebab-case, alphanumeric + hyphens only, no spaces
- `slug` MUST match the campaign folder name
- All 16 top-level keys MUST exist (empty values OK: `remarketing: {}`)
- `kpis`, `channels`, `assets` MUST be arrays (may be empty `[]`)
- Dates MUST be ISO 8601 (YYYY-MM-DD)
- `status` MUST be one of: `draft`, `live`, `wrapped`
- `type` in v1 MUST be `launch`

## The 16 required top-level keys

1. campaign_name
2. slug
3. type
4. status
5. created
6. launch_window
7. goal
8. kpis
9. audience
10. offer
11. channels
12. assets
13. claude_stack
14. remarketing
15. budget_usd
16. risks
