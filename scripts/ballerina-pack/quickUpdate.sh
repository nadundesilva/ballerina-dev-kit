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

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/init.sh"

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

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/cleanup.sh"
