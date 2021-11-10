#!/usr/bin/env bash
set -Eeuo pipefail

_git_status_dirty() {
  dirty=$(git status -s 2> /dev/null | tail -n 1)
  [[ -n $dirty ]] && echo " ●"
}

git_status() {
  local ref dirty run_pwd
  run_pwd="$(pwd)" \
    && cd "${PROGDIR}"
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(_git_status_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) \
      || ref="➦ $(git describe --exact-match --tags HEAD 2> /dev/null)" \
      || ref="➦ $(git show-ref --head -s --abbrev | head -n1 2> /dev/null)"
    echo "${ref/refs\/heads\// }${dirty}"
  fi
  cd "${run_pwd}"
}

git_repo() {
  local run_pwd
  run_pwd="$(pwd)" \
    && cd "${PROGDIR}"
  git remote get-url origin \
    2>/dev/null \
    || true
  cd "${run_pwd}"
}
