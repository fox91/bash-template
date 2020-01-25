#!/usr/bin/env bash
set -Eeuo pipefail

dateu() {
  date -u +"%Y%m%dT%H%M%SZ"
}

dateum() {
  date -u +"%Y%m%dT%H%M%S.%3NZ"
}

timeu() {
  date -u +"%H:%M:%S.%3N"
}

# check to see if this file is being run or sourced from another script
is_sourced() {
  # https://unix.stackexchange.com/a/215279
  [ "${#FUNCNAME[@]}" -ge 2 ] \
    && [ "${FUNCNAME[0]}" = 'is_sourced' ] \
    && [ "${FUNCNAME[1]}" = 'source' ]
}
