# Voice Rules

The non-negotiable filters every CCMB LP draft runs through. Applied across the whole page, not section-by-section. If a sentence violates one of these, rewrite the sentence — don't argue.

---

## 1. Em-dashes — always closed

**Closed style:** `word—word` (no spaces).
**Banned:** `word — word` (spaces).

Why: AI detectors (GPTZero, Originality, Pangram) flag spaced em-dashes as a model fingerprint. They're also harder to read on mobile because they introduce false word breaks. Closed em-dashes are tighter and human.

Exceptions: zero. Even when copying from a source that uses spaced — convert.

---

## 2. The hype kill list

These words and phrases auto-reject. The skill carries the kill list and rewrites sentences that contain them.

### Banned words

- **revolutionize** / **revolutionary** / **revolutionize your [anything]**
- **unleash** (you don't unleash anything, you do it)
- **supercharge** (cliché, no information)
- **transform** (vague — name the actual change)
- **leverage** (verb form — say "use")
- **synergy / synergistic** (corporate noise)
- **seamless / seamlessly** (everyone says this; it's the new "intuitive")
- **best-in-class** (relative to what?)
- **state-of-the-art** (dated; everything is)
- **cutting-edge** (also dated)
- **next-generation** (you mean "newer")
- **scale** (verb form, vague — name the metric being scaled)
- **robust** (means nothing concrete)
- **comprehensive** (always a red flag — it's a hedge)
- **ecosystem** (rarely accurate, almost always overreach)
- **game-changing / game-changer** (cliché, no information)
- **paradigm shift** (kill)
- **bleeding-edge** (kill)
- **disrupting** (kill — also: nobody respects this anymore)
- **harness the power of** (kill on sight)
- **take your [X] to the next level** (cliché)
- **the [adjective] way to** (vague positioning)

### Banned phrases

- "Are you tired of [pain]?" — PAS shortcut, instant cliché
- "Imagine if you could [outcome]" — subjunctive, not concrete
- "It's time to [action]" — moralizing, presumptuous
- "What if I told you..." — content-marketing cliché
- "The truth is..." — implies the rest was lies
- "In today's fast-paced world" — kill instantly
- "More than ever before" — dated and vague
- "Whether you're [X] or [Y]" — soft, hedging opener
- "From [vague X] to [vague Y]" — only works with concrete X and Y, not abstract
- "Tailored to your unique needs" — corporate filler
- "We understand that..." — patronizing
- "Reach out" — meaning "contact us" — soft and corporate

### Rewrite examples

| Banned | Rewrite |
|---|---|
| "Supercharge your workflow" | "Cut 6 hours off your weekly proposals" |
| "Revolutionize how you write" | "Ship a week of content in an hour" |
| "Take your business to the next level" | "Hit your first $10K month" |
| "Seamless integration with your tools" | "Works with Gmail and Notion — no setup" |
| "Comprehensive solution for [audience]" | "The one tool [audience] uses for [specific job]" |

---

## 3. Directness over parallelism

AI patterns load up on **rhythmic parallelism** — three-clause sentences with matched structure. They read smooth but feel synthetic.

### Banned pattern

- "Not just [X], but [Y]." (every model writes this)
- "It's not [X]. It's [Y]. It's [Z]." (triadic cliché)
- "Less [X]. More [Y]." (overused minimalism trick)
- "Faster. Better. Smarter." (three-word lists)
- "Whether you're [audience A] or [audience B], [generic benefit]."

### The fix: directness, not messiness

People sometimes overcorrect by adding sentence fragments, weird punctuation, or stilted phrasing thinking it'll feel "more human." Don't. The fix is **say the thing directly**, not stylize the avoidance.

| Pattern-y | Better (direct) |
|---|---|
| "Not just faster — smarter." | "It's faster. (Also smarter, but the speed is what people notice.)" |
| "Less typing, more shipping." | "You type once. Then you ship." |
| "Whether you're new or experienced, this works." | "Works for total beginners. Also works if you've been doing this for 10 years." |

---

## 4. Concrete over abstract

Every claim should be **quantifiable, named, or specific.**

### Concrete checks

- ❌ "Hundreds of founders" → ✅ "47 founders" or "300+ founders"
- ❌ "Save time" → ✅ "Save 6.4 hours/week"
- ❌ "Many clients" → ✅ "12 paying clients in the first 90 days"
- ❌ "Leading platform" → ✅ "Used by 47 consultancies including [named one]"
- ❌ "Robust analytics" → ✅ "See which page converts and which doesn't"
- ❌ "Easy to use" → ✅ "Setup takes 2 minutes"

### When the number isn't available

If you genuinely don't have a number yet, **don't fabricate.** Cut the claim. A page with one specific number beats a page with five vague ones.

Acceptable hedges:
- "Early users report..."
- "In testing, ..."
- "We're aiming for..."

NOT: "Hundreds of users love it." (vague + unverifiable)

---

## 5. The sign-your-name standard

The load-bearing rule. **Would you sign your name to this page?**

Test for each sentence: Would you paste this into a DM to a friend or post it on your personal LinkedIn? If no, rewrite.

This rule catches:
- Subtle AI patterns the kill list missed
- Hedge phrasing that feels "safer" but sounds corporate
- Over-formal sentences ("We are pleased to announce...")
- Stiff transitions ("Furthermore," "Moreover," "Additionally,")

If you wouldn't say it out loud to a smart friend, kill it.

---

## 6. The "what is this literally" check

Every page section should answer: **what is this literally?**

Hero: literally a [course / tool / download / service]?
Benefits: each item is a literal outcome with a literal mechanism?
CTA: literally tells the reader what they'll get?

Reader's brain processes literal nouns faster than abstract ones.

| Abstract | Literal |
|---|---|
| "A complete solution" | "A 4-week cohort" |
| "An end-to-end platform" | "Three desktop apps" |
| "Your AI workflow companion" | "A skill that runs in Claude Code" |
| "Productivity transformation" | "A daily 20-minute system" |

If a sentence resists being made literal, the underlying thinking is fuzzy. Fix the thinking, not the sentence.

---

## 7. AI-pattern flags to check before shipping

If `ai-hunter-v2` is installed, the skill suggests running it. Without it, run these mental checks:

- **Triadic rhythms** — look for `X, Y, and Z` patterns three times in one section. Break one.
- **Negative parallelism** — `not X, but Y` patterns. Kill all but one (zero is better).
- **Smooth transitions** — "Furthermore," "Additionally," "Moreover," "In essence," "Ultimately." Almost always cut.
- **Hedged claims** — "may," "might," "could potentially," "in some cases." Either commit to the claim or remove it.
- **Em-dash spacing** — search for ` — ` (with spaces). Replace all with `—` (no spaces).
- **Curly quotes** — make sure single and double quotes match the document style. AI output often mixes straight and curly.
- **Title-Case Headlines for Every Item In A List** — gives away AI authorship. Use sentence case for body items and Title Case only for top-level section headlines.

---

## 8. The two-pass write

Best practice for the skill (and humans):

**Pass 1: Get it down.** Write the section per the framework. Don't worry about the kill list. Just get the argument on the page.

**Pass 2: Run the filters.** Em-dashes, kill list, directness, concreteness, sign-your-name. Each pass is a search-and-rewrite, not a re-imagine.

Trying to write filter-clean from the start produces stilted copy. Drafting and filtering produces clean copy that still sounds like you.
