#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_BASE_FOLDER_PATH=$(dirname "${SCRIPT_PATH}")
ROOT_PATH=$(dirname "${SCRIPTS_BASE_FOLDER_PATH}")
SRC_PATH="${ROOT_PATH}/src"

actionlint_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t actionlint)"
hadolint_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t hadolint)"
pre_commit_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t pre-commit)"
terraform_version="$(sh "${SCRIPTS_BASE_FOLDER_PATH}/get-tool-version.sh" -t terraform)"

if command -v podman >/dev/null 2>&1; then
  cmd="podman"
else
  cmd="docker"
fi

case "$(uname -m)" in
  arm64|aarch64)
    platform="linux/arm64/v8"
    ;;
  *)
    platform="linux/amd64"
    ;;
esac

${cmd} build \
  --tag "pre-commit-container:$(date +%s)" \
  --tag "pre-commit-container:latest" \
  --build-arg "ACTIONLINT_VERSION=${actionlint_version}" \
  --build-arg "HADOLINT_VERSION=${hadolint_version}" \
  --build-arg "PRE_COMMIT_VERSION=${pre_commit_version}" \
  --build-arg "TERRAFORM_VERSION=${terraform_version}" \
  --platform "${platform}" \
  --file "${SRC_PATH}/Dockerfile" \
  .
