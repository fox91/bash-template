#!/usr/bin/env bash
set -Eeuo pipefail

source "$(readlink -m "$(dirname "${BASH_SOURCE[0]}")")"/utils-logs.sh

log_info "## shell ## shfmt ##"
docker run -it --rm -v "$(pwd)":/code:ro -w /code -u "$(id -u)":"$(id -g)" mvdan/shfmt:latest-alpine \
  sh -c "find ./ -type f -name '*.sh' -print0 | xargs -0 -n1 -P4 -- shfmt -d"

log_info "## shell ## shellcheck ##"
docker run -it --rm -v "$(pwd)":/code:ro -w /code -u "$(id -u)":"$(id -g)" koalaman/shellcheck-alpine:stable \
  sh -c "find ./ -type f -name '*.sh' -print0 | xargs -0 -n1 -P4 -- shellcheck -C -S warning -x"
