#!/usr/bin/env bash
set -Eeuo pipefail

_git_status_dirty() {
  dirty=$(git status -s 2> /dev/null | tail -n 1)
  [[ -n $dirty ]] && echo " ●"
}

_git_stash_dirty() {
  stash=$(git stash list 2> /dev/null | tail -n 1)
  [[ -n $stash ]] && echo " ⚑"
}

git_status() {
  typeset ref dirty stash run_pwd
  run_pwd="$(pwd)" \
    && cd "${PROGDIR}"
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    dirty=$(_git_status_dirty)
    stash=$(_git_stash_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) \
      || ref="➦ $(git describe --exact-match --tags HEAD 2> /dev/null)" \
      || ref="➦ $(git show-ref --head -s --abbrev | head -n1 2> /dev/null)"
    echo "${ref/refs\/heads\// }${stash}${dirty}"
  fi
  cd "${run_pwd}"
}

git_repo() {
  typeset run_pwd
  run_pwd="$(pwd)" \
    && cd "${PROGDIR}"
  git remote get-url origin \
    2> /dev/null \
    || true
  cd "${run_pwd}"
}
