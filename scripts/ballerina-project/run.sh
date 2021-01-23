#!/usr/bin/env bash

set -e

# Main Params
DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT=2
DEV_BALLERINA_PROJECT_NAME="$1"

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../utils.sh"

pushd "${DEV_BALLERINA_ROOT_DIR}/projects/${DEV_BALLERINA_PROJECT_NAME}" || exit 1

DEV_BALLERINA_PROJECT_BUILD_JAR=$(realpath ".")/target/bin/${DEV_BALLERINA_PROJECT_NAME}.jar

if [ ! -f "${DEV_BALLERINA_PROJECT_BUILD_JAR}" ]; then
  echo "Ballerina build Jar: ${DEV_BALLERINA_PROJECT_BUILD_JAR} not found"
  bash "${DEV_BALLERINA_ROOT_DIR}/scripts/ballerina-project/build.sh" "${DEV_BALLERINA_PROJECT_NAME}"
fi

DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE=$(realpath "./ballerina-internal.log")
if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "Removing Internal Log File ${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
  rm -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

echo "Running Ballerina Module ${DEV_BALLERINA_PROJECT_NAME} in Project ${DEV_BALLERINA_PROJECT_NAME}"
echo
java -jar "${@:$((DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT + 1))}" "${DEV_BALLERINA_PROJECT_BUILD_JAR}"
echo

if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "============================"
  echo " Ballerina Run Internal Log "
  echo "============================"
  echo
  cat "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

popd || exit 1
