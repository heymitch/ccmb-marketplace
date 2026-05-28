# Maintainers

Internal operations for the CCMB marketplace. Students never read this — see `README.md` for install-and-use docs.

## Repo layout

```
.claude-plugin/
  marketplace.json        ← marketplace manifest. ONE plugin entry.
plugins/
  claude-code-marketing-bootcamp/
    .claude-plugin/plugin.json   ← plugin manifest (name + metadata only)
    skills/<name>/SKILL.md       ← 28 skills, each with its own references/assets intact
    commands/skyscraper-setup.md ← the one command (skyscraper key/status check)
    references/*.md              ← Browser Monkey shared refs (endpoint-schema, monkey-js-template, url-variable-rules)
    bin/safe-npm + bin/lib/*.py  ← auto-added to PATH when plugin enabled (safe-install)
    config/campaign-status.json  ← offline fallback for the shield
    .env.example
campaign-status.json      ← LIVE policy file for the safe-install shield (repo root)
references/vibe-editing.md
CHANGELOG.md
```

**One plugin, not ten.** The bootcamp ships as a single plugin (`claude-code-marketing-bootcamp`) with 28 skills in its `skills/` directory — the compound-engineering model. Students run two commands: add marketplace, install the one plugin. There is no `displayName` field in the plugin schema; the plugin `name` *is* the display name and skill namespace (`claude-code-marketing-bootcamp:landing-page`). `name` must be kebab-case.

## Why everything is in one plugin

Decided 2026-05-18. The expiring bonuses (Campaign Pack, Vibe Workshop) are handled separately on the landing page; the 28 skills here are "everything everyone gets." Splitting into per-session or per-bonus plugins fragmented the menu (10 entries instead of 1) and didn't match the compound-engineering single-plugin model the product targets. Voice Lab, skyscraper, funnel-hack, browser-monkey (`monkey`/`sniffer`/`replay`), safe-install, campaign-brainstorm are skills *inside* the one plugin, not separate installs.

**Re-consolidated 2026-05-28.** A brief 4-plugin split (marketplace 2.1.0–2.2.0: browser-monkey, then skyscraper + funnel-hack broken out) was REVERSED. In the Claude Desktop GUI, sibling plugins under a single marketplace didn't surface reliably as individually-installable cards — students saw only the core plugin "at the top level," and the documented refresh confusion (remove + re-add creates a *duplicate* marketplace instead of refreshing; correct command is `/plugin marketplace update ccmb-marketplace`) made it worse. Folding all three back in as skills makes it one install, one card, zero discovery friction. `git mv` preserved history. If a future split is attempted, verify GUI multi-plugin rendering first.

## Plugin-root machinery (NOT skills)

Two components are plugin-root, auto-discovered when the plugin is enabled — they can't live in `skills/`:

- **`bin/`** — `safe-npm` + `bin/lib/*.py`. Claude Code auto-adds `bin/` to PATH. No manifest reference needed.
- **`config/campaign-status.json`** — offline fallback. The live root copy wins when reachable (see below).

> **No `UserPromptSubmit` hook.** The pre-consolidation skyscraper plugin shipped a `vibe-code-detector.sh` hook that nudged toward `/skyscraper` on every build-intent prompt. It was removed 2026-05-18 — the matcher (`.*`) + broad regex fired on essentially every legitimate bootcamp prompt ("build my landing page"), which is friction for beginners, not protection (it was a habit nudge, not an injection guard). `skyscraper` remains as an on-demand skill. Do not re-add an always-on hook to the consolidated plugin without a much narrower matcher and a documented pedagogical reason.

## The campaign-status kill-switch (for `safe-install`)

`campaign-status.json` at the repo root is the live policy file the shield reads on every invocation:

```
https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json
```

```json
{ "campaign_active": true, "campaign_name": "...", "before_date_offset_days": 14,
  "pinned_packages": {"vercel": "39.4.0"}, "recent_compromises": [], "last_updated": "..." }
```

- **Deactivate globally:** flip `campaign_active` to `false`. Every student's shield becomes pass-through on next install. No emails.
- **Hard-block a compromised version:** append to `recent_compromises` (e.g. `"foo@1.2.3"`).
- **Pin a package:** add to `pinned_packages`. Override flag: `--pin-override`.

## Versioning

- Backwards-compatible fixes → straight to `main`. Students get them via `/plugin marketplace update ccmb-marketplace`.
- Breaking changes → bump `version` in `plugins/claude-code-marketing-bootcamp/.claude-plugin/plugin.json` AND the matching `marketplace.json` entry.
- Structural changes (skills added/removed) → bump `marketplace.json` `metadata.version`.

## Adding a skill

1. Drop `skills/<name>/SKILL.md` (+ its `references/`, `assets/`) into the one plugin.
2. Skill name (folder == frontmatter `name`) must be unique across all 24.
3. Add a row to the README's relevant table.
4. CHANGELOG entry. Bump plugin version if it's a breaking change.

## Release checklist

- [ ] `python3 -m json.tool .claude-plugin/marketplace.json` parses
- [ ] `python3 -m json.tool plugins/claude-code-marketing-bootcamp/.claude-plugin/plugin.json` parses
- [ ] `marketplace.json` `source` resolves to the real plugin dir
- [ ] Every skill folder still has its `references/`/`assets/` (no SKILL-only regressions on skills that had support files — see CHANGELOG 2.0.0 for the inventory)
- [ ] `bin/safe-npm` is executable
- [ ] `plugin.json` has NO `hooks` key (no always-on UserPromptSubmit hook in the bootcamp plugin)
- [ ] README tables match the actual skill set
- [ ] `campaign-status.json` `last_updated` current if policy changed
