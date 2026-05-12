# Vibe Editing — The CCMB Cheat Sheet

The cross-cutting reference linked from every session's runbook. Every CCMB session generates a piece of your site; this is how you edit what got generated without burning a weekend of tokens. It's not a tutorial on Claude Code. It's not a style guide. It's the loop—prompt shape, when to one-shot, when to iterate, and how to make every edit you make today an edit you never have to make again.

Read it once front-to-back. After that, jump to the section you need.

---

## 1. The thesis

Every site CCMB ships is generated. Generation gets you 80% there. The remaining 20% is taste—and taste is a series of edits.

Done wrong, that 20% costs more tokens than the original generation. Done right, every edit you make is one fewer edit you'll ever make again on any project.

So here's the pitch. Every edit is a data point. Every recurring edit is a signal. The codify loop (§6) is what turns those signals into skills, so the next site is born knowing what this one had to be taught.

You're not getting better at editing. You're getting better at *not needing to edit.*

The point of getting good at editing is to need it less.

---

## 2. The anatomy of a vibe-edit prompt

Four slots. Skip any one and the model freelances.

```
POINT      — name the component, file, or section
CHANGE     — describe the state change (from → to)
CONSTRAINT — what NOT to touch
REFERENCE  — visual or prior-state anchor (screenshot, commit, link)
```

### Why each slot matters

**POINT** — name the component, file, or section. Not "the hero"—`components/Hero.tsx`. Not "the floppy thing"—`components/SessionCard.tsx`. The model has the whole repo in context; giving it a path saves it from re-reading the whole tree to figure out which "hero" you meant.

**CHANGE** — describe the state change as `from X → to Y`. This is the slot that forces *you* to know what you want before you prompt. If you can't write the "from → to" arrow, you're not ready to prompt yet—you're ready to sketch. (See §5.) "Shrink it 20%" is a number; "make it smaller" is a wish. The numbered version one-shots; the wish version generates three rounds of "smaller? like this? smaller still?"

**CONSTRAINT** — what NOT to touch. The single biggest source of token waste is collateral damage. The model fixes the thing you asked for and "improves" five other things while it's in there. Naming the no-go list up front saves you the reversal commits.

**REFERENCE** — a screenshot, a commit SHA, a URL. Concrete beats descriptive. "Match the rhythm of the bonus cards" loses to a screenshot of the bonus cards every time.

### Skeleton

```
In `components/<Component>.tsx`, change <THING> from <STATE A> to <STATE B>.

Don't touch:
- <unrelated component / styling / behavior>
- <thing you've already locked>

Reference: <screenshot path | URL | commit SHA>
```

Treat the four slots as required. If any slot is hand-wave-y, stop and tighten it before sending—every minute spent sharpening the prompt saves three minutes of cleanup later.

---

## 3. The 6 prompt templates

Copy-paste these. The next six sections are pre-filled variants of the skeleton above, each tuned to a specific edit type.

### 3.1 Mobile optimization

**When to use.** The desktop site is locked. You opened it on your actual phone and it looks like it fell down a flight of stairs. Use this when the page works at ≥1024px but breaks somewhere between 320px and 768px—horizontal scroll, CTAs bleeding off-edge, hero content below the fold, desktop-only widgets that didn't earn their keep on a phone.

**The prompt.**

```
Audit <PAGE/COMPONENT> for mobile (≤640px). Kill:
- Horizontal scroll (anything wider than viewport)
- CTAs bleeding off-edge
- Desktop-only widgets that should hide on mobile
- Hero content dropping below the fold

Constraints:
- Desktop layout unchanged above 768px
- Don't touch copy
- Don't restructure component hierarchy unless you mark it clearly

Reference: <screenshot of current mobile state>

Return a diff, not a full file rewrite.
```

How to use it. Run `npm run dev`, open the site on your actual phone via your machine's local IP—not Chrome devtools, devtools lies about touch and momentum. Screenshot what's broken. Paste the screenshot path into the REFERENCE slot. The screenshot is what makes this one-shot instead of three-shot—the model sees the same thing you see.

**The trap to avoid.** "Make it work on mobile" is a wish, not a prompt. The model picks whichever ten things it feels like fixing first, you get a partial pass, and you spend the next five prompts chasing the leftovers. Be specific about the failure modes you actually see in your screenshot.

**Promotion status.** Upstream skill candidate—the patterns that show up here on every project become defaults. This is the pattern that led to the mobile-optimize defaults you'll see in `/ccmb-landing-page`. You shouldn't have to type this prompt on a fresh CCMB site; if you do, something drifted in the generator and you've found a signal worth chasing through the codify loop.

---

### 3.2 Performance

**When to use.** The site loads, but it loads slow. LCP over 2.5s. Lighthouse yelling at you. Hero image taking forever. You don't want to rewrite the world—you want measurable wins from known levers.

**The prompt.**

```
Audit <PROJECT> for page-load perf. Apply:
- WebP conversion for any PNG/JPG over 50KB
- Font preconnect to gstatic/wherever
- LCP preload for the hero image
- Cache-Control headers in vercel.json
- Parallel font loading (no render-blocking)

Don't:
- Refactor components
- Change layout
- Touch copy

Return file-by-file changes. Show the perf budget before/after if Lighthouse data is available.
```

How to use it. Run a Lighthouse pass first (`npx lighthouse <url> --view`) and paste the report's "Opportunities" section into the prompt. That gives the model the numeric ceiling on each fix so it can prioritize. Re-run Lighthouse after the diff lands—if LCP didn't move, the hero image preload didn't actually fire, and that's where to look.

**The trap to avoid.** Chasing false positives. F12's "compress with gzip" failing grade is a lie on Vercel—`curl -v` shows `content-encoding: br` (Brotli), which is 15-25% better than gzip. Verify the actual response headers before trusting a Lighthouse complaint.

**Promotion status.** Upstream skill candidate. Pure physics—no brand decisions, no taste calls. This is the pattern that led to the page-load-speed defaults you'll see in `/ccmb-landing-page`. A fresh CCMB site should ship perf-clean on commit one.

---

### 3.3 Design audit

**When to use.** The site is functional but feels generic. You can't point at a single thing that's wrong—you just know the whole vibe is off. Use this BEFORE you start polishing anything. The audit returns a punch list ranked by impact; you triage to blockers, then issue surgical edits.

**The prompt.**

```
Audit <PAGE/COMPONENT> against the design principles in:
- <brand.md>
- <TASTE.md>
- <claude-design-kit reference>

For each violation, output:
1. Location (file:line or component:section)
2. Principle violated
3. Suggested fix (one sentence)
4. Severity (blocker / nit)

Don't write code. Return the punch list. I'll prioritize.
```

How to use it. This is a *reading* prompt, not a *writing* prompt. Critical distinction. The auditor's job is to surface violations against principles you've already locked—not to fix them. Returning code at this stage pre-commits the model to one fix per violation before you've ranked which violations actually matter. Half the punch list is usually nits you'll skip; the other half is blockers you'll fix in one focused pass. Mixing the two costs tokens and burns the audit's signal.

Read the punch list. Triage to blockers. Then issue a *new* prompt scoped to just those—usually a copy-polish or layout-restructure call with the audit findings pasted in.

**Subagent variant.** When the punch list needs more rigor than a single prompt—e.g., auditing the full landing page across 12 components—invoke this as a subagent: `Task("audit homepage against brand.md and TASTE.md, return punch list ranked blocker/nit", subagent_type: "general-purpose")`. The subagent loads `brand.md`, `TASTE.md`, and the design-kit references as its own context, runs the audit in isolation, and returns the punch list without polluting your main thread's token budget. Don't write the full subagent prompt inline—point at the principles files and let the agent read them itself.

**The trap to avoid.** Asking for code in the audit. The moment the model writes a fix, you'll feel obligated to use it, and you'll skip the triage step that determines which fixes actually matter.

**Promotion status.** Sideways skill. The shape is reusable; the principles loaded change per project (CCMB's `brand.md` says one thing, your client's brand will say another). Lives as an editing skill you load with the brand's TASTE.md, not baked into generation.

---

### 3.4 Copy polish

**When to use.** The layout is locked. The words are functional but not landing. Use this AFTER design audit, AFTER restructure—copy polish is the final pass, not the first one. If the section's bones are wrong, polishing the words won't fix it.

**The prompt.**

```
Polish copy in <COMPONENT/SECTION>. Voice rules:
- <pull from TASTE.md>

Current copy:
> <paste>

What's wrong with it:
- <too generic / hedging / wrong audience / etc.>

Constraints:
- Max <N> words
- Keep <THIS PHRASE> verbatim
- Headline must rhyme with <eyebrow / CTA>

Return 3 options, ranked. No commentary.
```

The 3-round protocol. Copy edits iterate. They don't one-shot. Plan for three rounds and don't pretend otherwise.

- **Round one** — ask for 3-5 options across different angles (mechanism, outcome, objection). Surface the option space cheaply.
- **Round two** — pick the angle. Ask for 3 variants inside it.
- **Round three** — line-edit the winner.

The reason copy can't one-shot is that *you* don't know what you want until you see options. You can't recognize what you haven't seen, so the first round's job is to surface the option space, not to land. Skipping to round three on the first prompt is the failure mode—you get one polished option that's the wrong angle entirely.

"3 options, ranked, no commentary" is the trick—it forces the model to commit to a ranking instead of hedging with "any of these could work." The model's #1 is usually safe; the #2 or #3 often has the spike that makes you say "oh, that one."

**The trap to avoid.** Asking for "better copy" without naming what's wrong with the current copy. The diagnosis slot ("what's wrong with it") is doing more work than you think—if you can't fill it, you don't have a polish problem, you have a design-audit problem (§3.3).

**Promotion status.** Sideways skill. Voice is project-specific. CCMB has a `/ccmb-sentence-editor` skill that loads the CCMB voice rules from `TASTE.md`; future projects get their own voice file and their own polish skill. The shape stays; the inputs swap.

---

### 3.5 Layout restructure

**When to use.** A section's bones are wrong and you need to redesign, not tweak. If you're rearranging sections, swapping a 1-col for 2-col, or turning a list into a card grid—restructure. If you're just changing words—polish (§3.4).

The test: if the *order* or *shape* of what's on screen changes, it's a restructure. If only the *words inside the existing shapes* change, it's a polish.

**The prompt.**

```
Restructure <SECTION> in <FILE>.

Current shape:
- <describe current layout>

Target shape:
- <describe target layout>

Why:
- <one sentence — what the restructure unlocks>

Constraints:
- Section above and below stay untouched
- Existing copy stays unless I flag otherwise
- Mobile must remain working (≤640px)

Reference: <screenshot or competitor link>

Return the diff for the single component file.
```

On the REFERENCE slot. Restructure prompts fail without a visual anchor. Describing layout in prose ("two columns, image left, card right") gets you a generic two-column layout that doesn't match what's in your head. A screenshot of the target—a competitor's section, a Figma sketch, even a paper-napkin photo—gives the model the *proportions*, *whitespace*, and *visual rhythm* the words can't carry.

Mobile constraint matters too. Every restructure should be checked against ≤640px before merging, because the desktop layout you just described almost certainly assumes a wider canvas than a phone has.

**The trap to avoid.** Restructuring after N small tweaks instead of stepping back and re-shaping the section once. If you've made three copy polishes and a color tweak on a section and it still feels wrong, the bones are wrong—stop tweaking and restructure. The surgical-edit pattern works for surgical problems. When the diagnosis is "this whole section is misshapen," surgical edits compound into a worse-shaped section with more commits attached.

**Promotion status.** Stays a prompt. Restructures are project-specific by definition—no two sites have the same section shapes—so there's nothing stable enough to promote.

---

### 3.6 Image swap

**When to use.** The layout is right and you're dropping in finished visuals. New hero shot. New bonus image. New instructor portrait. Trivial-looking edit, silent failure mode—worth templating.

**Pre-flight checklist.** Before prompting:

- **Image is in `public/`** — if it's still in Downloads or a Figma export folder, the swap "succeeds" against a path that doesn't exist in the deployed build. Local dev may even hit a cached file and look fine. Production ships broken.
- **WebP version exists** (or you're swapping for one) — every other image on the site is WebP. Drop a PNG in and you've quietly doubled that asset's payload. The model won't notice the path mismatch and you'll ship a slow page.
- **Aspect ratio matches the slot** (or you've decided what to do about it) — drop a 16:9 image into a 1:1 slot and it either letterboxes (intended) or stretches (not intended). Decide *before* prompting, not after seeing the squish.

**The prompt.**

```
In <COMPONENT>, swap the image at <SLOT> from <OLD> to <NEW>.

- Path: /<new-image-path>
- Alt text: "<new alt>"
- Aspect ratio: <e.g. 1:1, contain not cover>

Don't:
- Touch surrounding layout
- Change other images
- Add captions unless I asked

Show me the one-line change.
```

**On silent failure.** Image swaps look successful in the diff—the path string changes, the alt text changes, the model reports "done." But the render breaks if the file isn't where the path points, the aspect ratio fights the container, or the `<Image>` component's width/height props don't match the new asset. Verify by running `npm run dev` and looking at the actual element in the browser, not just trusting the diff. On Vercel, also check the deployed URL—local dev caches can hide broken paths that 404 in production.

**The trap to avoid.** Trusting the diff. The diff says the path changed. The path changed. The image is still broken. Always eyeball the rendered element.

**Promotion status.** Stays a prompt. The mechanics are stable but the failure mode (silent breakage) means you want a human in the loop verifying the render, not a skill that automates the swap and trusts itself.

---

## 4. One-shot vs iterate — when each is correct

Some edits land in one prompt. Some take three. Knowing which is which before you start saves the most tokens.

**Rule:** visual and structural changes one-shot. Copy iterates. Layout fits between.

| Edit type | Pattern |
|-----------|---------|
| Visual / structural | One-shot. Concrete spec, single commit. The model knows what 20% smaller looks like—it just does the math. |
| Performance / infra | One-shot. Measurable goal, no ambiguity. WebP conversion, cache headers, font preload—pure physics. |
| Layout responsive | One to three iterations. First pass exposes the bugs the spec missed. |
| Copy / voice | Iterates. Draft, react, refine. The model can't taste—you can. |
| Speculative ("let's try X") | Don't prompt. Sketch first. (See §5.) |

Visual stuff one-shots because the model knows what 20% smaller looks like—it just does the math. Copy iterates because "match my voice" requires examples the model gradually pattern-matches against. Layout sits between because the spec usually misses an edge case—the sticky pill that still occupies its document-flow space at scrollY=0, the grid column that grows past its parent because `1fr` is shorthand for `minmax(auto, 1fr)`. Edge cases like these are why responsive layout takes two or three commits even when the spec was tight.

If you're not sure, default to one-shot with a tight CONSTRAINT block. The reversal commit is the diagnostic—if you had to revert, the prompt was too loose, not the model too dumb.

---

## 5. The analog → digital handoff

This is the single highest-leverage habit in the loop. Decide off-machine. *Then* prompt.

Speculative prompting is fine. Speculative *committing* is the trap.

### Worked example — the bios drop-and-restore

The cautionary tale. Real shape from real work—names changed.

You're polishing the instructors section. Three instructor cards, each with a portrait, a name, a role, and a 40-word bio. You look at it and think: *what if the bios were gone? Just photos and names. Cleaner, right?* So you prompt:

> Drop the bios from `components/Instructors.tsx`. Just photos, names, roles.

Commit one. Two files changed: the component (removed the bio field from the type, removed the strings, removed the JSX line) and the CSS file (removed the `.instructor-bio` rule). Clean commit, well-formed prompt, fast turnaround. You look at the deployed page.

You hate it.

Without the bios, the cards feel like a faculty directory at a community college. The bios were doing emotional work you didn't notice they were doing. So you prompt:

> Restore the bios from the previous commit. Same copy, same styling.

Commit two. Same two files. Fifteen insertions, zero deletions. Every removal from commit one re-added. Net change between `commit_one^` and `commit_two`: zero. Byte-identical to where you started.

Thirteen minutes apart. Two prompt round-trips. Two diff reviews. Two reads of the same component file. Two reads of the same CSS file. Conservatively 15-25k tokens of context and generation. For nothing.

That's the cost of a speculative commit. You pay twice—once to make the change, once to undo it—and the second prompt isn't cheaper than the first. The model has to re-read the file, regenerate the diff, and you have to review another commit. Worst part: your contributions graph looks productive. Two commits! Repo no different.

### The protocol — three steps, all off-machine, before you touch the prompt box

1. **Screenshot the current state.** You can't compare to a version you can't see. Take the screenshot before you touch anything. Put it next to your editor.
2. **Sketch the alternative.** Paper, Figma, the back of a Trader Joe's receipt. Doesn't matter. The act of drawing the new state forces you to commit to it before you've spent any tokens. Annotate the screenshot—red arrows, "shrink this 20%," "kill this whole row." This becomes your REFERENCE slot.
3. **Decide.** Would you ship the sketched version? If yes, prompt once. If no, no edit at all.

If you can't sketch it, you don't know what you want. Don't prompt. The model will produce *something*—and you'll spend the next three commits walking it back.

**The exception.** Pure measurable changes (perf, accessibility scores, broken-link fixes). Those don't need a sketch because the success state is numeric. Everything visual or structural gets the sketch first.

---

## 6. The codify loop — make every edit you make redundant

Editing is the diagnostic. Every recurring edit is a signal that the *generation* skill is missing something, or that the edit itself deserves to become its own reusable skill. The codify loop is how you promote a pattern from "edit I keep making" to "skill I install once."

### The loop

1. **Notice** — you made the same edit twice across projects, or three times on one project. Track it the moment you feel "wait, didn't I just do this?" That's the signal—don't lose it.
2. **Promote** — decide where it belongs:
   - **Upstream** into the *generation* skill → the next site one-shots it.
   - **Sideways** into an *editing* skill → you reuse it as a tool.
3. **Codify** — write the prompt template first (just a `.md` file in a `prompts/` folder). When the template stabilizes across 3+ uses, extract the skill.
4. **Retire** — delete the manual step from your workflow. If the pattern is in the generation skill, the next site is born with it and you never type the prompt again. If it's a sideways skill, the skill loads on demand and the prompt template gets archived.

The loop's whole job is to make today's friction into tomorrow's silence. If you're still typing the same correction six months from now, you skipped step 4.

### Decision — upstream vs sideways

The rule: **upstream if every project needs it, sideways if each project needs it differently.**

- **Upstream** if the edit is *always* needed regardless of brand, voice, or audience—mobile responsiveness, perf basics, accessibility floor, anti-horizontal-scroll safety, hashed-asset caching. These are physics. Bake them into generation; never type them again.
- **Sideways** if the edit is *contextual*—design audit against this brand's principles, copy polish in this voice, accessibility against a specific WCAG tier. The shape is reusable; the inputs change every time.

When you're not sure, ask: does the prompt have brand-specific values stuffed into it? If yes, sideways—the brand stuff is the input. If no, upstream—there's nothing to parameterize, it's just the floor.

### The bios case study, codified

Walk back through §5. The bios drop-and-restore wasn't a missing skill—it was a missing *habit*. The codify-loop response isn't "extract a skill," it's "write the protocol down and follow it next time." Some signals from your edits become skills. Some become checklists. Some become the rule you tell yourself before you prompt. The loop is the same—notice, promote, codify, retire—but the artifact at the end isn't always a `SKILL.md`. Sometimes it's just a sentence you finally believe.

For the bios pattern, the artifact is §5 of this document. The sentence you finally believe: *never commit a "let's see."*

---

## 7. When a prompt becomes a skill

Three signals:

- You've copy-pasted the prompt 3+ times.
- The prompt has stabilized (no edits across uses).
- You're parameterizing it mentally each time you paste.

That's the moment to extract.

If you hit all three, run the skill-creator workflow. The stabilized prompt template becomes the skill body; the things you've been mentally swapping become its inputs. Skills born this way—from real evidence of real reuse—are the ones that stick. Skills born from "wouldn't it be cool if" rot in `~/.claude/skills/`.

CCMB ships with three skills already promoted this way: `/ccmb-landing-page` (the generator that bakes in everything mobile-optimize and page-load-speed taught us, so you don't have to type those prompts on a fresh site), `/ccmb-headline-writer` (the headline-options pattern from copy-polish round one, extracted because it stabilized across every section of every site), and `/ccmb-sentence-editor` (the line-edit pattern from copy-polish round three, loaded with the CCMB voice rules).

You'll grow your own. Watch your edits. When the same prompt shows up the third time, you have a skill. Open the skill-creator. Pass it the prompt. Name the inputs. Ship it.

That's the loop. Edit → notice → codify → retire. Every site is the data; every skill is the dividend.

The goal isn't to type more prompts faster. The goal is to type fewer prompts at all.
