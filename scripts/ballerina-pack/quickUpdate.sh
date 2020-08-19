#!/usr/bin/env bash

set -e

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../utils.sh"

if [ ! -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Unable to update: Ballerina Pack ${DEV_BALLERINA_PACK} not found"
  exit 1
fi

echo "🔨🔨Updating Ballerina Pack directly"
export BAL_HOME="${DEV_BALLERINA_PACK}"
runBallerinaLangGradleBuild :jballerina-tools:updateBalHome \
  -x :build-config:checkstyle:downloadFile \
  -x check \
  -x test

echo "Updating Ballerina Pack Complete"
printBallerinaPackInfo
