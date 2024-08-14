#!/usr/bin/env bash
set -Eeuo pipefail

typeset _progname _progdir
_progname=$(basename "$0")
_progdir=$(readlink -m "$(dirname "$0")")
[ -z "${PROGNAME-}" ] && typeset -r PROGNAME="${_progname}"
[ -z "${PROGDIR-}" ] && typeset -r PROGDIR="${_progdir}"
unset _progname _progdir

source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/../utils-lock.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/app.sh

my_function() {
  log_debug "  ${FUNCNAME[0]} (custom)"
  # TODO
}

exec_some_code() {
  log_debug "  ${FUNCNAME[0]}"

  sleep 5
}

_main() {
  lock "${PROGNAME}" \
    || eexit "Only one instance of ${PROGNAME} can run at one time."

  log_info "START ${PROGNAME}:${FUNCNAME[0]}(${0})"
  log_debug "  os:  '$(os_release)'"
  log_debug "  cpu: '$(cpu_info)'"
  log_debug "  git: '$(git_status)' ($(git_repo))"
  # log "  args: [${1}, ${2}]"

  exec_my_app

  exec_some_code

  log_info "END   ${PROGNAME}:${FUNCNAME[0]}"
}

if ! is_sourced; then
  _main "$@"
fi
