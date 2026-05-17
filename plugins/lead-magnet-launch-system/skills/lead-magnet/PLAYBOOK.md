# Lead Magnet Launch System — Canonical Playbook

The methodology, formulas, and exact prompts. This is the source of truth the
skill executes. Prompts are verbatim — keep them intact; only fill brackets.

---

## The three traits + the formula

A lead magnet is a free resource someone gets in exchange for their email. The
best ones are:

1. **Specific** — solves one narrow problem, not "everything about X."
2. **Quick to consume** — checklist/template/short guide, not a 47-page ebook.
3. **Immediately useful** — reader can *do something* within 10 minutes.

**The formula:** Help **[specific person]** achieve **[specific outcome]** in
**[specific timeframe]** using **[specific format]**.

Examples:
- "The 5-Minute SEO Audit Checklist for Solopreneurs"
- "The Cold Email Template That Booked 14 Meetings in 30 Days"
- "7 Substack Note Templates You Can Steal Today"

Formats that work: checklists, templates, swipe files, cheat sheets, short
guides (<2,000 words), spreadsheets, resource lists, scripts, frameworks.
Formats that don't: long ebooks, video courses, vague "ultimate guides."

Interactive **free tools** (quiz/calculator/assessment) are a high-converting
format but they're handled by a **separate skill** — not this one. If the
chosen idea is a free tool, name it and route there.

---

## §1 — Idea generation prompt (Step 1)

```
I write about [YOUR TOPIC] for [YOUR AUDIENCE].

My audience's biggest frustrations are:
- [FRUSTRATION 1]
- [FRUSTRATION 2]
- [FRUSTRATION 3]

Generate 10 lead magnet ideas that:
- Solve ONE specific problem from the list above
- Can be consumed in under 10 minutes
- Give the reader something they can USE immediately (not just read)
- Follow this format: [Format type]: [Specific title]

For each idea, include:
- The exact problem it solves
- Why someone would trade their email for it
- How long it would take me to create
```

Recommend the top 3. Bias toward the category whose build path the project can
actually ship (see SKILL.md category table).

---

## §2 — Naming (Step 2)

Generate 8–12 names. A good name implies the **outcome** and the **format**,
and is specific enough that the reader knows in one read whether it's for them.
Test each against the formula. Pick one; log it in the Launch Brief.

---

## §3 — Content draft + landing page copy (Steps 4 & 8)

**Content draft prompt (Step 8 asset):**

```
I'm creating a lead magnet called "[YOUR TITLE]" for [YOUR AUDIENCE].

The specific problem it solves: [PROBLEM]
The format: [checklist / template / guide / etc.]

Draft the complete content for this lead magnet. Follow these rules:
- Be specific and actionable — no filler
- Use plain language, not corporate jargon
- Every section should give the reader something to DO
- Keep the total length under [WORD COUNT] words
- End with a call-to-action to subscribe to my newsletter [NEWSLETTER NAME] at [URL]
```

Asset design rules: clean formatting > graphics; put name + newsletter + URL on
page 1; last-page CTA = "If you found this useful, share [newsletter link]."

**Landing page copy formula (Step 4):**

```
Headline: Get [Specific Resource] That Helps [Audience] [Achieve Outcome]
Subheadline: [What it is] — delivered to your inbox in [timeframe].

What's inside:
- [Specific thing #1 they'll get]
- [Specific thing #2 they'll get]
- [Specific thing #3 they'll get]

[FORM]

Who this is for:
This is for [specific person] who [specific situation]. If you've been
[struggling with X], this will [specific benefit].
```

Above the fold = headline + subheadline. Below = 3–5 what's-inside bullets,
who-it's-for, social proof if any.

---

## §4 — Onboarding sequence (Step 6)

5-email Kit sequence:

| Email | Timing | Purpose |
|---|---|---|
| 1 | Immediately | Deliver the lead magnet |
| 2 | Day 2 | A quick win on the topic |
| 3 | Day 4 | Your story — why you care |
| 4 | Day 7 | Your best content on the topic |
| 5 | Day 10 | Invite the next step (paid / community) |

Delivery email 1 template:

```
Subject: Here's your [LEAD MAGNET NAME]

Hey!

As promised, here's [LEAD MAGNET NAME]: [LINK TO ASSET]

Here's how to get the most out of it:
1. [Quick tip]
2. [Second tip]
3. [Third tip]

I'll be sending more [topic] tips over the coming weeks. If there's something
specific you're working on, reply and tell me — I read every response.

[Your name]

P.S. If you found this useful, share with a friend: [LANDING PAGE LINK]
```

---

## §5 — Promotional emails (Step 7)

These also reformat into X threads / LinkedIn / Substack Notes.

**Email 1 — Announcement (launch day):**
```
Subject: I made you something

Hey — I just put together [LEAD MAGNET NAME].
It's a [format] that helps you [specific outcome].

Here's what's inside:
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

I made it because [reason — story / common question / gap you noticed].

Grab it here: [LANDING PAGE LINK]

[Your name]
```

**Email 2 — Reminder (2–3 days later):** subject "Did you grab this yet?",
one compelling line + one result/problem line + link.

**Email 3 — Social proof (5–7 days, optional):** subject "[X] people
downloaded this — here's why", download count + 2 quotes + link.

---

## §6 — Kit (ConvertKit) setup — canonical platform

**Landing page:** Grow → Landing Pages & Forms → + Create New → Landing Page →
simple template → build per §3 formula → Settings: custom URL → Publish.

**Automation (delivery):** Automate → Visual Automations → + New Automation →
trigger **Subscribes to a form** (the form from the landing page) → action
**Send email sequence** (or single Send email = §4 email 1).

**Sequence:** Send → Sequences → + New Sequence → add the 5 emails with the §4
timing → back in the Visual Automation, add **Send email sequence** → select it.

**Adapter — Substack / other:** if the repo already wires a provider (Disciple
AI = Substack `?nojs=true`), keep it. Same fire-and-redirect pattern
(PATTERNS.md §2), swap `action` + hidden fields. The landing page may be a
code-native page in the repo rather than a Kit-hosted page — wire the form to
the provider endpoint and redirect to the asset.

---

## §7 — The 4 evergreen promotion surfaces (post-launch)

The funnel is inert until promoted. Place the offer on all four:

1. **Welcome email** — highest leverage; every new subscriber sees it once at
   peak engagement. One clear CTA to the landing page.
2. **Email preamble** — a short block atop every send. Catches everyone who
   missed/forgot the welcome email.
3. **About page** — a natural mention + link.
4. **Recurring social PS** — "If you haven't grabbed [thing] yet, it's here."

---

## Resume

If a session ends mid-build, output the Launch Brief and tell the user to
paste it into the next session. The skill reconstructs state from it and
continues at "Next step."
