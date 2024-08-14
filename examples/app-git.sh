#!/usr/bin/env bash
set -Eeuo pipefail

typeset _progname _progdir
_progname=$(basename "$0")
_progdir=$(readlink -m "$(dirname "$0")")
[ -z "${PROGNAME-}" ] && typeset -r PROGNAME="${_progname}"
[ -z "${PROGDIR-}" ] && typeset -r PROGDIR="${_progdir}"
unset _progname _progdir

source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/../utils-common.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/../utils-logs.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/../utils-git.sh

_main() {
  log_info "START ${PROGNAME}:${FUNCNAME[0]} - DT:$(dateum)"
  log_debug "  git: '$(git_status)' ($(git_repo))"
  log_info "END   ${PROGNAME}:${FUNCNAME[0]} - DT:$(dateum)"
}

if ! is_sourced; then
  _main "$@"
fi
