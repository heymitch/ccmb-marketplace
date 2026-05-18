# MarTech → Claude-native mapping (detection-first, three-tier)

## The rule

When filling the `claude_stack` field of a campaign brief, the agent applies this preference order per MarTech category:

```
1. Already installed (detected in MCP config, env, deps, or CCMB plugins)
       → use it. Confirm with student.

2. CCMB-native default (free, exists in CCMB stack)
       → recommend. Suggest install if not present.

3. Paid power-user option
       → mention as alternate, never default. Cite cost.
```

## Detection sources

In order of authority:

| Source | What to check |
|---|---|
| Claude Code MCP config | active MCP servers (Notion, Slack, Gmail, Supabase, HubSpot, Airtable, Linear, etc.) |
| `.env` / `.env.example` | API keys: `OPENAI_API_KEY`, `KIT_API_KEY`, `STRIPE_*`, `SUPABASE_URL`, `HUBSPOT_*`, `AYRSHARE_API_KEY`, etc. |
| `package.json` deps | `kit-sdk`, `stripe`, `@supabase/supabase-js`, `hubspot-api-nodejs`, `@notionhq/client`, etc. |
| `~/.claude/plugins/` | installed CCMB skills + bonus packages |
| Existing project files | `vercel.json` cron config, `kit.config.js`, `supabase/` dir, etc. |

## The category table

| Category | 1. Detect first (use if present) | 2. CCMB-native default | 3. Paid power-user option |
|---|---|---|---|
| CRM | HubSpot MCP, Airtable MCP, Notion MCP, Supabase | Notion MCP + light contact skill | HubSpot paid, Salesforce |
| Email automation | Kit/ConvertKit OAuth, Resend, Postmark | Kit (CCMB S5 default) | Mailchimp paid, ActiveCampaign |
| Analytics | Vercel Analytics, GA4, Plausible | Vercel Analytics + `/analytics:check` | Mixpanel, Amplitude paid |
| Social scheduling | Ayrshare config | Generate via `/content:*`, post manually | Ayrshare (cost: $29-149/mo), Buffer, Hootsuite |
| Database | Supabase, Postgres, Airtable | Supabase free tier | Supabase Pro, Planetscale |
| Cron / scheduling | Vercel Cron config | Vercel Cron (existing CCMB pattern) | Inngest, Trigger.dev paid |
| A/B testing | Vercel Edge Config | Vercel Edge Config + flag skill | Optimizely, VWO paid |
| Customer support | Gmail MCP, Slack MCP, Helpscout | Gmail MCP + triage skill | Intercom, Helpscout paid |
| AI / content | OpenAI, Anthropic SDK, existing voice-lab | Claude Code + existing CCMB skills | OpenAI paid, Jasper, Copy.ai |
| File storage | Vercel Blob, S3, Supabase Storage | Vercel Blob | S3 paid tier, Cloudflare R2 |

## Anti-defaults (never propose first)

- Ayrshare — only if detected or student explicitly asks for full automation. Cite cost ($29/mo entry).
- HubSpot paid tiers — only if student is already a HubSpot customer or asks.
- Mailchimp / ActiveCampaign / ConvertKit paid — only if detected.
- Zapier / Make — Claude Code + MCPs replace most of this; mention only if a specific gap exists.

## How the agent uses this

During Layer 4 questions, for each MarTech category the framework calls for:

1. Run detection. Surface what's already installed.
2. If anything detected → confirm with student, write to `claude_stack`.
3. If nothing detected → recommend tier 2 default with a one-line install hint.
4. Only mention tier 3 if student asks "what about [paid tool]?" — answer honestly with cost note.

## Student-facing examples

**Detected:**
> *"Detected Notion MCP + Supabase. I'll use Notion as the CRM and Supabase for campaign data."*

**Default fallback:**
> *"No CRM detected. Recommending Notion MCP (free tier, ~10 min to wire). Want to use that or skip CRM for this campaign?"*

**Tier 3 only on request:**
> *"You asked about Ayrshare for social scheduling — it's $29/mo entry tier and worth it if you want full automation across 10 platforms. The CCMB default is to generate copy with `/content:*` skills and post manually, which is free but takes 15 min/week. Which fits the campaign?"*
