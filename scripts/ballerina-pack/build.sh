#!/usr/bin/env bash

set -e

USE_BUILD_CACHE=${USE_BUILD_CACHE:-"false"}

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

pushd "${DEV_BALLERINA_LANG_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Lang)"
DEV_BALLERINA_LANG_BUILD_ARGS=(clean build --stacktrace -x test -x check -x :jballerina-tools:generateDocs)
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  DEV_BALLERINA_LANG_BUILD_ARGS+=(--no-build-cache)
fi
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_LANG_BUILD_ARGS[@]}"
echo "Running Gradle Publish to Maven Local (Ballerina Lang)"
DEV_BALLERINA_LANG_PUBLISH_ARGS=(publishToMavenLocal --stacktrace -x test -x check)
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  DEV_BALLERINA_LANG_PUBLISH_ARGS+=(--no-build-cache)
fi
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_LANG_PUBLISH_ARGS[@]}"
echo
popd || exit 1

pushd "${DEV_BALLERINA_DISTRIBUTION_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Distribution)"
DEV_BALLERINA_DISTRIBUTION_BUILD_ARGS=(clean build --stacktrace
    -x testExamples -x testStdlibs -x testDevTools -x :ballerina-distribution-test:test \
    -x :devtools-integration-tests:test)
if [[ "${USE_BUILD_CACHE}" == "true" ]]; then
  DEV_BALLERINA_DISTRIBUTION_BUILD_ARGS+=(--no-build-cache)
fi
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_DISTRIBUTION_BUILD_ARGS[@]}"
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
bash "${DEV_BALLERINA_SCRIPTS_DIR}/ballerina-pack/unzipPack.sh"

echo "Building Ballerina Pack Complete"
printBallerinaPackInfo
