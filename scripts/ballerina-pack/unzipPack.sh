#!/usr/bin/env bash

set -e

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

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
