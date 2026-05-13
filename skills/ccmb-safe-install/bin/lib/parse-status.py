#!/usr/bin/env python3
"""Parse campaign-status.json from stdin, emit KEY=VAL pairs."""
import json, sys

s = json.loads(sys.stdin.read())
print("ACTIVE=" + ("1" if s.get("campaign_active") else "0"))
print("OFFSET=" + str(s.get("before_date_offset_days", 14)))
print("LAST_UPDATED=" + str(s.get("last_updated", "unknown")))
for k, v in s.get("pinned_packages", {}).items():
    print(f"PIN_{k.upper().replace('-', '_')}={v}")
print("COMPROMISES=" + "|".join(s.get("recent_compromises", [])))
