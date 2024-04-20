#!/usr/bin/env sh

log() {
  prefix="[scripts]"
  level=$1
  msg=$2

  printf "%s %s level=%s %s\n" "$prefix" "$(date +'%Y-%m-%d %T')" "$level" "$msg"
}

log_info() {
  log "info" "$1"
}
