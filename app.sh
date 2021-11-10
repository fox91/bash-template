#!/usr/bin/env bash
set -Eeuo pipefail

[ -z "${PROGNAME-}" ] && typeset -r PROGNAME=$(basename "$0")
[ -z "${PROGDIR-}" ] && typeset -r PROGDIR=$(readlink -m "$(dirname "$0")")

source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/utils-common.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/utils-logs.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/utils-git.sh
source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/utils-info.sh

my_function() {
  log_debug "  ${FUNCNAME[0]}"
  # TODO
}

exec_my_app() {
  log_debug "  ${FUNCNAME[0]}"
  my_function
}

test_logs() {
  log_debug "  ${FUNCNAME[0]}"

  log_emerg "    msg"
  log_alert "    msg"
  log_crit "    msg"
  log_err "    msg"
  log_warning "    msg"
  log_notice "    msg"
  log_info "    msg"
  log_debug "    msg"
}

test_return_value() {
  log_info "  ${FUNCNAME[0]}"
  log_debug "    ${$}, ${BASHPID}"

  echo "Foo"
}

_main() {
  log_info "START ${PROGNAME}:${FUNCNAME[0]} - DT:$(dateum)"
  log_debug "  os:  '$(os_release)'"
  log_debug "  cpu: '$(cpu_info)'"
  log_debug "  git: '$(git_status)' ($(git_repo))"
  # log "  args: [${1}, ${2}]"
  exec_my_app

  test_logs

  test_return_value
  typeset result; result=$(test_return_value)

  log_debug "  result: '${result}'"
  log_info "END   ${PROGNAME}:${FUNCNAME[0]} - DT:$(dateum)"
}

if ! is_sourced; then
  _main "$@"
fi
