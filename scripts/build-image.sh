#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_BASE_FOLDER_PATH=$(dirname "${SCRIPT_PATH}")
ROOT_PATH=$(dirname "${SCRIPTS_BASE_FOLDER_PATH}")
SRC_PATH="${ROOT_PATH}/src"

actionlint_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t actionlint)"
hadolint_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t hadolint)"
pre_commit_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t pre-commit)"
terraform_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t terraform)"

now="$(date +%s)"

podman build \
  --tag "pre-commit-container:${now}" \
  --tag "pre-commit-container:latest" \
  --build-arg "ACTIONLINT_VERSION=${actionlint_version}" \
  --build-arg "HADOLINT_VERSION=${hadolint_version}" \
  --build-arg "PRE_COMMIT_VERSION=${pre_commit_version}" \
  --build-arg "TERRAFORM_VERSION=${terraform_version}" \
  --file "${SRC_PATH}/$(uname -m).dockerfile" \
  .
