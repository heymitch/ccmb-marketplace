# Maintainers

Internal operations for the CCMB marketplace. Students never read this — see `README.md` for the install-and-use docs.

## Repo layout

```
.claude-plugin/
  marketplace.json        ← the marketplace manifest. Lists all 10 plugins.
plugins/
  <plugin-name>/
    .claude-plugin/plugin.json   ← per-plugin manifest. name MUST equal the folder name.
    commands/<cmd>.md            ← slash-command entry point
    skills/<skill>/SKILL.md      ← the skill(s) the command orchestrates
    README.md
campaign-status.json      ← LIVE policy file for the safe-install shield (see below)
references/
  vibe-editing.md         ← cross-cutting cheat sheet
CHANGELOG.md
```

**Invariant: folder name == `plugin.json` "name" == `marketplace.json` entry name.** All three must agree or the marketplace won't index the plugin. There's no `ccmb-` prefix on plugin names — students invoke by action (`/landing-page`, `/free-tool`), and the marketplace slug (`ccmb-marketplace`) carries the namespace.

## Distribution model

Marketplace-install only. Students run `/plugin marketplace add heymitch/ccmb-marketplace` then `/plugin install <name>@ccmb-marketplace`.

The old raw-`githubusercontent.com`-fetch model (where session trigger prompts fetched individual `SKILL.md` files at runtime) is **deprecated and removed**. The `sessions/` directory and loose `ccmb-*` skills that supported it are gone. Any session trigger prompt in the CCMB project that still raw-fetches must be updated to assume the plugin is installed via pre-work.

## The campaign-status kill-switch (for `safe-install`)

`campaign-status.json` at the repo root is the live policy file the `safe-install` shield reads on every invocation, via:

```
https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json
```

Shape:

```json
{
  "campaign_active": true,
  "campaign_name": "Mini Shai-Hulud / TeamPCP",
  "before_date_offset_days": 14,
  "pinned_packages": {"vercel": "39.4.0"},
  "recent_compromises": [],
  "last_updated": "2026-05-13"
}
```

- **Deactivate the shield globally:** flip `campaign_active` to `false`. Every student's shield becomes a pass-through on next install. No emails, no manual reversal.
- **Hard-block a freshly disclosed compromised version:** append to `recent_compromises` (e.g. `"foo@1.2.3"`). Students refuse it the moment the commit lands on `main`.
- **Pin a package:** add to `pinned_packages`. Students can only install the pinned version unless they pass `--pin-override`.

This file is also bundled at `plugins/safe-install/config/campaign-status.json` as an offline fallback. The live root copy wins when reachable.

## Versioning

- Backwards-compatible fixes ship straight to `main`. Students get them on next `/plugin marketplace update ccmb-marketplace`.
- Breaking changes bump the plugin's `version` in its `plugin.json` AND the matching entry in `marketplace.json`.
- The marketplace's own `metadata.version` bumps on structural changes (plugins added/removed, schema changes).

## Adding a plugin

1. Drop the plugin dir in `plugins/<name>/` with a valid `.claude-plugin/plugin.json` (name == folder).
2. Add an entry to `.claude-plugin/marketplace.json` `plugins[]` with `name`, `source: ./plugins/<name>`, `description`, `version`.
3. Add a row to the README table (core or bonus, with command + one-line description).
4. Add a `CHANGELOG.md` entry.
5. Commit + push to `main`.

## Release checklist

- [ ] Every `plugins/*/` folder name matches its `plugin.json` "name"
- [ ] Every plugin in `marketplace.json` has a real `./plugins/<name>` directory
- [ ] `marketplace.json` parses as valid JSON (`python3 -m json.tool .claude-plugin/marketplace.json`)
- [ ] README plugin tables match the actual plugin set
- [ ] CHANGELOG updated
- [ ] `campaign-status.json` `last_updated` is current if policy changed
