#!/usr/bin/env bash
set -euo pipefail

# Post-attach skill refresh.
#
# Skips entirely (silently and fast) when the remote source has not changed,
# so attaching to an up-to-date container is near-instant with zero noise.
# Only when cedanl/.github actually moved do we run the (idempotent) skills
# install, and even then we keep it quiet and print a single notice line.

SKILLS_SOURCE="https://github.com/cedanl/.github.git"
SKILLS_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dev-dots"
SKILLS_REF_FILE="$SKILLS_CACHE_DIR/skills-source-ref"

# git ls-remote is a ~100ms network call and never clones the repo, so this is
# the cheap first gate. If we cannot reach the network (offline), stay silent.
if ! command -v git >/dev/null 2>&1; then
	exit 0
fi

remote_ref=$(timeout 10 git ls-remote "$SKILLS_SOURCE" HEAD 2>/dev/null | awk '{print $1; exit}') || true
if [ -z "$remote_ref" ]; then
	# Offline or source unavailable; nothing to check, no noise.
	exit 0
fi

prev_ref=""
if [ -f "$SKILLS_REF_FILE" ]; then
	prev_ref=$(cat "$SKILLS_REF_FILE" 2>/dev/null || true)
fi

# Nothing changed on the remote since our last refresh: stay silent and exit.
if [ "$prev_ref" = "$remote_ref" ]; then
	exit 0
fi

# Remote moved: refresh the local skills, quietly. This mirrors the install in
# post-create.sh. `npx` may be missing right after attach, so tolerate failure.
if [ -z "${SKILLS_SKIP_REFRESH:-}" ]; then
	if npx --yes skills add cedanl/.github --skill '*' -a claude-code -a opencode -a pi -y --copy -g >/dev/null 2>&1; then
		mkdir -p "$SKILLS_CACHE_DIR"
		printf '%s\n' "$remote_ref" >"$SKILLS_REF_FILE"
		echo "[skills] Updated from cedanl/.github (new remote revision)."
	fi
fi

exit 0
