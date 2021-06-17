#!/usr/bin/env bash
# Copyright (c) 2021, Ballerina Dev Kit. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

USE_BUILD_CACHE=${USE_BUILD_CACHE:-"false"}

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/init.sh"

pushd "${DEV_BALLERINA_LANG_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Lang)"
DEV_BALLERINA_LANG_BUILD_ARGS=(clean build --stacktrace -x test -x check)
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
  DEV_BALLERINA_LANG_BUILD_ARGS+=(--no-build-cache)
fi
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_LANG_BUILD_ARGS[@]}"
echo "Running Gradle Publish to Maven Local (Ballerina Lang)"
DEV_BALLERINA_LANG_PUBLISH_ARGS=(publishToMavenLocal --stacktrace -x test -x check)
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
  DEV_BALLERINA_LANG_PUBLISH_ARGS+=(--no-build-cache)
fi
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_LANG_PUBLISH_ARGS[@]}"
echo
popd || exit 1

pushd "${DEV_BALLERINA_DISTRIBUTION_REPO}" || exit 1
echo
echo "Running Gradle Build (Ballerina Distribution)"
DEV_BALLERINA_DISTRIBUTION_BUILD_ARGS=(clean build --stacktrace
    -x testExamples -x testStdlibs -x testDevTools -x :ballerina-distribution-test:test -x :central-tests:test \
    -x :devtools-integration-tests:test)
if [[ "${USE_BUILD_CACHE}" == "false" ]]; then
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

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/cleanup.sh"

