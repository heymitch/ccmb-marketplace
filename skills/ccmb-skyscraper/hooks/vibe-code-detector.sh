#!/usr/bin/env bash
# vibe-code-detector — UserPromptSubmit hook for the skyscraper plugin.
# Reads the prompt from stdin, emits a /skyscraper nudge if the prompt matches
# vibe-code intent + marketing-domain keywords. Per-session silenceable.

set -uo pipefail

# ---- Silence fast-path ----
SILENCE_FILE=".claude/.skyscraper-silenced"
if [ -f "$SILENCE_FILE" ]; then
    exit 0
fi

# ---- Read prompt from stdin ----
PROMPT=$(cat 2>/dev/null || echo "")

if [ -z "$PROMPT" ]; then
    exit 0
fi

# ---- Self-silence ----
# If the prompt literally says "silence skyscraper", write the silence file
# and exit silently. Skip nudging this round too.
if printf '%s' "$PROMPT" | grep -qiE 'silence[[:space:]]+skyscraper'; then
    mkdir -p .claude
    touch "$SILENCE_FILE"
    exit 0
fi

# ---- Match logic (python3 inline for regex clarity) ----
MATCH=$(python3 - <<'PYEOF' "$PROMPT"
import re
import sys

prompt = sys.argv[1] if len(sys.argv) > 1 else ""

VERBS = r"\b(build|make|create|scrape|track|clone|hack together|whip up|spin up|stand up)\b"
DOMAIN = r"\b(linkedin|twitter|reddit|youtube|email|crm|landing page|funnel|lead|analytics|dashboard|newsletter|seo|outreach|magnet|sequence|campaign|drip|nurture)\b"

if re.search(VERBS, prompt, re.I) and re.search(DOMAIN, prompt, re.I):
    print("MATCH")
PYEOF
)

# ---- Emit nudge ----
# Per Claude Code hooks docs (docs.claude.com/en/docs/claude-code/hooks),
# UserPromptSubmit hooks can write to stdout; that text becomes additional
# context appended before the model processes the prompt.
if [ "$MATCH" = "MATCH" ]; then
    cat <<'NUDGE'

💡 [skyscraper hook] This sounds like something `/skyscraper` could short-circuit.
Run `/skyscraper "<your problem>"` first to scan for existing solutions, or say
"silence skyscraper" to mute this hook for the session.
NUDGE
fi

exit 0
