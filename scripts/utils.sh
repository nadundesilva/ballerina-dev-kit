#!/usr/bin/env bash

set -e

if [ "${DEV_BALLERINA_UTILS_INITIALIZED}" == "true" ]; then
  return 0
fi

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function printBallerinaPackInfo() {
  echo
  echo "============================"
  echo " Ballerina Pack Information "
  echo "============================"

  "${DEV_BALLERINA_EXECUTABLE}" version
  echo "Ballerina Home: $("${DEV_BALLERINA_EXECUTABLE}" home)"
  echo
}

if [[ "${OSTYPE}" == "linux-gnu"* ]]; then
  # shellcheck source=./utils-linux.sh
  source "${DEV_BALLERINA_SCRIPTS_DIR}/utils-linux.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # shellcheck source=./utils-linux.sh
  source "${DEV_BALLERINA_SCRIPTS_DIR}/utils-macos.sh"
else
  echo "Unsupported OS: ${OSTYPE}"
  exit 1
fi

DEV_BALLERINA_UTILS_INITIALIZED=true
export DEV_BALLERINA_UTILS_INITIALIZED
