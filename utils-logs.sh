#!/usr/bin/env bash
set -Eeuo pipefail

source "${PROGDIR}"/utils-common.sh

_log() {
  local str="${1}"
  local lvl="${2:-DEBUG}"

  if [[ -t 1 ]]; then
    local color="${3:-\033[0m}"
    local nc='\033[0m' # No Color

    printf "${color}%s [%-7s] %5d - %s${nc}\n" $(timeu) "${lvl}" ${BASHPID} "${str}" >&2
  else
    printf "%s [%-7s] %5d - %s\n" $(timeu) "${lvl}" ${BASHPID} "${str}" >&2
  fi
}

# log with syslog level 0: Emergency (A panic condition)
log_emerg() {
  _log "${1-}" 'EMERG' '\033[1;41m'
}

# log with syslog level 1: Alert (A condition that should be corrected immediately, such as a corrupted system database)
log_alert() {
  _log "${1-}" 'ALERT' '\033[0;41m'
}

# log with syslog level 2: Critical (Hard device errors)
log_crit() {
  _log "${1-}" 'CRIT' '\033[1;31m'
}

# log with syslog level 3: Error
log_err() {
  _log "${1-}" 'ERR' '\033[0;31m'
}

# log with syslog level 4: Warning
log_warning() {
  _log "${1-}" 'WARNING' '\033[1;33m'
}

# log with syslog level 5: Notice (Conditions that are not error conditions, but that may require special handling)
log_notice() {
  _log "${1-}" 'NOTICE' '\033[0;36m'
}

# log with syslog level 6: Informational
log_info() {
  _log "${1-}" 'INFO' '\033[0;90m'
}

# log with syslog level 7: Debug (Messages that contain information normally of use only when debugging a program)
log_debug() {
  _log "${1-}" 'DEBUG' '\033[0;37m'
}
