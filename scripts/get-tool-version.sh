#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPTS_DIR_PATH=$(dirname "${SCRIPT_PATH}")
ROOT_PATH=$(dirname "${SCRIPTS_DIR_PATH}")

cut_f=""
tool=""
while getopts "v:t:" arg; do
  case $arg in
    v)
      if [ "$OPTARG" = "major" ]; then
        cut_f="1"
      elif [ "$OPTARG" = "minor" ]; then
        cut_f="1,2"
      elif [ "$OPTARG" = "patch" ]; then
        cut_f="1,2,3"
      else
        echo "$OPTARG is not valid. Possible values: major, minor, patch"
        exit 1
      fi
      ;;
    t) tool=$OPTARG;;
    *) break;;
  esac
done

if [ -z "${tool}" ]; then
  echo "Not tool specified"
  exit 1
fi

asdf_file=".tool-versions"
requirements_file="requirements.txt"

# try to read .tool-versions file first
version=$(grep -Eo "${tool} [0-9.pre-]+" "${ROOT_PATH}/${asdf_file}" | cut -d ' ' -f 2)

if [ -z "${version}" ]; then
  # if tool is not present in .tool-versions file then try to read requirements.txt
  version=$(grep -Eo "${tool}==[0-9.pre-]+" "${ROOT_PATH}/${requirements_file}" | cut -d '=' -f 3)
fi

if [ -z "${version}" ]; then
  echo "${tool} is not present neither in ${asdf_file} nor in ${requirements_file}"
  exit 1
fi

if [ -z "${cut_f}" ]; then
  echo "${version}"
else
  echo "${version}" | cut -d '.' -f "${cut_f}"
fi
