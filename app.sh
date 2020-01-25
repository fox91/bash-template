#!/usr/bin/env bash
set -Eeuo pipefail

[ -z ${PROGNAME-} ] && readonly PROGNAME=$(basename $0)
[ -z ${PROGDIR-} ] && readonly PROGDIR=$(readlink -m $(dirname $0))

source "${PROGDIR}"/utils-common.sh
source "${PROGDIR}"/utils-logs.sh
source "${PROGDIR}"/utils-git.sh

my_function() {
  log_debug "  ${FUNCNAME}"
  # TODO
}

exec_my_app() {
  log_debug "  ${FUNCNAME}"
  my_function
}

test_logs() {
  log_debug "  ${FUNCNAME}"

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
  log_info "  ${FUNCNAME}"
  log_debug "    ${$}, ${BASHPID}"

  echo "Foo"
}

_main() {
  log_info "START ${PROGNAME}:${FUNCNAME} - DT:$(dateum)"
  log_info "  git repo: '$(git_status)'"
  # log "  args: [${1}, ${2}]"
  exec_my_app

  test_logs

  test_return_value
  local result=$(test_return_value)

  log_debug "  result: '${result}'"
  log_info "END   ${PROGNAME}:${FUNCNAME} - DT:$(dateum)"
}

if ! is_sourced; then
  _main "$@"
fi
