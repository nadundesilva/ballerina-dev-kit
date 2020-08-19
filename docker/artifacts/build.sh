#!/usr/bin/env bash

set -e

DEV_BALLERINA_CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd "${DEV_BALLERINA_CURRENT_SCRIPT_DIR}/repos/wso2/performance-common"
mvn clean install -Dmaven.test.skip=true
popd
