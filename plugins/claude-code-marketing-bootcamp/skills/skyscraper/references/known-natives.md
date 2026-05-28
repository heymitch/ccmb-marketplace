# known-natives.md — curated seed corpus

docs-scout consults this BEFORE going live. Three buckets:

1. **Platform primitives** — Claude Code itself
2. **CCMB / speakeasy skills already shipped** — "you already own this"
3. **External canon** — top-tier marketplaces, actors, libraries

Entries are YAML for easy parsing by docs-scout. Filter by intersecting
`domains` with the user's `domain_keywords`.

---

## bucket_1_platform_primitives

```yaml
- name: Skills
  capability: Custom workflows
  docs_url: https://docs.claude.com/en/docs/claude-code/skills
  tier: native
  domains: [workflow, skill, plugin]

- name: Plugins
  capability: Multi-skill bundles
  docs_url: https://docs.claude.com/en/docs/claude-code/plugins
  tier: native
  domains: [plugin, bundle]

- name: Slash commands
  capability: Trigger workflows by typing /name
  docs_url: https://docs.claude.com/en/docs/claude-code/slash-commands
  tier: native
  domains: [command, ux, trigger]

- name: Hooks
  capability: Auto-triggered behavior on events (UserPromptSubmit, etc.)
  docs_url: https://docs.claude.com/en/docs/claude-code/hooks
  tier: native
  domains: [hook, automation, event, trigger]

- name: Subagents
  capability: Parallel work via Task/Agent tool
  docs_url: https://docs.claude.com/en/docs/claude-code/subagents
  tier: native
  domains: [parallel, agent, dispatch, orchestrator]

- name: MCP servers
  capability: External API access via Model Context Protocol
  docs_url: https://docs.claude.com/en/docs/claude-code/mcp
  tier: native
  domains: [api, integration, external, mcp]

- name: WebFetch / WebSearch
  capability: Built-in web fetch and search tools
  docs_url: https://docs.claude.com/en/docs/claude-code/settings
  tier: native
  domains: [web, search, fetch, scrape]
```

## bucket_2_ccmb_speakeasy_skills

```yaml
# CCMB utility plugins (the original 4)
- name: ai-hunter
  what: Content quality gate / lead qualification
  domains: [content, quality, lead-qualification, ai-detection]
  tier: native
  notes: "Installed CCMB plugin. Use for S2 magnet topics, S4 lead qualification."

- name: headline-writer
  what: Hooks, subject lines, hero copy
  domains: [copy, hook, headline, subject-line, email]
  tier: native
  notes: "Installed CCMB plugin. Use S1-S5."

- name: sentence-editor
  what: Copy polish across shipping surfaces
  domains: [copy, edit, polish, writing]
  tier: native
  notes: "Installed CCMB plugin."

- name: morning-kickstart
  what: Daily pre-work ritual
  domains: [ritual, focus, morning, productivity]
  tier: native
  notes: "Standalone CCMB plugin."

# Email sequences
- name: email-sequences-core
  what: Build complete email sequences (onboarding, cart, launch, objection)
  domains: [email, sequence, drip, nurture, launch, onboarding]
  tier: native
  notes: "Front-door sequence builder."

- name: email-sequences-library
  what: Atomic email-by-email library
  domains: [email, welcome, cart, launch, post-purchase]
  tier: native

# Codification + taste
- name: codify-taste
  what: Scan chat, extract corrections, structured TASTE.md
  domains: [extraction, structured-output, feedback, taste]
  tier: native

# Quality pipeline
- name: quality:audit-ai-detection
  what: Grade content for AI-detection patterns
  domains: [content, ai-detection, quality, grading]
  tier: native

- name: quality:surgical-rewrite
  what: Rewrite flagged sentences only, preserve 90%+
  domains: [content, rewrite, polish, ai-detection]
  tier: native

- name: quality:fix-ai-patterns
  what: Apply surgical fixes to remove AI patterns
  domains: [content, ai-detection, rewrite]
  tier: native

- name: quality:full-pipeline
  what: Complete quality pipeline with parallel detection
  domains: [content, ai-detection, pipeline]
  tier: native

# Content family
- name: content:generate-carousel
  what: LinkedIn carousel via Gamma API
  domains: [linkedin, carousel, visual, design]
  tier: native

- name: content:generate-linkedin
  what: Thought leadership LinkedIn post (≤2800 chars)
  domains: [linkedin, post, longform, thought-leadership]
  tier: native

- name: content:generate-twitter-thread
  what: 5-12 connected Twitter/X posts
  domains: [twitter, thread, x]
  tier: native

- name: content:generate-twitter
  what: Single Twitter/X posts (≤280)
  domains: [twitter, x, short-form]
  tier: native

- name: content:generate-video-short
  what: 30-90s video script (TikTok, Reels, Shorts, LinkedIn)
  domains: [video, short, tiktok, reels, shorts]
  tier: native

- name: content:generate-email-value
  what: Value-building email (400-500 words)
  domains: [email, value, nurture]
  tier: native

- name: content:generate-meme
  what: Meme generation
  domains: [meme, visual, social]
  tier: native

- name: content:generate-image
  what: Single image for social posts
  domains: [image, visual, social]
  tier: native

# Workflow / channels
- name: dev-browser
  what: Browser automation (use Chrome mode for logged-in sessions)
  domains: [browser, scrape, automation, web, linkedin]
  tier: native
  notes: "Use --chrome 9223 for logged-in sessions."

- name: frontend-design
  what: Distinctive production-grade frontend interfaces
  domains: [frontend, ui, design, react, web]
  tier: native

- name: canvas-design
  what: Beautiful PNG/PDF designs (posters, art)
  domains: [design, poster, visual, art, print]
  tier: native

- name: figma-to-vercel
  what: Production landing pages from Figma -> Vercel
  domains: [figma, landing-page, vercel, deploy, web]
  tier: native

- name: superpowers:dispatching-parallel-agents
  what: Pattern for fan-out sub-agent work
  domains: [parallel, agent, orchestrator, fan-out]
  tier: native

# Slack
- name: slack:slack-messaging
  what: Compose well-formatted Slack messages with mrkdwn
  domains: [slack, messaging, internal-comms]
  tier: native

# Analytics + ops
- name: analytics:check
  what: Check analytics spikes across platforms (LinkedIn Shield, Twitter, etc.)
  domains: [analytics, linkedin, twitter, dashboard]
  tier: native
```

## bucket_3_external_canon

```yaml
marketplaces:
  - name: claudeskills.com
    url: https://claudeskills.com
    tier: sanctioned
    what: Curated index of Claude Code skills
    domains: [skill, marketplace, claude-code]

  - name: Apify Store
    url: https://apify.com/store
    tier: sanctioned
    what: Browse 1000s of pre-built actors
    domains: [scrape, automation, marketplace]

apify_actors:
  - name: Reddit Scraper Lite
    url: https://apify.com/trudax/reddit-scraper-lite
    tier: sanctioned
    domains: [reddit, scraping, lead-gen, market-research]
    what: Scrapes Reddit posts/comments without auth
    clone_difficulty: low
    notes: "Free tier ~5k rows/run. Used as reddit-scout backend."

  - name: YouTube Transcript Scraper
    url: https://apify.com/pintostudio/youtube-transcript-scraper
    tier: sanctioned
    domains: [youtube, transcript, video]
    what: Pulls transcripts from YouTube videos
    notes: "Used as youtube-scout backend."

  - name: LinkedIn Profile Scraper
    url: https://apify.com/dev_fusion/linkedin-profile-scraper
    tier: sanctioned
    domains: [linkedin, scrape, profile, lead-gen]

  - name: Twitter Scraper
    url: https://apify.com/apidojo/twitter-scraper-lite
    tier: sanctioned
    domains: [twitter, x, scrape, social]

  - name: Google Search Results Scraper
    url: https://apify.com/apify/google-search-scraper
    tier: sanctioned
    domains: [google, search, seo, serp]

  - name: Instagram Hashtag Scraper
    url: https://apify.com/apify/instagram-hashtag-scraper
    tier: sanctioned
    domains: [instagram, hashtag, scrape, social]

open_source_canon:
  - name: yt-dlp
    url: https://github.com/yt-dlp/yt-dlp
    tier: sanctioned
    domains: [youtube, download, transcript, video]

  - name: playwright
    url: https://playwright.dev
    tier: sanctioned
    domains: [browser, automation, scrape, test]

  - name: puppeteer
    url: https://pptr.dev
    tier: sanctioned
    domains: [browser, automation, scrape]

  - name: Browserless
    url: https://browserless.io
    tier: sanctioned
    domains: [browser, cloud, scrape]

  - name: Firecrawl
    url: https://firecrawl.dev
    tier: sanctioned
    domains: [scrape, crawl, web]

  - name: Crawl4AI
    url: https://github.com/unclecode/crawl4ai
    tier: sanctioned
    domains: [scrape, crawl, llm]

  - name: Bright Data
    url: https://brightdata.com
    tier: sanctioned
    domains: [proxy, scrape, residential]

  - name: ScraperAPI
    url: https://scraperapi.com
    tier: sanctioned
    domains: [scrape, proxy, api]
```
