#!/usr/bin/env bash
# ccmb-campaign-brainstorm test harness — structural assertions only.
set -uo pipefail

PASS=0
FAIL=0
FAILURES=()

run_test() {
    local name="$1"
    local cmd="$2"
    if eval "$cmd" >/dev/null 2>&1; then
        echo "✅ $name"
        PASS=$((PASS+1))
    else
        echo "❌ $name"
        FAIL=$((FAIL+1))
        FAILURES+=("$name")
    fi
}

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== File-presence tests ==="
run_test "plugin.json exists" "[ -f \"$PLUGIN_DIR/.claude-plugin/plugin.json\" ]"
run_test "SKILL.md exists" "[ -f \"$PLUGIN_DIR/skills/ccmb-campaign-brainstorm/SKILL.md\" ]"
run_test "README.md exists" "[ -f \"$PLUGIN_DIR/README.md\" ]"
for ref in brief-schema framework-layers martech-native-map workshop-questions smart-mode-checklist common-risks; do
    run_test "$ref.md exists" "[ -f \"$PLUGIN_DIR/skills/ccmb-campaign-brainstorm/references/$ref.md\" ]"
done

echo ""
echo "=== JSON validity ==="
run_test "plugin.json valid JSON" \
    "python3 -c 'import json; json.load(open(\"$PLUGIN_DIR/.claude-plugin/plugin.json\"))'"

echo ""
echo "=== Frontmatter ==="
SKILL="$PLUGIN_DIR/skills/ccmb-campaign-brainstorm/SKILL.md"
run_test "SKILL.md has frontmatter name" "head -10 \"$SKILL\" | grep -q '^name: ccmb-campaign-brainstorm'"
run_test "SKILL.md has frontmatter description" "head -10 \"$SKILL\" | grep -q '^description:'"

echo ""
echo "=== Schema coverage (all 16 keys mentioned in brief-schema.md) ==="
SCHEMA="$PLUGIN_DIR/skills/ccmb-campaign-brainstorm/references/brief-schema.md"
for key in campaign_name slug type status created launch_window goal kpis audience offer channels assets claude_stack remarketing budget_usd risks; do
    run_test "brief-schema.md mentions '$key'" "grep -q \"$key\" \"$SCHEMA\""
done

echo ""
echo "=== Fixture validity ==="
run_test "full-context fixture has audience block" \
    "grep -q '^## Audience' \"$PLUGIN_DIR/tests/fixtures/workspace-full-context/CLAUDE.md\""
run_test "cold workspace is empty (only .gitkeep)" \
    "[ \"\$(ls -A \"$PLUGIN_DIR/tests/fixtures/workspace-cold/\" | wc -l | tr -d ' ')\" = '1' ]"
run_test "malformed brief fixture is unparseable YAML (correctly malformed)" \
    "! python3 -c \"
import sys
with open('$PLUGIN_DIR/tests/fixtures/briefs-malformed/bad-yaml/brief.md') as f:
    content = f.read()
parts = content.split('---')
if len(parts) >= 2:
    import yaml
    yaml.safe_load(parts[1])
\" 2>/dev/null"

echo ""
echo "=== MarTech anti-default ==="
MARTECH="$PLUGIN_DIR/skills/ccmb-campaign-brainstorm/references/martech-native-map.md"
run_test "martech map flags Ayrshare as tier 3 / paid" \
    "grep -E -A1 'Social scheduling' \"$MARTECH\" | grep -qi 'manually'"
run_test "martech map has 'Anti-defaults' section" \
    "grep -q '## Anti-defaults' \"$MARTECH\""

echo ""
echo "=== Summary ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"
if [ $FAIL -gt 0 ]; then
    echo ""
    echo "Failures:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    exit 1
fi
echo ""
echo "All tests passed."
exit 0
