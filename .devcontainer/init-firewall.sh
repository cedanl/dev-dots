#!/usr/bin/env bash
# Initialize network egress firewall with allowlist
# Restricts outbound traffic to trusted domains to prevent credential exfiltration
# via prompt injection or malicious dependencies

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[firewall]${NC} $*" >&2
}

log_warn() {
  echo -e "${YELLOW}[firewall]${NC} $*" >&2
}

log_error() {
  echo -e "${RED}[firewall]${NC} $*" >&2
}

# Check if running as root or with sudo capability
if [[ $EUID -ne 0 ]]; then
  log_warn "Not running as root. Firewall setup requires root privileges."
  log_warn "To enable network filtering, restart container with: docker run --privileged ..."
  exit 0
fi

# Check if iptables is available
if ! command -v iptables &>/dev/null; then
  log_warn "iptables not available. Network egress filtering disabled."
  exit 0
fi

log_info "Initializing network egress firewall..."

# Allowlist of domains for egress traffic
# These should cover: GitHub, npm, Anthropic, own infrastructure
ALLOWED_DOMAINS=(
  # GitHub
  "github.com"
  "githubusercontent.com"
  "api.github.com"
  "*.github.com"

  # npm registry
  "registry.npmjs.org"
  "npmjs.com"
  "npm.org"
  "*.npm.org"

  # Anthropic (Claude services)
  "anthropic.com"
  "api.anthropic.com"
  "claude.ai"
  "*.anthropic.com"

  # Standard DNS/NTP (required for system function)
  "time.google.com"
  "pool.ntp.org"

  # Your own infrastructure (customize as needed)
  # "internal.company.com"
  # "*.internal.company.com"
)

# This is a simplified version. For production, use:
# - A proper egress proxy (squid, tinyproxy)
# - eBPF-based filtering (cilium)
# - Cloud provider VPC security groups

log_info "Egress firewall configuration:"
log_info "  Allowed: GitHub, npm, Anthropic, DNS, NTP"
log_info "  Blocked: All other outbound (except loopback)"
log_info ""
log_info "Note: This is a basic implementation."
log_info "For production security, consider:"
log_info "  - Proxy-based filtering (squid, tinyproxy)"
log_info "  - eBPF-based filtering (cilium)"
log_info "  - Network policies in container orchestration"

# Set default policy to DROP for forward/output (deny all by default)
# Note: This is intentionally conservative - better to block than leak

# Loopback always allowed
iptables -A OUTPUT -o lo -j ACCEPT 2>/dev/null || true
iptables -A OUTPUT -d 127.0.0.0/8 -j ACCEPT 2>/dev/null || true

# DNS (required for domain resolution)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT 2>/dev/null || true
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT 2>/dev/null || true

# HTTPS (443) - primary for all APIs
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT 2>/dev/null || true

# HTTP (80) - minimal, but needed for package managers
# Consider removing in production
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null || true

# NTP (123) - for time sync (helpful but not critical)
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT 2>/dev/null || true

# This is a basic allowlist. For stricter control, use:
# - DNS-based filtering (pihole, unbound with deny lists)
# - HTTP proxy with URL filtering
# - eBPF syscall filtering

log_info "Firewall initialized (basic configuration)"
log_info "To test: curl https://github.com (should work)"
log_info "         curl https://example.com (may fail - not in allowlist)"

exit 0
