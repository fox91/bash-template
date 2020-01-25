#!/usr/bin/env bash
set -Eeuo pipefail

[ -z ${PROGNAME-} ] && readonly PROGNAME=$(basename $0)
[ -z ${PROGDIR-} ] && readonly PROGDIR=$(readlink -m $(dirname $0))

source "${PROGDIR}"/utils-common.sh
source "${PROGDIR}"/utils-logs.sh
source "${PROGDIR}"/utils-lock.sh
source "${PROGDIR}"/app.sh

my_function() {
  log_debug "  ${FUNCNAME} (custom)"
  # TODO
}

exec_some_code() {
  log_debug "  ${FUNCNAME}"
  # TODO
}

_main() {
  lock $PROGNAME \
    || eexit "Only one instance of $PROGNAME can run at one time."

  log_info "START ${PROGNAME}:${FUNCNAME}(${0})"
  # log "  args: [${1}, ${2}]"
  exec_my_app
  exec_some_code
  log_info "END   ${PROGNAME}:${FUNCNAME}"
}

if ! is_sourced; then
  _main "$@"
fi
