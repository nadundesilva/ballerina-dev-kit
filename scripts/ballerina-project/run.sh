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

# Main Params
DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT=2
DEV_BALLERINA_PROJECT_NAME="$1"

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

pushd "${DEV_BALLERINA_ROOT_DIR}/projects/${DEV_BALLERINA_PROJECT_NAME}" || exit 1

DEV_BALLERINA_PROJECT_BUILD_JAR=$(readAbsolutePath ".")/target/bin/${DEV_BALLERINA_PROJECT_NAME}.jar

if [ ! -f "${DEV_BALLERINA_PROJECT_BUILD_JAR}" ]; then
  echo "Ballerina build Jar: ${DEV_BALLERINA_PROJECT_BUILD_JAR} not found"
  bash "${DEV_BALLERINA_ROOT_DIR}/scripts/ballerina-project/build.sh" "${DEV_BALLERINA_PROJECT_NAME}"
fi

DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE=$(readAbsolutePath "./ballerina-internal.log")
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
