#!/usr/bin/env bash
set -euo pipefail

echo ""
echo "================================================================================"
echo "POST-CREATE SETUP STARTING"
echo "================================================================================"
echo "Running as: $(id)"
echo ""

# Verify key CLIs are available (all installed via Dockerfile)
echo "================================================================================"
echo "CLIs AVAILABLE"
echo "================================================================================"
for cli in nvim opencode claude uv starship zoxide node npm csvlens micromamba az azcopy azd kubectl helm flux glab aws entire; do
	which "$cli" 2>/dev/null && echo "[OK]     $cli: $(which $cli)" || echo "[MISSING] $cli"
done

# Print git tooling summary
echo ""
echo "================================================================================"
echo "GIT TOOLING AVAILABLE"
echo "================================================================================"
for cli in git lazygit gh delta; do
	which "$cli" >/dev/null 2>&1 && echo "[OK]     $cli: $(which $cli)" || echo "[MISSING] $cli"
done

# Collect all installed tool versions and write to tool-versions.txt
# This file is .gitignore'd; useful for debugging when a build has issues.
TOOL_VERSIONS_FILE="/workspace/tool-versions.txt"
echo ""
echo "================================================================================"
echo "COLLECTING TOOL VERSIONS"
echo "================================================================================"
{
	echo "# Tool versions captured at devcontainer post-create"
	echo "# Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
	echo ""

	# --- Section 1: all dpkg/apt-managed system packages ---
	echo "## System packages (dpkg)"
	dpkg-query -W -f='  ${Package}: ${Version}\n' 2>/dev/null | sort
	echo ""

	# --- Section 2: executables found in non-system PATH dirs ---
	# Standard system dirs (/usr/bin, /bin, /sbin, /usr/sbin) are already
	# fully covered by dpkg above; scanning them again would be redundant and slow.
	# This section only probes user/local dirs (e.g. /usr/local/bin, ~/.local/bin)
	# where manually-installed tools live.
	# Uses `timeout 2` per binary to avoid hangs; tries --version then -V.
	echo "## PATH executables (non-system)"
	declare -A _seen
	while IFS= read -r _dir; do
		[ -d "$_dir" ] || continue
		# Skip standard system directories already covered by dpkg
		case "$_dir" in /usr/bin | /bin | /sbin | /usr/sbin) continue ;; esac
		for _bin in "$_dir"/*; do
			[ -x "$_bin" ] && [ -f "$_bin" ] || continue
			_name=$(basename "$_bin")
			[ "${_seen[$_name]+_}" ] && continue # skip duplicates across PATH dirs
			_seen["$_name"]=1
			_ver=$(timeout 2 "$_bin" --version 2>&1 | grep -m1 '.' 2>/dev/null || true)
			[ -z "$_ver" ] && _ver=$(timeout 2 "$_bin" -V 2>&1 | grep -m1 '.' 2>/dev/null || true)
			[ -z "$_ver" ] && _ver="(version unknown)"
			echo "  $_name: $_ver"
		done
	done < <(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++') | sort

} >"$TOOL_VERSIONS_FILE"

echo "Written to: $TOOL_VERSIONS_FILE"
echo ""

echo "================================================================================"
echo "TIPS & NEXT STEPS"
echo "================================================================================"
echo "Run 'az login' to authenticate with Azure (enables az, azcopy, azd)"
echo "Run 'lazygit' to open the lazygit TUI"
echo ""
echo "RUN 'onboard' for guided authentication setup"
echo "  (Step 1: gh auth login)"
echo "  (Step 2: opencode auth login)"
echo "  (Step 3: claude auth login)"

# ── Resolve repo directory relative to this script ──────────────────────────────
# Allows post-create to work regardless of workspace name or mount path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# ── Git identity guard ─────────────────────────────────────────────────────────
# Refuse to guess an identity; each user sets name/email via 'onboard'.
git config --global user.useConfigOnly true

# ── Claude Code container-wide settings ──────────────────────────────────────
echo ""
echo "================================================================================"
echo "CONFIGURING CLAUDE CODE SETTINGS"
echo "================================================================================"

CLAUDE_DIR="$HOME/.claude"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"
CLAUDE_HOOKS_DIR="$CLAUDE_DIR/hooks"
REPO_HOOKS_DIR="$SCRIPT_DIR/hooks"

mkdir -p "$CLAUDE_HOOKS_DIR"

# Install hook scripts
if [ -d "$REPO_HOOKS_DIR" ]; then
	cp "$REPO_HOOKS_DIR"/*.sh "$CLAUDE_HOOKS_DIR/" 2>/dev/null &&
		chmod +x "$CLAUDE_HOOKS_DIR"/*.sh
	echo "[OK] Hooks installed to $CLAUDE_HOOKS_DIR"
fi

# Container-wide settings — use the repo's .claude/settings.json as the source of truth
CONTAINER_SETTINGS=$(cat "$REPO_ROOT/.claude/settings.json")

# Merge into existing settings (preserves user preferences like model/theme).
# Hooks are concatenated per event (deduplicated), so user hooks survive.
if [ -f "$CLAUDE_SETTINGS" ]; then
	MERGED=$(jq -n --argjson existing "$(cat "$CLAUDE_SETTINGS")" --argjson new "$CONTAINER_SETTINGS" '
    $existing + {
      hooks: (reduce (($new.hooks // {}) | keys[]) as $e (($existing.hooks // {}); .[$e] = ((.[$e] // []) + $new.hooks[$e] | unique))),
      permissions: {
        allow: (($existing.permissions.allow // []) + ($new.permissions.allow // []) | unique),
        deny:  (($existing.permissions.deny  // []) + ($new.permissions.deny  // []) | unique)
      }
    }
  ')
	echo "$MERGED" >"$CLAUDE_SETTINGS"
else
	echo "$CONTAINER_SETTINGS" >"$CLAUDE_SETTINGS"
fi
echo "[OK] Container-wide settings merged into $CLAUDE_SETTINGS"

# ── Global agent instructions ────────────────────────────────────────────────
echo ""
echo "================================================================================"
echo "INSTALLING GLOBAL AGENT INSTRUCTIONS"
echo "================================================================================"

GLOBAL_INSTRUCTIONS="$REPO_ROOT/global_claude.md"
BASELINE_NAME="ceda-baseline.md"
CLAUDE_GLOBAL="$CLAUDE_DIR/CLAUDE.md"
CLAUDE_BASELINE="$CLAUDE_DIR/$BASELINE_NAME"
OPENCODE_GLOBAL="$HOME/.config/opencode/AGENTS.md"
BLOCK_BEGIN="<!-- BEGIN dev-dots baseline (managed by post-create.sh, do not edit) -->"
BLOCK_END="<!-- END dev-dots baseline -->"

# The baseline is repo-owned and always refreshed; personal instructions in the
# user's own CLAUDE.md / AGENTS.md are never overwritten.
#  - Claude Code: baseline -> ~/.claude/ceda-baseline.md, imported from CLAUDE.md
#    with one "@ceda-baseline.md" line (appended once).
#  - OpenCode: no import syntax in AGENTS.md, so the baseline is kept in a
#    managed BEGIN/END block that is replaced on every run.
# A file that is still an exact copy of the baseline (written by older versions
# of this script) is treated as empty, so migrating does not duplicate content.

install_claude_baseline() {
	mkdir -p "$CLAUDE_DIR" &&
		cp "$GLOBAL_INSTRUCTIONS" "$CLAUDE_BASELINE" || return 1
	if [ -f "$CLAUDE_GLOBAL" ] && cmp -s "$CLAUDE_GLOBAL" "$GLOBAL_INSTRUCTIONS"; then
		printf '@%s\n' "$BASELINE_NAME" >"$CLAUDE_GLOBAL"
	elif [ -f "$CLAUDE_GLOBAL" ] && grep -qxF "@$BASELINE_NAME" "$CLAUDE_GLOBAL"; then
		:
	else
		{
			[ -s "$CLAUDE_GLOBAL" ] && printf '\n'
			printf '@%s\n' "$BASELINE_NAME"
		} >>"$CLAUDE_GLOBAL"
	fi
}

install_opencode_baseline() {
	local tmp
	mkdir -p "$(dirname "$OPENCODE_GLOBAL")" || return 1
	tmp=$(mktemp) || return 1
	if [ -f "$OPENCODE_GLOBAL" ] && ! cmp -s "$OPENCODE_GLOBAL" "$GLOBAL_INSTRUCTIONS"; then
		# Drop the old managed block, then trailing blank lines
		awk -v b="$BLOCK_BEGIN" -v e="$BLOCK_END" '$0==b{skip=1;next} $0==e{skip=0;next} !skip' \
			"$OPENCODE_GLOBAL" |
			sed -e :a -e '/^[[:space:]]*$/{$d;N;ba' -e '}' >"$tmp"
	fi
	{
		[ -s "$tmp" ] && printf '\n'
		printf '%s\n' "$BLOCK_BEGIN"
		cat "$GLOBAL_INSTRUCTIONS"
		printf '%s\n' "$BLOCK_END"
	} >>"$tmp"
	cat "$tmp" >"$OPENCODE_GLOBAL"
	rm -f "$tmp"
}

if [ -f "$GLOBAL_INSTRUCTIONS" ]; then
	# Best-effort under set -euo pipefail: a failure is reported instead of
	# aborting post-create (which would silently skip skills + completion).
	install_claude_baseline &&
		echo "[OK] Baseline -> $CLAUDE_BASELINE (imported from $CLAUDE_GLOBAL)" ||
		echo "[WARN] Failed to install Claude baseline"
	install_opencode_baseline &&
		echo "[OK] Baseline -> $OPENCODE_GLOBAL (managed block)" ||
		echo "[WARN] Failed to install OpenCode baseline"
else
	echo "[SKIPPED] $GLOBAL_INSTRUCTIONS not found"
fi

# ── Load Claude/OpenCode skills ──────────────────────────────────────────────
echo ""
echo "================================================================================"
echo "LOADING CLAUDE SKILLS"
echo "================================================================================"

if bash "$SCRIPT_DIR/install-skills.sh"; then
	echo "[OK] Skills loaded from cedanl/.github"
else
	echo "[SKIPPED] Skills install (npx may not be available yet)"
fi

echo ""
echo "================================================================================"
echo "POST-CREATE SETUP COMPLETE"
echo "================================================================================"
echo "Run 'onboard' to authenticate GitHub CLI, OpenCode and Claude"
echo "Run 'nvim .' to start editing"
