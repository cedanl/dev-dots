#!/usr/bin/env bash
set -euo pipefail

# Install CEDA skills from cedanl/.github for claude-code, opencode and pi.
#
# Single source of truth for the skills install, shared by post-create.sh and
# post-attach.sh, so the exact install command cannot drift between the two.
# Runs silently; the exit status tells the caller whether the install
# succeeded so each caller can pick its own messaging.

# Pinned CLI version (supply chain): `npx --yes skills` would run whatever is latest on npm.
# The skills *content* still follows cedanl/.github HEAD on purpose (post-attach auto-refreshes);
# that repo has no tags/releases to pin to.
# renovate: datasource=npm depName=skills
SKILLS_VERSION="1.7.6"

npx --yes "skills@${SKILLS_VERSION}" add cedanl/.github --skill '*' -a claude-code -a opencode -a pi -y --copy -g >/dev/null 2>&1
