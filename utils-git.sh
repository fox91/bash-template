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
  typeset ref dirty mode stash run_pwd repo_path pl_branch_char
  mode=''
  pl_branch_char=$'\ue0a0' # 
  run_pwd="$(pwd)" \
    && cd "${PROGDIR}"
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    repo_path=$(command git rev-parse --git-dir 2> /dev/null)

    dirty=$(_git_status_dirty)
    stash=$(_git_stash_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) \
      || ref="◈ $(git describe --exact-match --tags HEAD 2> /dev/null)" \
      || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

    local ahead behind
    ahead=$(git log --oneline "@{upstream}.." 2> /dev/null)
    behind=$(git log --oneline "..@{upstream}" 2> /dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      pl_branch_char=$'\u21c5' # ⇅
    elif [[ -n "$ahead" ]]; then
      pl_branch_char=$'\u21b1' # ↱
    elif [[ -n "$behind" ]]; then
      pl_branch_char=$'\u21b0' # ↰
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    echo "${ref/refs\/heads\//$pl_branch_char }${stash}${dirty}${mode}"
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
