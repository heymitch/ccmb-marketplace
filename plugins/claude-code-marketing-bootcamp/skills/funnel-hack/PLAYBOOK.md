# PLAYBOOK.md — Dispatch & Synthesize

Operational detail for Steps 2–7. Read before dispatching agents.

---

## Step 2 — Parallel-agent dispatch contracts

Dispatch **all four agents in a single message** so they run concurrently. Each writes ONE file to the run's output dir (`<workspace>/competitor-intel/<target-slug>/`) and returns only a 2–4 sentence summary. Fill the bracketed slots. Tell every agent: public data only, cite source URLs inline, label estimates `(est.)`, and self-validate (file exists + non-empty via `wc -l`, required sections present) before returning.

Common header to prepend to each contract:

```
Target: [NAME] — [one-line: what they do, known handles, primary offer].
Known footprint so far: [paste anything from SCOPE: subs, handles, offer names].
Rules: public data only; cite URLs inline; label estimates "(est.)"; distinguish
measured numbers from estimates. Write your report to:
[OUTPUT_DIR]/[FILENAME]. Self-validate before returning. Return ONLY a short
summary — do NOT paste the report.
```

### Arm 1 — Traffic Engine → `01-engine.md`

```
You are doing a teardown of [NAME]'s primary traffic engine (usually their
biggest platform — YouTube, a newsletter, IG, TikTok, X). Identify the ONE
platform doing most of the attention work, then dissect it.

If the engine is YouTube and a transcript/scrape tool or `research:youtube`
command exists in this workspace, use it to deepen topic + CTA analysis;
otherwise use WebSearch/WebFetch on the channel's /videos and /about pages,
Social Blade, and review sites.

Report sections (specifics, not vibes):
1. Channel/account stats — followers/subs, total views, post count, start date.
2. Posting cadence — posts per week/month, derived from actual dated posts. Show the math.
3. Topic analysis — cluster their content into 5-8 themes with rough % + example titles; note which topics get the most engagement (their proven winners). Flag if they've recently PIVOTED topics.
4. Hook & title patterns — recurring formulas; quote 5+ real examples.
5. CTAs — what they tell the audience to DO; where they send traffic (the funnel entry). Quote the actual CTA language.
6. What's working — 3-5 most replicable tactics.
Write to [OUTPUT_DIR]/01-engine.md.
```

### Arm 2 — Offer Ladder + Funnel → `02-offer-funnel.md`

```
You are reverse-engineering [NAME]'s OFFER LADDER and FUNNEL. Public data only;
label estimates "(est.)"; show arithmetic.

Research (WebSearch/WebFetch): their site, pricing pages, any community
(Skool/Circle/Discord/Patreon) about pages, sales/checkout pages, and
third-party review sites (these often expose pricing + member counts).

Report sections:
1. The offer ladder — every rung from free → highest ticket. For each: name, price, what's included, the promise/transformation, who it's for. Include any agency/DFY/high-ticket offer even if it sits beside the ladder rather than on it.
2. The funnel map — trace traffic source → free capture → nurture → paid conversion → high-ticket. Where do they capture email? What's the bridge from free to paid (tripwire, webinar, live call, community FOMO)?
3. Conversion estimates — do the math from public numbers (audience → free members → paid). State assumptions. Give low/mid/high ranges for paid members and revenue. Label everything (est.).
4. Pricing psychology & mechanics — anchoring, urgency, guarantees, credibility hooks, how the free tier is engineered to convert.
5. Strengths & vulnerabilities — what's strong + where the gaps are that a competitor could exploit.
Write to [OUTPUT_DIR]/02-offer-funnel.md.
```

### Arm 3 — Cross-Platform Footprint → `03-platforms.md`

```
You are mapping every platform [NAME] publishes on BESIDES their main engine,
and how each feeds the funnel. Public data only; label estimates "(est.)".

For EACH platform (Instagram, X/Twitter, LinkedIn, TikTok, YouTube/Shorts,
newsletter/email, their website, podcast/guest appearances, plus any niche
platform): handle/URL, follower count, content type, cadence (est.), and its
funnel role. Also find the single link-in-bio destination most bios point to.

Report sections:
1. Platform-by-platform table — Platform | Handle/URL | Followers | Content type | Cadence (est.) | Funnel role. Include a row even for platforms they're NOT on (mark "not found / inactive").
2. Cross-promotion mechanics — how platforms reinforce each other and funnel toward the capture point. The repeatable cross-post pattern.
3. Lead capture surfaces — every place they capture an email/signup, ranked by likely volume.
4. Gaps — platforms they're absent from or underusing (competitor opportunity).
Write to [OUTPUT_DIR]/03-platforms.md.
```

### Arm 4 — Growth Velocity → `04-velocity.md` (the hard, high-value arm)

```
You are measuring GROWTH VELOCITY (flow rates, NOT totals) for [NAME]'s funnel.
"How many people sign up per month" is the headline question. Public data only;
label every estimate "(est.)" and SHOW your arithmetic.

Methods:
- Sub/follower velocity: Social Blade (socialblade.com) or SocialCounts —
  followers gained per month + trend (accelerating/flat/declining). If Social
  Blade 403s, use SocialCounts or diff dated third-party mentions.
- Community signups/month (the key number): use the Wayback Machine
  (web.archive.org) to pull snapshots of their community/about page at multiple
  past dates; diff the member counts → members added per month. Show the
  snapshot DATES + counts + the math. For Skool, the page JSON often contains a
  `totalMembers` field in archived snapshots.
- Paid velocity: hardest. Look for review-site mentions of member growth, or
  estimate from free-growth × assumed conversion. Label heavily (est.).

Report sections:
1. Velocity dashboard — table: Channel | Current total | Net adds/month (est.) | Trend (↑/→/↓) | Source.
2. Free/community signup rate — the Wayback diff math with dated snapshots and the computed monthly rate (or an explicit statement that no usable snapshots existed and what you tried).
3. Engine rate — subs/followers per month, posts/month, on the main platform.
4. Paid conversion velocity — est. paid signups/month + MRR added/month, assumptions stated.
5. Trajectory — 6-12 month projection at current rates; is the engine compounding or saturating?
Write to [OUTPUT_DIR]/04-velocity.md.
```

---

## Steps 4–6 — Reconcile & Synthesize

**Reconcile (Step 4).** Agents pull different snapshots; numbers will disagree. Don't pick one — present the range as honest error bars (e.g. "subs ~595K–765K"). Re-derive revenue from the velocity arm's paid numbers, not just the offer arm's, and flag when the two disagree (that disagreement is often the most interesting finding — e.g. a saturating paid tier under a compounding free tier means revenue has migrated off the self-serve ladder).

**Synthesize FUNNEL-HACK.md (Step 5)** and **ADAPT-TO-<brand>.md (Step 6)** using `REPORT-TEMPLATE.md`. The master report links to the four arm files rather than duplicating them (source-of-truth). The adaptation playbook is where brand judgment lives — every "steal" and "differentiate" point must trace to a real mechanic in the arms AND to the operator's Step-0 config. Write content-idea hooks in the operator's voice (honor their banned-words list if the config has one) so they're draft-grade.

## Anti-patterns

- Don't dispatch the arms serially. One message, four agents.
- Don't let the velocity arm get dropped because it's harder — it's the arm that makes the report actionable.
- Don't write the adaptation playbook without having read the Step-0 brand config.
- Don't `cat` agent transcript files. Trust summaries; verify the output file on disk.
