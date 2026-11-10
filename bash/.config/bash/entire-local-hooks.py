#!/usr/bin/env python3
"""Verplaats de hooks die `entire enable` in .claude/settings.json zette naar .claude/settings.local.json.

Aanroep vanuit de repo-root, na `entire enable`. Alleen als .claude/settings.json in git gevolgd wordt;
dan herstelt het script dat bestand naar HEAD, zodat de werkmap schoon blijft en de hooks niet gecommit worden.
"""

import json
import subprocess
import sys
from pathlib import Path

SETTINGS = Path(".claude/settings.json")
LOCAL = Path(".claude/settings.local.json")
MARKER = "entire hooks "  # zo begint elk commando dat Entire installeert
DENY = "Read(./.entire/metadata/**)"


def git(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *args], capture_output=True, text=True)


def is_entire(hook: dict) -> bool:
    return MARKER in hook.get("command", "")


def entire_groups(hooks: dict) -> dict:
    """Per event alleen de hook-groepen met Entire-commando's (andere hooks van de repo blijven staan)."""
    uit: dict = {}
    for event, groepen in hooks.items():
        for groep in groepen:
            eigen = [h for h in groep.get("hooks", []) if is_entire(h)]
            if eigen:
                uit.setdefault(event, []).append({**groep, "hooks": eigen})
    return uit


def zonder_entire(hooks: dict) -> dict:
    """De bestaande lokale hooks zonder oude Entire-regels, zodat herhalen geen dubbelen geeft."""
    uit: dict = {}
    for event, groepen in hooks.items():
        for groep in groepen:
            rest = [h for h in groep.get("hooks", []) if not is_entire(h)]
            if rest:
                uit.setdefault(event, []).append({**groep, "hooks": rest})
    return uit


def main() -> int:
    if not SETTINGS.exists() or git("ls-files", "--error-unmatch", str(SETTINGS)).returncode != 0:
        return 0  # ongevolgd bestand: er is niets te beschermen
    werk = json.loads(SETTINGS.read_text())
    nieuw = entire_groups(werk.get("hooks", {}))
    if not nieuw:
        return 0  # Entire heeft niets toegevoegd
    lokaal = json.loads(LOCAL.read_text()) if LOCAL.exists() else {}
    hooks = zonder_entire(lokaal.get("hooks", {}))
    for event, groepen in nieuw.items():
        hooks.setdefault(event, []).extend(groepen)
    lokaal["hooks"] = hooks
    if DENY in werk.get("permissions", {}).get("deny", []):
        deny = lokaal.setdefault("permissions", {}).setdefault("deny", [])
        if DENY not in deny:
            deny.append(DENY)
    LOCAL.write_text(json.dumps(lokaal, indent=2) + "\n")
    if git("checkout", "--", str(SETTINGS)).returncode != 0:
        print("entire_local: kon .claude/settings.json niet herstellen", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
