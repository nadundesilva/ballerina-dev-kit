#!/usr/bin/env bash

source "../properties.sh"
source "../utils.sh"

if [ ! -d "${DEV_BALLERINA_PACK}" ]; then
  echo "Unable to update: Ballerina Pack ${DEV_BALLERINA_PACK} not found"
  exit 1
fi

echo "🔨🔨Updating Ballerina Pack directly"
export BAL_HOME="${DEV_BALLERINA_PACK}"
runBallerinaLangGradleBuild :jballerina-tools:updateBalHome \
  -x :build-config:checkstyle:downloadFile \
  -x check \
  -x test

echo "Updating Ballerina Pack Complete"
printBallerinaPackInfo
