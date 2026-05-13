# Waterfall Playbooks

Each playbook = ICP shape → ordered list of public sources to consult. Skill picks one playbook per run based on ICP keywords; sources run in order until enough signals are matched OR per-row timeout fires.

**Universal rule:** every playbook starts with the cheapest/fastest source and escalates. No playbook ever scrapes LinkedIn directly — when an LI URL is encountered, it's noted in the output CSV but not crawled.

---

## Playbook 1 — `developer-founder`

**Triggers when ICP mentions:** developer, technical founder, engineer, CTO, open-source, indie hacker, builds in public, ships products, technical, CLI, API, GitHub.

**Source order:**

1. **GitHub Public API** (`api.github.com/users/{username}`)
   - **Try to resolve username from:** the row's email handle (`@username` part), the row's URL if github.com, OR WebSearch for "{name} {company} github"
   - **Returns:** bio, company self-reported, blog URL, twitter handle, public repo count, recent activity dates, follower count
   - **Signal weight:** highest — if found, this row is high-confidence

2. **Personal blog / domain** (WebFetch)
   - **Try to resolve from:** GitHub `blog` field if found above, OR WebSearch for "{name} blog"
   - **Returns:** about page text, technologies discussed, voice/style indicators
   - **Signal weight:** medium — confirms identity + intent signals

3. **Twitter/X profile** (WebSearch + WebFetch)
   - **Try to resolve from:** GitHub `twitter_username` field if found above, OR WebSearch for "{name} twitter"
   - **Returns:** bio, follower count if scrapeable from public profile page, pinned tweet content
   - **Signal weight:** medium — bio is high-signal, follower count often spoofed

4. **HN / Reddit mentions** (WebSearch)
   - **Searches:** `"{name}" site:news.ycombinator.com`, `"{name}" site:reddit.com`
   - **Returns:** which technical communities they participate in, what they post about
   - **Signal weight:** low-medium — confirms domain expertise depth

5. **WebSearch generic fallback** (broad query)
   - **Last resort:** `"{name}" "{company}"` to catch anything missed
   - **Returns:** misc public mentions, podcast appearances, conference talks

---

## Playbook 2 — `b2b-saas-founder`

**Triggers when ICP mentions:** SaaS, B2B software, post-PMF, recurring revenue, MRR, ARR, founder+product, software company, ICP-driven.

**Source order:**

1. **Company About page** (WebFetch)
   - **Try to resolve from:** the row's company URL field, OR `{company}.com/about`, `{company}.io/about`, OR WebSearch "{company} about"
   - **Returns:** team list, founder bios, headcount signals, funding mentions, product positioning
   - **Signal weight:** highest — most B2B SaaS founders have curated About pages

2. **Crunchbase public profile** (WebFetch)
   - **Try:** `crunchbase.com/organization/{company-slug}` (public-tier data only — no API key needed for the public landing)
   - **Returns:** funding stage, founding year, public investor names, headcount band
   - **Signal weight:** high — fundamental firmographic data

3. **Company blog + recent posts** (WebFetch)
   - **Try:** `{company}.com/blog`, `{company}.io/blog`
   - **Returns:** what they write about (proxy for what they care about), update frequency, voice
   - **Signal weight:** medium — reveals current company priorities

4. **Podcast appearance search** (WebSearch)
   - **Searches:** `"{name}" "{company}" podcast`, `"{name}" interview`
   - **Returns:** podcast guest spots = strong signal for founder profile + recent topics they discussed
   - **Signal weight:** medium-high — podcast guests have curated public-facing narratives

5. **LinkedIn URL note** (no scrape)
   - **Try to resolve from:** WebSearch "{name} {company} linkedin"
   - **Returns:** URL only, written to `public_urls` field. Student can click through manually.
   - **Signal weight:** none for scoring — just a click-through aid

6. **Twitter/X profile** (WebSearch + WebFetch)
   - **As in playbook 1**, but lower priority for B2B SaaS founders (many are LI-primary, X-secondary)

---

## Playbook 3 — `creator-thought-leader`

**Triggers when ICP mentions:** creator, audience, newsletter, course creator, YouTube, podcast host, writer, content, audience-first, indie creator.

**Source order:**

1. **Personal site / newsletter landing page** (WebFetch)
   - **Try:** `{name}.com`, `{name-slug}.substack.com`, `{name}.beehiiv.com`, OR WebSearch "{name} newsletter"
   - **Returns:** their pitch, audience size if listed, what they cover, recent essays
   - **Signal weight:** highest — creators curate this surface

2. **YouTube Data API** (student-supplied key, free tier)
   - **Try:** channel handle lookup, channel ID resolution from search
   - **Returns:** subscriber count, total views, recent uploads, channel description
   - **Signal weight:** high — quantifies audience reach
   - **Setup:** student needs to add `YOUTUBE_API_KEY` env var. Free tier (10K req/day) is plenty for cohort scale.

3. **Twitter/X profile** (WebSearch + WebFetch)
   - **Why high here:** for creators, X bio is the canonical self-positioning
   - **Returns:** bio, follower count signal, pinned tweet, recent activity proxy
   - **Signal weight:** high

4. **Podcast appearances** (WebSearch)
   - **Search:** `"{name}" guest podcast`, `"{name}" interview {year}`
   - **Returns:** which shows they appear on, topics they discuss
   - **Signal weight:** medium — confirms audience tier (who books them)

5. **RSS feed of their newsletter** (if discoverable)
   - **Try:** common RSS paths from the substack/beehiiv URL
   - **Returns:** post titles + intros, publishing frequency
   - **Signal weight:** medium — confirms cadence + current themes

---

## Playbook 4 — `service-provider-consultant`

**Triggers when ICP mentions:** consultant, freelancer, agency, services, fractional, advisor, contractor, service provider, solo, productized service.

**Source order:**

1. **Personal site / portfolio** (WebFetch)
   - **Try:** `{name}.com`, `{name-slug}.com`, OR WebSearch "{name} consulting"
   - **Returns:** services offered, case studies, pricing if listed, testimonials
   - **Signal weight:** highest — service providers depend on this surface

2. **Testimonials / case studies page** (WebFetch)
   - **Try:** `{their-domain}/case-studies`, `/testimonials`, `/clients`, `/work`
   - **Returns:** named clients = strongest possible firmographic signal for service businesses
   - **Signal weight:** very high

3. **Twitter/X profile** (WebSearch + WebFetch)
   - **Returns:** how they position themselves to peers + prospects
   - **Signal weight:** medium-high

4. **LinkedIn URL note** (no scrape)
   - **Try:** WebSearch "{name} linkedin consultant"
   - **Returns:** URL for manual review
   - **Signal weight:** none for scoring

5. **WebSearch for recent work** (broad)
   - **Search:** `"{name}" project case study`, `"{name}" client work`
   - **Returns:** mentions of specific client engagements
   - **Signal weight:** medium

---

## Playbook 5 — `generic-fallback`

**Triggers when:** no other playbook matches with ≥2 keyword hits, OR the user explicitly requests `generic`.

**Source order:**

1. **WebSearch broad** (just the name + company)
   - **Query:** `"{name}" "{company}"`
   - **Returns:** search snippets, social URLs, public mentions
   - **Signal weight:** depends — read what came back, escalate accordingly

2. **First-result page** (WebFetch on top result)
   - **Returns:** whatever the most-visible public page about this person contains
   - **Signal weight:** variable

3. **Social profile discovery** (WebSearch)
   - **Search:** `"{name}" twitter OR github OR youtube`
   - **Returns:** social URLs for further enrichment via playbook-specific paths
   - **Signal weight:** routing — once a strong social profile is found, switch to that playbook

4. **Company About** (WebFetch)
   - **Try:** `{company}.com/about` regardless of company type
   - **Returns:** generic firmographics
   - **Signal weight:** low-medium

5. **WebSearch refined** (with one extra term)
   - **Query:** `"{name}" "{company}" {top-icp-keyword}`
   - **Returns:** narrower mentions
   - **Signal weight:** depends

---

## Custom playbooks (power users)

Drop a markdown file at `~/.ccmb-lp/playbooks/[name].md` with the same structure:

```markdown
# Playbook — [name]

**Triggers when ICP mentions:** [keyword1, keyword2, ...]

**Source order:**

1. **[Source name]** ([mechanism])
   - **Try:** [how to find the lookup target]
   - **Returns:** [what data shape]
   - **Signal weight:** [high/medium/low]

[etc.]
```

Skill reads user playbooks FIRST, falls back to bundled defaults. Triggers match against ICP keywords case-insensitively; the first playbook with ≥2 keyword hits wins.

---

## When to write a new playbook vs use generic-fallback

| Situation | Recommendation |
|---|---|
| You have a niche ICP that doesn't match any default | Write a custom playbook |
| Your ICP is unusual but broad (e.g., "people who attended X conference") | Use generic-fallback with strong WebSearch queries |
| You ran enrichment and got too many "low confidence" rows | Probably wrong playbook; manually switch or write a custom one |
| You're enriching the same ICP shape monthly | Custom playbook saves you re-running the picker each time |

The playbook is the cheapest part of the skill to customize. Write three playbooks for your three offers, swap them as you pivot. Same skill, same engine, different output per offer.
