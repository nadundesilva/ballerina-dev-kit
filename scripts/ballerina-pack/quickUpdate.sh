#!/usr/bin/env bash

set -e

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

if [ ! -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Unable to update: Ballerina Pack ${DEV_BALLERINA_PACK} not found"
  exit 1
fi

echo "Running Gradle Update Bal Home (Ballerina Lang)"
export BAL_HOME="${DEV_BALLERINA_PACK}"
pushd "${DEV_BALLERINA_LANG_REPO}" || exit 1
echo
"./${DEV_BALLERINA_GRADLE_WRAPPER}" :jballerina-tools:updateBalHome -x test -x check
echo
popd || exit 1

echo "Updating Ballerina Pack Complete"
printBallerinaPackInfo
