#!/usr/bin/env bash

set -e

USE_BUILD_CACHE=${USE_BUILD_CACHE:-"true"}

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../utils.sh"

pushd "${DEV_BALLERINA_LANG_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Lang)"
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
  ./gradlew clean build --stacktrace --no-build-cache -x test -x check -x :jballerina-tools:generateDocs -x kaitai
else
  ./gradlew clean build --stacktrace -x test -x check -x :jballerina-tools:generateDocs -x kaitai
fi
echo "Running Gradle Publish to Maven Local (Ballerina Lang)"
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
  ./gradlew --no-build-cache publishToMavenLocal -x kaitai
else
  ./gradlew publishToMavenLocal -x kaitai
fi
echo
popd || exit 1

echo "Running Gradle Build (Ballerina Distribution)"
pushd "${DEV_BALLERINA_DISTRIBUTION_REPO}" || exit 1
echo
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
  ./gradlew clean build --stacktrace --no-build-cache -x testExample -x testStdlibs -x :ballerina-distribution-test:test
else
  ./gradlew clean build --stacktrace -x testExample -x testStdlibs -x :ballerina-distribution-test:test
fi
echo
popd || exit 1

DEV_BALLERINA_PACK_ZIP=${DEV_BALLERINA_PACK}.zip
if [ -f "${DEV_BALLERINA_PACK_ZIP}" ]; then
  echo "Removing previous Ballerina Pack zip ${DEV_BALLERINA_PACK_ZIP}"
  rm -f "${DEV_BALLERINA_PACK_ZIP}"
fi

echo "Copying new Ballerina Pack zip to ${DEV_BALLERINA_PACK_ZIP}"
cp  "${DEV_BALLERINA_DISTRIBUTION_REPO}/ballerina/build/distributions/${DEV_BALLERINA_PACK_NAME}.zip" "${DEV_BALLERINA_PACK_ZIP}"

if [ -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Removing previous Ballerina Pack ${DEV_BALLERINA_PACK}"
  rm -rf "${DEV_BALLERINA_PACK}"
fi

BALLERINA_PACK_DIR=$(dirname "${DEV_BALLERINA_PACK}")
echo "Unzipping new Ballerina Pack to ${BALLERINA_PACK_DIR}/${DEV_BALLERINA_PACK_NAME}"
unzip "${DEV_BALLERINA_PACK_ZIP}" -d "${BALLERINA_PACK_DIR}" > /dev/null
sudo chmod -R 777 "${BALLERINA_PACK_DIR}/${DEV_BALLERINA_PACK_NAME}/bin/ballerina"

echo "Updating Ballerina Pack Complete"
printBallerinaPackInfo
