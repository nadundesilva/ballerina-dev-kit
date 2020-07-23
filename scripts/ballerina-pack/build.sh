#!/usr/bin/env bash

source "../properties.sh"
source "../utils.sh"

echo "Building Ballerina Repo"
runBallerinaLangGradleBuild clean build \
  -x :build-config:checkstyle:downloadFile \
  -x check \
  -x test \
  "$@"

DEV_BALLERINA_PACK_ZIP=${DEV_BALLERINA_PACK}.zip
echo "Removing previous Ballerina Pack zip ${DEV_BALLERINA_PACK_ZIP}"
rm -f "${DEV_BALLERINA_PACK_ZIP}"

echo "Copying new Ballerina Pack zip to ${DEV_BALLERINA_PACK_ZIP}"
cp  "${DEV_BALLERINA_REPO}/distribution/zip/jballerina-tools/build/distributions/${DEV_BALLERINA_PACK_NAME}.zip" "${DEV_BALLERINA_PACK_ZIP}"

echo "Removing previous Ballerina Pack ${DEV_BALLERINA_PACK}"
rm -rf "${DEV_BALLERINA_PACK}"

BALLERINA_PACK_DIR=$(dirname "${DEV_BALLERINA_PACK}")
echo "Unzipping new Ballerina Pack to ${BALLERINA_PACK_DIR}/${DEV_BALLERINA_PACK_NAME}"
unzip "${DEV_BALLERINA_PACK_ZIP}" -d "${BALLERINA_PACK_DIR}" > /dev/null

echo "Updating Ballerina Pack Complete"
printBallerinaPackInfo
