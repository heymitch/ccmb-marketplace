# Smart mode — context detection + question pruning

Smart mode reads existing workspace context BEFORE asking any questions, then asks only what's missing.

## Step 0: Detection sweep (silent)

Run these in parallel, log what's found:

| Source | Pull |
|---|---|
| `CLAUDE.md` (cwd + parents) | Look for `## Voice`, `## Audience`, `## About`, `## Rules` sections. Pull persona, voice rules, business identity. |
| `TASTE.md` | Voice corrections, brand language patterns. |
| `voice/voice-template.md` | If voice-lab was run, full voice profile (archetype mix, vocabulary, sentence patterns). |
| `research/*.md` | Personas, objections, testimonials, audience data. |
| `campaigns/*/brief.md` (other) | Prior briefs for pattern reference + KPI continuity. |
| `.env`, `.env.example` | API keys (`KIT_API_KEY`, `STRIPE_*`, `SUPABASE_URL`, `HUBSPOT_*`, `AYRSHARE_API_KEY`, `OPENAI_API_KEY`, etc.). |
| `package.json` deps | `kit-sdk`, `stripe`, `@supabase/supabase-js`, `hubspot-api-nodejs`, `@notionhq/client`, etc. |
| Claude Code MCP config (~/.claude/mcp.json or project .mcp.json) | Active MCP servers. |
| `~/.claude/plugins/` | Installed CCMB skills + bonus packages. |
| `vercel.json` | Cron config, edge config, etc. |

Output a one-line manifest:

> *"Detected: CLAUDE.md, voice-template.md, Notion + Slack MCPs, Kit OAuth, Vercel Analytics, 13 installed CCMB skills. Skipping questions whose answers are in those."*

Or for blank workspace:

> *"Cold workspace — no CLAUDE.md or context files. Walking you through everything (~10-15 min)."*

## Question pruning table

For each frontmatter field, the agent decides ASK / SUGGEST / AUTO:

| Field | If detected, do | If not detected, do |
|---|---|---|
| campaign_name | n/a | Always ASK (student names it) |
| slug | Always AUTO (derive from name) | Always AUTO |
| type | AUTO `launch` (v1 only) | AUTO `launch` |
| status | AUTO `draft` until checkpoint passes | AUTO `draft` |
| created | AUTO (today's date) | AUTO |
| launch_window / timeline | Suggest dates from "30 days from today" pattern, ASK to confirm | ASK |
| goal | n/a | ASK (apply SMART check) |
| kpis | If prior briefs exist, SUGGEST 3 patterns, ASK to edit | ASK |
| audience | Pull from CLAUDE.md or `research/` if present, ASK 1 confirmation | ASK |
| offer | n/a | ASK |
| channels | Suggest mix from `claude_stack` + audience platforms, ASK to confirm | ASK |
| messaging pillars / hook | n/a | ASK (always — load-bearing creative) |
| assets | SUGGEST default list (LP, magnet, emails, social), ASK to edit | ASK |
| claude_stack | AUTO from detection, ASK to confirm | ASK |
| remarketing | SKIP unless student opts in | SKIP unless asked |
| budget_usd | n/a | ASK |
| risks | ASK once (objections + execution risks together) | ASK once |

## Body sections in smart mode

Smart mode asks the load-bearing creative ones inline:
- **Why now** — ASK
- **One-sentence argument** — ASK (push if vague)
- **Messaging pillars** — ASK
- **Proof points** — pull from `research/*` if present, ASK for additions
- **Story arc** — SKIP unless workshop or student opts in
- **Risk notes** — pull from frontmatter risks, agent drafts mitigation prose, ASK to confirm

## Smart mode estimated time

- Full-context workspace (CLAUDE.md + voice + research): 5-6 questions, ~5 min
- Partial context (CLAUDE.md only): 7-8 questions, ~8 min
- Cold workspace: routed to workshop mode automatically (smart mode would ask everything anyway, so just walk the layers)

## Failover

If smart mode would ask more than 9 questions (because context is too thin), agent says:

> *"You're missing too much for the quick path. Switching to workshop mode — same questions, organized by framework layer with checkpoints."*

Switch transparent — student doesn't have to re-invoke.
