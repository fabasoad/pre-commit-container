#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_DIR_PATH=$(dirname "${SCRIPT_PATH}")
ROOT_PATH=$(dirname "${SCRIPTS_DIR_PATH}")
LIB_DIR_PATH="${SCRIPTS_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

cp "${ROOT_PATH}/.tool-versions" "${ROOT_PATH}/.tool-versions.bak"
while read -r p; do
  tool=$(echo "${p}" | cut -d ' ' -f 1)
  current_version=$(echo "${p}" | cut -d ' ' -f 2)
  latest_version=$(asdf latest "${tool}")
  if [ "${current_version}" = "${latest_version}" ]; then
    log_info "${tool} ${latest_version} is already installed"
  else
    sed -i.bak -E "s/(${tool} )[0-9.pre-]+(.*)/\1${latest_version}\2/g" "${ROOT_PATH}/.tool-versions.bak"
    asdf install "${tool}" "${latest_version}"
  fi
done <"${ROOT_PATH}/.tool-versions"
mv -f "${ROOT_PATH}/.tool-versions.bak" "${ROOT_PATH}/.tool-versions"
rm -f "${ROOT_PATH}/.tool-versions.bak*"
