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

REPO_DIR="${1}"
if [[ "${REPO_DIR}" == "" ]]; then
  REPO_DIR="${PWD}"
fi

# Dropping standard library specific gradle tasks
DEV_BALLERINA_STDLIBS_BUILD_ARGS=(clean build publishToMavenLocal --stacktrace --info --scan --console=plain -x test)
STDLIBS_MODULE_NAME="${PWD##*/}"
if [[ "${STDLIBS_MODULE_NAME}" == "module-ballerina-auth" ]]; then
  DEV_BALLERINA_STDLIBS_BUILD_ARGS+=(-x startLdapServer -x stopLdapServer)
elif [[ "${STDLIBS_MODULE_NAME}" == "module-ballerina-jwt" ]]; then
  DEV_BALLERINA_STDLIBS_BUILD_ARGS+=(-x startBallerinaSTS -x stopBallerinaSTS)
elif [[ "${STDLIBS_MODULE_NAME}" == "module-ballerina-oauth2" ]]; then
  DEV_BALLERINA_STDLIBS_BUILD_ARGS+=(-x startBallerinaSTS -x stopBallerinaSTS -x startWso2IS -x stopWso2IS)
elif [[ "${STDLIBS_MODULE_NAME}" == "module-ballerina-grpc" ]]; then
  DEV_BALLERINA_STDLIBS_BUILD_ARGS+=(-x startLdapServer -x stopLdapServer -x startGoServer -x stopGoServer)
fi

# Skipping modules which are have issues in gradle build scripts
if [[ "${STDLIBS_MODULE_NAME}" == "module-ballerina-grpc" ]]; then
  echo "Skipping GRPC module due to issue in building"
  exit 0
fi

echo
echo "Building Standard Library Repository: ${STDLIBS_MODULE_NAME}"
pushd "${REPO_DIR}" || exit 1
"./${DEV_BALLERINA_GRADLE_WRAPPER}" "${DEV_BALLERINA_STDLIBS_BUILD_ARGS[@]}"
popd || exit 1
