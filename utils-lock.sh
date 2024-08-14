#!/usr/bin/env bash
set -Eeuo pipefail

typeset -r LOCKFILE_DIR=/tmp
typeset -r LOCK_FD=200

lock() {
  typeset prefix
  prefix=$(basename "${1}" .sh)
  typeset fd=${2:-$LOCK_FD}
  typeset lock_file="${LOCKFILE_DIR}/$prefix.lock"

  # create lock file
  eval "exec ${fd}> ${lock_file}"

  # acquier the lock
  flock -n "${fd}" \
    && return 0 \
    || return 1
}

eexit() {
  typeset error_str="$*"

  echo "${error_str}"
  exit 1
}
