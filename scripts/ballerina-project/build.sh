#!/usr/bin/env bash

# Main Params
DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT=2
DEV_BALLERINA_PROJECT_NAME="$1"
DEV_BALLERINA_MODULE_NAME="$2"

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../utils.sh"

if [ ! -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Ballerina Pack: ${DEV_BALLERINA_PACK} not found"
  bash "${DEV_BALLERINA_ROOT_DIR}/scripts/ballerina-pack/build.sh"
fi

pushd "${DEV_BALLERINA_ROOT_DIR}/projects/${DEV_BALLERINA_PROJECT_NAME}" || exit 1

DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE=$(realpath "./ballerina-internal.log")
if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "Removing Internal Log File ${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
  rm -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

DEV_BALLERINA_PROJECT_TARGET_DIR=$(realpath "./target")
if [ -d "${DEV_BALLERINA_PROJECT_TARGET_DIR}" ]; then
  echo "Removing Build Directory ${DEV_BALLERINA_PROJECT_TARGET_DIR}"
  rm -rf "${DEV_BALLERINA_PROJECT_TARGET_DIR}"
fi

echo "Building Ballerina Module ${DEV_BALLERINA_MODULE_NAME} in Project ${DEV_BALLERINA_PROJECT_NAME}"
echo
"${DEV_BALLERINA_EXECUTABLE}" build "${@:$((DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT + 1))}" "${DEV_BALLERINA_MODULE_NAME}"
echo

if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "=============================="
  echo " Ballerina Build Internal Log "
  echo "=============================="
  echo
  cat "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

popd || exit 1
