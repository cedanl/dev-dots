#!/usr/bin/env bash
# =============================================================================
# onboard.sh — Post-build onboarding wizard
# =============================================================================
# Guides you through the three authentication steps needed after each fresh
# container build:
#
#   1. gh auth login       — GitHub CLI authentication (+ git identity)
#   2. opencode auth login — GitHub Copilot in OpenCode
#   3. claude auth login   — Claude Code CLI authentication (+ entire enable)
#
# Run via the shell function:  onboard
# Or directly:                 bash ~/.onboard.sh
# =============================================================================

# Note: -e is intentionally omitted.  The check helpers (_gh_authed etc.) use
# commands that return non-zero to signal "not configured" — adding -e would
# abort the script in those cases.  Each step runner captures its own exit
# codes and uses '|| true' where failure should be non-fatal.
set -uo pipefail

# ── colour helpers ────────────────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

_bold()   { printf "${BOLD}%s${RESET}"   "$*"; }
_dim()    { printf "${DIM}%s${RESET}"    "$*"; }
_red()    { printf "${RED}%s${RESET}"    "$*"; }
_green()  { printf "${GREEN}%s${RESET}"  "$*"; }
_yellow() { printf "${YELLOW}%s${RESET}" "$*"; }
_cyan()   { printf "${CYAN}%s${RESET}"   "$*"; }

# ── status helpers ────────────────────────────────────────────────────────────
_done()    { echo "[OK]     $*"; }
_pending() { echo "[PENDING] $*"; }
_skip()    { echo "[SKIPPED] $*"; }
_info()    { echo "[INFO]   $*"; }
_error()   { echo "[ERROR]  $*" >&2; }
_section() { echo ""; echo "================================================================================"
             echo "$*"
             echo "================================================================================"; }

# ── check helpers ─────────────────────────────────────────────────────────────

# Returns 0 if gh is authenticated (any account), non-zero otherwise
_gh_authed() {
  gh auth status &>/dev/null
}

# Returns 0 if opencode appears to have auth credentials stored
_opencode_authed() {
  # OpenCode stores provider config in ~/.config/opencode/config.json
  # (or the XDG_CONFIG_HOME equivalent).  We look for a copilot/github entry.
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/config.json"
  [[ -f "$cfg" ]] && grep -qi '"copilot"\|"github_copilot"\|"github-copilot"' "$cfg" 2>/dev/null
}

# Returns 0 if claude is authenticated (any account), non-zero otherwise
_claude_authed() {
  claude auth status &>/dev/null
}

# ── prompt helpers ────────────────────────────────────────────────────────────

# Ask user a yes/no question; default answer shown in brackets.
# Usage: _ask_yn "prompt" [Y|N]   → returns 0 for yes, 1 for no
_ask_yn() {
  local prompt="$1"
  local default="${2:-Y}"
  local hint
  if [[ "${default^^}" == "Y" ]]; then
    hint="[Y/n]"
  else
    hint="[y/N]"
  fi

  while true; do
    read -r -p "$(echo -e "  ${YELLOW}?${RESET}  ${prompt} ${DIM}${hint}${RESET} ")" answer
    answer="${answer:-$default}"
    case "${answer^^}" in
      Y) return 0 ;;
      N) return 1 ;;
      *) echo -e "  Please answer y or n." ;;
    esac
  done
}

# ── git identity (issue #7) ───────────────────────────────────────────────────

# Set an explicit per-user git identity from gh. Called after gh auth login.
setup_git_identity() {
  _section "Git identity"
  echo ""
  _info "Deriving git identity from your GitHub account..."
  echo ""

  if ! _gh_authed; then
    _error "gh is not authenticated. Run 'gh auth login' first."
    return 1
  fi

  local login name email
  login=$(gh api user --jq '.login' 2>/dev/null || echo "")
  name=$(gh api user --jq '.name' 2>/dev/null | sed 's/^null$//' || echo "")
  email=$(gh api user --jq '.email' 2>/dev/null | sed 's/^null$//' || echo "")
  # gh returns null for private/absent email; fall back to noreply address
  [ -z "$email" ] && email="${login}@users.noreply.github.com"

  if [[ -z "$login" ]]; then
    _error "Could not determine your GitHub login."
    return 1
  fi
  [ -z "$name" ] && name="$login"

  _info "Name:  $(_bold "$name")"
  _info "Email: $(_bold "$email")"
  echo ""
  if _ask_yn "Use this git identity?"; then
    git config --global user.name "$name"
    git config --global user.email "$email"
    _done "git identity set (user.name / user.email)"
    _info "user.useConfigOnly is enabled: commits without an identity fail."
  else
    _info "Setting git identity skipped. You can run 'onboard' again to set it."
  fi
}

# ── step runners ──────────────────────────────────────────────────────────────

run_gh_auth() {
  _section "Step 1 / 3 — GitHub CLI authentication"
  echo ""
  _info "This authenticates gh CLI with your GitHub account."
  _info "You will be prompted to choose a protocol (HTTPS) and login method."
  echo ""

  if _gh_authed; then
    _done "Already authenticated:"
    gh auth status 2>&1 | sed 's/^/        /'
    echo ""
    if ! _ask_yn "Re-authenticate (switch account or refresh token)?"; then
      _skip "gh auth login"
      return 0
    fi
  fi

  echo ""
  gh auth login
  local rc=$?
  echo ""
  if [[ $rc -eq 0 ]]; then
    _done "gh auth login completed successfully."
    setup_git_identity || true
  else
    _error "gh auth login exited with code $rc. You can retry with: $(_bold 'gh auth login')"
  fi
  return $rc
}

run_opencode_auth() {
  _section "Step 2 / 3 — OpenCode × GitHub Copilot"
  echo ""
  _info "This connects opencode to GitHub Copilot."
  _info "OpenCode will open an interactive setup — select 'GitHub Copilot' as the provider"
  _info "and follow the browser / device-code flow to sign in."
  echo ""

  if _opencode_authed; then
    _done "A Copilot/GitHub provider entry already exists in the OpenCode config."
    echo ""
    if ! _ask_yn "Run opencode auth login again anyway?"; then
      _skip "opencode auth login"
      return 0
    fi
  fi

  if ! command -v opencode &>/dev/null; then
    _error "opencode is not installed. Skipping."
    return 1
  fi

  echo ""
  _info "Running: $(_bold 'opencode auth login')"
  echo ""
  opencode auth login
  local rc=$?
  echo ""
  if [[ $rc -eq 0 ]]; then
    _done "opencode auth login completed successfully."
  else
    _error "opencode auth login exited with code $rc."
    _info "You can retry later with: $(_bold 'opencode auth login')"
  fi
  return $rc
}

run_claude_auth() {
  _section "Step 3 / 3 — Claude Code CLI authentication"
  echo ""
  _info "This authenticates Claude Code CLI with your Anthropic account."
  _info "Follow the browser or device-code flow to sign in."
  echo ""

  if ! command -v claude &>/dev/null; then
    _error "claude is not installed. Skipping."
    return 1
  fi

  if _claude_authed; then
    _done "Claude Code CLI is already authenticated."
    echo ""
    if ! _ask_yn "Re-authenticate (switch account or refresh token)?"; then
      _skip "claude auth login"
      setup_entire || true
      return 0
    fi
  fi

  echo ""
  _info "Running: claude auth login"
  echo ""
  claude auth login
  local rc=$?
  echo ""
  if [[ $rc -eq 0 ]]; then
    _done "claude auth login completed successfully."
    setup_entire || true
  else
    _error "claude auth login exited with code $rc."
    _info "You can retry later with: claude auth login"
  fi
  return $rc
}

# ── entire setup (issue #5) ───────────────────────────────────────────────────

# Enable Entire hooks for Claude Code right after claude auth succeeds.
setup_entire() {
  _section "Entire CLI — session capture"
  echo ""
  _info "Enabling Entire hooks for Claude Code..."
  echo ""

  if ! command -v entire &>/dev/null; then
    _error "entire is not installed. Skipping."
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    _error "Not inside a git repository. Entire needs a repo; skipping."
    return 1
  fi

  if _ask_yn "Enable Entire (capture AI sessions in this repo)?"; then
    entire enable --agent claude-code
    local rc=$?
    echo ""
    if [[ $rc -eq 0 ]]; then
      _done "Entire enabled for Claude Code."
    else
      _error "entire enable exited with code $rc."
      _info "You can retry later with: entire enable --agent claude-code"
    fi
    return $rc
  else
    _skip "entire enable"
    return 0
  fi
}

# ── summary ───────────────────────────────────────────────────────────────────

print_summary() {
  echo ""
  echo "================================================================================"
  echo "ONBOARDING SUMMARY"
  echo "================================================================================"
  echo ""

  if _gh_authed; then
    _done "gh / git authenticated"
  else
    _pending "gh / git not authenticated — run: gh auth login"
  fi

  if _opencode_authed; then
    _done "opencode Copilot provider configured"
  else
    _pending "opencode not configured — run: opencode auth login"
  fi

  if _claude_authed; then
    _done "claude Code CLI authenticated"
  else
    _pending "claude not authenticated — run: claude auth login"
  fi

  if command -v entire &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null && entire status &>/dev/null 2>&1; then
    _done "entire enabled (checkpoints → cedanl/entire-checkpoints)"
  else
    _pending "entire not enabled — will auto-enable on first: claude"
  fi
}

# ── main ──────────────────────────────────────────────────────────────────────

main() {
  clear
  echo ""
  echo "================================================================================"
  echo "DEV-DOTS ONBOARDING WIZARD"
  echo "================================================================================"
  echo ""
  echo "Welcome! This wizard walks you through the three authentication steps"
  echo "needed after each fresh container build."
  echo ""

  # Quick pre-flight status
  echo "Current status:"
  if _gh_authed;       then _done "gh auth login";   else _pending "gh auth login"; fi
  if _opencode_authed; then _done "opencode auth login"; else _pending "opencode auth login"; fi
  if _claude_authed;   then _done "claude auth login"; else _pending "claude auth login"; fi
  echo ""

  if _ask_yn "Run the wizard now?"; then
    echo ""

    # Step 1
    run_gh_auth || true

    # Step 2
    run_opencode_auth || true

    # Step 3
    run_claude_auth || true

    print_summary
    echo ""
    echo "All done! Run 'onboard' at any time to re-run individual steps."
    echo ""
  else
    echo ""
    echo "Skipped. Run 'onboard' at any time to start the wizard."
    echo ""
  fi
}

main "$@"
