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

if [ -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Removing previous Ballerina Pack ${DEV_BALLERINA_PACK}"
  rm -rf "${DEV_BALLERINA_PACK}"
fi

DEV_BALLERINA_PACK_ZIP=${DEV_BALLERINA_PACK}.zip
BALLERINA_PACK_DIR=$(dirname "${DEV_BALLERINA_PACK}")
echo "Unzipping new Ballerina Pack to ${BALLERINA_PACK_DIR}/${DEV_BALLERINA_PACK_NAME}"
unzip "${DEV_BALLERINA_PACK_ZIP}" -d "${BALLERINA_PACK_DIR}" > /dev/null
sudo chmod -R 777 "${DEV_BALLERINA_EXECUTABLE}"

#
# Removing Unwanted Files
#

if [[ "$OSTYPE" == "darwin"* ]]; then
  DEV_BALLERINA_PACK_JAVA_PACK="${DEV_BALLERINA_PACK}/dependencies/jdk-11.0.8+10-jre"
  if test -d "${DEV_BALLERINA_PACK_JAVA_PACK}"; then
    echo "Removing Packaged Java Pack ${DEV_BALLERINA_PACK_JAVA_PACK}"
    rm -rf "${DEV_BALLERINA_PACK_JAVA_PACK}"
  fi
fi

AZURE_FUNCTIONS_PLUGIN_JAR=${BALLERINA_PACK_DIR}/${DEV_BALLERINA_PACK_NAME}/distributions/ballerina-${DEV_BALLERINA_SHORT_VERSION}/bre/lib/azurefunctions-extension-${DEV_BALLERINA_PROJECT_VERSION}.jar
if [ -f "${AZURE_FUNCTIONS_PLUGIN_JAR}" ]; then
  echo "Removing Azure Functions Plugin ${AZURE_FUNCTIONS_PLUGIN_JAR}"
  rm "${AZURE_FUNCTIONS_PLUGIN_JAR}"
fi
