#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_BASE_FOLDER_PATH=$(dirname "$SCRIPT_PATH")
ROOT_PATH=$(dirname "$SCRIPTS_BASE_FOLDER_PATH")

actionlint_version="$(sh "$SCRIPTS_BASE_FOLDER_PATH/get-tool-version.sh" "actionlint")"
pre_commit_version="$(sh "$SCRIPTS_BASE_FOLDER_PATH/get-tool-version.sh" "pre-commit")"
hadolint_version="$(sh "$SCRIPTS_BASE_FOLDER_PATH/get-tool-version.sh" "hadolint")"

now=$(date '+%Y%m%d%H%M%S')

podman build \
  --tag "pre-commit-container:$now" \
  --tag "pre-commit-container:latest" \
  --build-arg "ACTIONLINT_VERSION=$actionlint_version" \
  --build-arg "PRE_COMMIT_VERSION=$pre_commit_version" \
  --build-arg "HADOLINT_VERSION=$hadolint_version" \
  --file "$ROOT_PATH/Dockerfile" \
  .
