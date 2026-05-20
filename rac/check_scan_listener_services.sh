#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: check_scan_listener_services.sh [--all | --listener <name>...] [--expect <service>...] [--require-all] [--quiet]

Checks which services are registered in one or more SCAN listeners by parsing:
  lsnrctl services <listener_name>

Options:
  --all                 Discover SCAN listener names via `srvctl config scan_listener` (default when no --listener is given)
  --listener <name>     SCAN listener name (repeatable), e.g. LISTENER_SCAN1
  --expect <service>    Service name to verify is registered (repeatable)
  --require-all         Require each expected service to be present in every listener (default: present in at least one)
  --quiet               Suppress service list output (still prints missing services)
  -h, --help            Show this help

Exit codes:
  0  All expected services found (or none expected)
  2  One or more expected services missing
  1  Other error
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

listeners=()
expected=()
require_all=0
quiet=0
auto=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --listener)
      [[ $# -ge 2 ]] || die "--listener requires a value"
      listeners+=("$2")
      shift 2
      ;;
    --expect)
      [[ $# -ge 2 ]] || die "--expect requires a value"
      expected+=("$2")
      shift 2
      ;;
    --require-all)
      require_all=1
      shift
      ;;
    --quiet)
      quiet=1
      shift
      ;;
    --all)
      auto=1
      shift
      ;;
    *)
      die "Unknown argument: $1 (try --help)"
      ;;
  esac
done

if [[ ${#listeners[@]} -eq 0 ]]; then
  auto=1
fi

command -v lsnrctl >/dev/null 2>&1 || die "lsnrctl not found in PATH"

if [[ $auto -eq 1 ]]; then
  command -v srvctl >/dev/null 2>&1 || die "srvctl not found in PATH (use --listener to specify a SCAN listener)"
  mapfile -t discovered < <(srvctl config scan_listener 2>/dev/null | grep -Eo 'LISTENER_SCAN[0-9]+' | sort -u)
  if [[ ${#discovered[@]} -eq 0 ]]; then
    die "Could not discover SCAN listener names via srvctl (use --listener to specify a SCAN listener)"
  fi
  listeners=("${discovered[@]}")
fi

declare -A listener_services=()
declare -A all_services=()

for l in "${listeners[@]}"; do
  services_raw="$(lsnrctl services "$l" 2>/dev/null || true)"
  if ! grep -q '^Service "' <<<"$services_raw"; then
    die "No services found (or listener not reachable): $l"
  fi
  mapfile -t svcs < <(awk -F'"' '/^Service "/ {print $2}' <<<"$services_raw" | sort -u)
  listener_services["$l"]="$(printf '%s\n' "${svcs[@]}")"
  for s in "${svcs[@]}"; do
    all_services["$s"]=1
  done
done

if [[ $quiet -eq 0 ]]; then
  for l in "${listeners[@]}"; do
    echo "== $l =="
    printf '%s\n' "${listener_services[$l]}"
    echo
  done
fi

if [[ ${#expected[@]} -eq 0 ]]; then
  exit 0
fi

missing=0
if [[ $require_all -eq 1 ]]; then
  for l in "${listeners[@]}"; do
    for e in "${expected[@]}"; do
      if ! grep -Fxq "$e" <<<"${listener_services[$l]}"; then
        echo "MISSING in $l: $e" >&2
        missing=1
      fi
    done
  done
else
  for e in "${expected[@]}"; do
    if [[ -z "${all_services[$e]:-}" ]]; then
      echo "MISSING: $e" >&2
      missing=1
    fi
  done
fi

if [[ $missing -eq 1 ]]; then
  exit 2
fi

exit 0
