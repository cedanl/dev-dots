#!/usr/bin/env python3
"""Genereer het versieblok in docs/image-en-versies.md uit de Dockerfile en devcontainer.json.

  python3 scripts/gen_docs.py          schrijf het blok
  python3 scripts/gen_docs.py --check  faal (exit 1) als het blok afwijkt
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOCKERFILE = ROOT / ".devcontainer" / "Dockerfile"
DEVCONTAINER = ROOT / ".devcontainer" / "devcontainer.json"
FIREWALL = ROOT / ".devcontainer" / "firewall" / "devcontainer.json"
PAGE = ROOT / "docs" / "image-en-versies.md"
BEGIN = "<!-- gen:versies:begin -->"
END = "<!-- gen:versies:end -->"

RENOVATE = re.compile(r"^# renovate: .*?depName=(\S+)")
ARG = re.compile(r'^ARG (\w+_VERSION)="([^"]+)"')


def tool_versions(dockerfile_text):
    """Geef [(tool, versie, bron)] voor elke ARG met een renovate-regel erboven."""
    rows, dep = [], None
    for line in dockerfile_text.splitlines():
        m = RENOVATE.match(line)
        if m:
            dep = m.group(1)
            continue
        m = ARG.match(line)
        if m and dep:
            name = m.group(1)[: -len("_VERSION")].lower()
            rows.append((name, m.group(2), dep))
        dep = None
    return rows


def image_pin(path):
    return json.loads(path.read_text())["image"]


def render(dockerfile_text, pin, firewall_pin):
    lines = [BEGIN, ""]
    lines.append(f"Gepind image in `devcontainer.json`: `{pin}`.")
    if firewall_pin != pin:
        lines.append(f"De firewall-variant gebruikt `{firewall_pin}`.")
    lines += ["", "| Tool | Versie | Bron |", "|---|---|---|"]
    for name, version, dep in tool_versions(dockerfile_text):
        lines.append(f"| {name} | {version} | `{dep}` |")
    lines += ["", "Deze tabel wordt gegenereerd door `scripts/gen_docs.py` uit de `ARG`'s in de Dockerfile.", "", END]
    return "\n".join(lines)


def apply(page_text, block):
    a, b = page_text.index(BEGIN), page_text.index(END) + len(END)
    return page_text[:a] + block + page_text[b:]


def main(argv):
    block = render(DOCKERFILE.read_text(), image_pin(DEVCONTAINER), image_pin(FIREWALL))
    current = PAGE.read_text()
    new = apply(current, block)
    if "--check" in argv:
        if new != current:
            print("docs/image-en-versies.md is verouderd: draai python3 scripts/gen_docs.py", file=sys.stderr)
            return 1
        return 0
    PAGE.write_text(new)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
