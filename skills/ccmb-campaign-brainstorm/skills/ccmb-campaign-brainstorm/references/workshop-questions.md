# Workshop mode — the full question walk

Used when the student chooses "full workshop" at invocation. The agent walks these in order. Each layer has a checkpoint where the student confirms before proceeding.

## Layer 1 — Strategic Foundation

**Q1: Campaign name.**
> "What are you calling this campaign? (e.g. 'Q3 SaaS Launch', 'Newsletter Relaunch', 'September Cohort Open')."

Capture as `campaign_name`. Derive `slug` (kebab-case, sanitized).

**Q2: Goal (SMART).**
> "What's the outcome you're chasing? Be specific and measurable — '200 paying customers by 2026-07-15' beats 'grow revenue.'"

Apply SMART check on capture:
- Specific: names a thing
- Measurable: has a number
- Achievable: not "$1B in 30 days" — agent flags and asks to revise
- Relevant: ties to a business outcome
- Time-bound: has an end date

If any check fails, agent asks: *"That goal isn't [missing dimension]. Want to revise or proceed anyway?"*

**Q3: KPIs.**
> "What 3-5 numbers tell you whether this campaign is working? For each, name the metric AND the data source."

Capture as `kpis` array. Common pattern:
- paid_signups (source: stripe)
- free_trial_starts (source: app_db)
- lp_conversion_rate (source: vercel_analytics)
- email_subs_added (source: kit_api)
- linkedin_followers_added (source: analytics:check)

**Q4: Audience.**
> "Who exactly is this for? Persona name + rough weekly reachable size + where they hang out online."

Capture as `audience`. If CLAUDE.md has an audience block, smart mode pulls it and asks 1 confirmation question instead.

**Q5: Budget.**
> "Total $ budget for the campaign window. Then split it across channels (ads, tools, contingency). Even '$0 / contingency $0' is a valid answer."

Capture as `budget_usd`.

### Checkpoint 1
Agent restates Layer 1 fields and asks: *"Drift-check: does this feel like a real plan or wishful thinking? Anything to revise?"*

## Layer 2 — Content & Assets

**Q6: Offer.**
> "What exactly are you launching? Name, price, what's included, billing cadence."

Capture as `offer`.

**Q7: Messaging pillars.**
> "Give me 3-5 talking points that the campaign returns to across every asset. For each, one line of claim + one line of proof source."

Capture in body section "Messaging pillars."

**Q8: Hook / one-sentence argument.**
> "If the whole campaign had to fit in one sentence, what would the take be? Not the topic — the take. 'X is the way to Y because Z.'"

If student gives a vague hook ("better X"), agent pushes: *"'Better X' isn't a take. What's the *take*?"*

Capture in body section "The one-sentence argument."

**Q9: Proof points.**
> "What testimonials, case studies, results, or social proof do you have ready to cite? List specifics."

Capture in body section "Proof points." If `research/` folder exists, agent pulls candidates and asks to confirm.

**Q10: Asset checklist.**
> "What assets does this campaign need? Default is: LP, lead magnet, email sequence, social posts. Edit the list — what are you adding, removing, marking as already-existing?"

Capture as `assets` array. Agent suggests owners from installed CCMB skills.

### Checkpoint 2
Agent shows the asset → owner-skill map. Asks: *"Each asset has an owner skill. Anything misrouted?"*

## Layer 3 — Channel Strategy

**Q11: Channel mix + role.**
> "Which platforms? For each, primary / amplifier / long-form-proof. Audience-fit matters — if they live on LinkedIn, don't put TikTok primary."

Capture as `channels` array.

**Q12: Cadence per channel.**
> "Posting rhythm per channel. '1x/day on LinkedIn for 30 days' is more useful than 'often.'"

Capture in `channels[].cadence`.

### Checkpoint 3
Agent shows weekly cadence shape across launch window. Asks: *"Is this sustainable? Be honest."*

## Layer 4 — Execution (Claude-native MarTech)

Run detection FIRST. Show the student what's already installed.

**Q13: Confirm claude_stack.**
> "Detected: [list of MCPs / deps / skills]. Want to use all of these for the campaign? Anything to add or remove?"

Capture as `claude_stack`. For gaps, recommend tier-2 defaults from `martech-native-map.md`.

**Q14: Remarketing (optional).**
> "Want to set up re-engagement segments? E.g., 'visited LP 3+ times, didn't sign up → 4-email objection sequence.' Skip if you're not ready for this yet."

Capture as `remarketing` (or `{}` if skipped).

### Checkpoint 4
Agent shows the full Claude-native MarTech stack. Confirms: *"Anything in the framework that doesn't have a Claude-native or detected equivalent?"*

## Layer 5 — Risk & Mitigation

**Q15: Audience objections.**
> "Top 3 reasons your target persona says no to this offer. Be honest — the brief gets stronger when these are explicit."

If blank, agent draws from `common-risks.md` for the persona type and asks to confirm.

Capture as `risks.audience_objections`.

**Q16: Execution risks.**
> "Top 3 things that could derail the plan from your side. 'No email list yet,' 'Vercel cron not set up,' 'I might get sick week 2' all count."

Capture as `risks.execution_risks`.

### Final checkpoint
Agent renders the full brief preview (frontmatter + body). Asks: *"Save? Edit? Abort?"*
- Save → write `campaigns/<slug>/brief.md`, append to `INDEX.md`, set `status: live`.
- Edit → return to a specific layer to revise.
- Abort → save with `status: draft`, mark missing fields.

## Estimated time

- Workshop mode: 15-20 minutes for a focused student
- Smart mode: 5-8 minutes (skips fields already in context)
