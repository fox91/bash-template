#!/usr/bin/env bash
set -Eeuo pipefail

_cpu_sockets() {
  lscpu \
    | grep 'Socket(s)' \
    | sed -E 's/^Socket\(s\):\ +//' \
    || true
}

_cpu_num_threads() {
  lscpu \
    | grep 'Thread(s) per core' \
    | sed -E 's/^Thread\(s\)\ per\ core:\ +//' \
    || true
}

_cpu_num_cores() {
  lscpu \
    | grep 'Core(s) per socket' \
    | sed -E 's/^Core\(s\)\ per\ socket:\ +//' \
    || true
}

_cpu_vendor() {
  lscpu \
    | grep 'Vendor ID' \
    | sed -E 's/^Vendor\ ID:\ +//' \
    | grep -v 'AuthenticAMD' \
    | grep -v 'GenuineIntel' \
    || true
}

_cpu_model_name() {
  lscpu \
    | grep 'Model name' \
    | sed -E \
      -e 's/^Model\ name:\ +//' \
      -e 's/@\ ([0-9])/@\1/' \
    | sed \
      -e 's/(R)/®/g' \
      -e 's/(TM)/™/g' \
    || true
}

cpu_info() {
  typeset cpu_vendor
  cpu_vendor=$(_cpu_vendor)
  if [[ ${cpu_vendor} != '' ]]; then
    cpu_vendor="${cpu_vendor} "
  fi

  echo "$(_cpu_sockets)x $(_cpu_num_threads)T$(_cpu_num_cores)C ($(nproc)PU), ${cpu_vendor}$(_cpu_model_name)"
}

os_release() {
  if command -v lsb_release &> /dev/null; then
    lsb_release -ds
  elif [[ -f "/etc/os-release" ]]; then
    grep 'PRETTY_NAME=' /etc/os-release \
      | sed -e 's/^PRETTY_NAME=//' -e 's/"//g' \
      || true
  elif [[ -f "/etc/redhat-release" ]]; then
    cat /etc/redhat-release
  fi
}
