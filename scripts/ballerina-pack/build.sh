#!/usr/bin/env bash

set -e

USE_BUILD_CACHE=${USE_BUILD_CACHE:-"false"}

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/../utils.sh"

pushd "${DEV_BALLERINA_LANG_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Lang)"
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  ./gradlew clean build --stacktrace -x test -x check -x :jballerina-tools:generateDocs
else
  ./gradlew clean build --stacktrace -x test -x check -x :jballerina-tools:generateDocs --no-build-cache
fi
echo "Running Gradle Publish to Maven Local (Ballerina Lang)"
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  ./gradlew publishToMavenLocal --stacktrace -x test -x check
else
  ./gradlew publishToMavenLocal --stacktrace -x test -x check --no-build-cache
fi
echo
popd || exit 1

echo "Running Gradle Build (Ballerina Distribution)"
pushd "${DEV_BALLERINA_DISTRIBUTION_REPO}" || exit 1
echo
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  ./gradlew clean build --stacktrace \
    -x testExamples -x testStdlibs -x testDevTools -x :ballerina-distribution-test:test \
    -x :devtools-integration-tests:test
else
  ./gradlew clean build --stacktrace --no-build-cache \
    -x testExamples -x testStdlibs -x testDevTools -x :ballerina-distribution-test:test \
    -x :devtools-integration-tests:test
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

# shellcheck source=./unzipPack.sh
bash "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/unzipPack.sh"

echo "Building Ballerina Pack Complete"
printBallerinaPackInfo
