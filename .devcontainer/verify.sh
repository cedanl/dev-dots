# sha256 helpers for Dockerfile download steps. Sourced (not executed) after /etc/arch_vars,
# so it must stay POSIX sh (the Dockerfile RUN shell is dash).
#
#   sha_in_list <url> <filename>   hash of <filename> from a "<hash>  <name>" list (sha256sum
#                                  format, binary-mode "*name" also accepted)
#   sha_single  <url>              first field of a one-line .sha256 file
#   verify_sha256 <file> <hash>    fails the build on an empty or mismatching hash
#
# The checksum comes from the publisher's own release, so this catches truncated, corrupt or
# swapped artifacts (e.g. a mirror/CDN mix-up); it is not a substitute for signature checks.
sha_in_list() {
    curl -fsSL "$1" | awk -v f="$2" '{ n = $2; sub(/^\*/, "", n); if (n == f) { print $1; exit } }'
}

sha_single() {
    curl -fsSL "$1" | awk '{ print $1; exit }'
}

verify_sha256() {
    if [ -z "${2:-}" ]; then
        echo "ERROR: no published checksum found for $1" >&2
        return 1
    fi
    echo "$2  $1" | sha256sum -c -
}
