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
DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT=1
DEV_BALLERINA_PROJECT_NAME="$1"

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/init.sh"

DEV_BALLERINA_PROJECT_PATH="${DEV_BALLERINA_ROOT_DIR}/projects/${DEV_BALLERINA_PROJECT_NAME}"

if [ ! -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Ballerina Pack: ${DEV_BALLERINA_PACK} not found"
  bash "${DEV_BALLERINA_ROOT_DIR}/scripts/ballerina-pack/build.sh"
fi

DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE=$(readAbsolutePath "./ballerina-internal.log")
if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "Removing Internal Log File ${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
  rm -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

DEV_BALLERINA_PROJECT_TARGET_DIR=$(readAbsolutePath "./target")
if [ -d "${DEV_BALLERINA_PROJECT_TARGET_DIR}" ]; then
  echo "Removing Build Directory ${DEV_BALLERINA_PROJECT_TARGET_DIR}"
  rm -rf "${DEV_BALLERINA_PROJECT_TARGET_DIR}"
fi

echo "Building Ballerina Project ${DEV_BALLERINA_PROJECT_PATH}"
echo
"${DEV_BALLERINA_EXECUTABLE}" build "${@:$((DEV_BALLERINA_CURRENT_SCRIPT_MAIN_PARAMS_COUNT + 1))}" "${DEV_BALLERINA_PROJECT_PATH}"
echo

if [ -f "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}" ]; then
  echo "=============================="
  echo " Ballerina Build Internal Log "
  echo "=============================="
  echo
  cat "${DEV_BALLERINA_PROJECT_INTERNAL_LOG_FILE}"
fi

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/cleanup.sh"
