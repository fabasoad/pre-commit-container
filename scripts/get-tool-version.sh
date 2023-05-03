#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_BASE_FOLDER_PATH=$(dirname "$SCRIPT_PATH")
ROOT_PATH=$(dirname "$SCRIPTS_BASE_FOLDER_PATH")

grep -Eo "$1 [0-9.pre-]+" "$ROOT_PATH/.tool-versions" | cut -d ' ' -f 2
