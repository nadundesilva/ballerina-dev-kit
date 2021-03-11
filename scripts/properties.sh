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

if [ "${DEV_BALLERINA_PROPERTIES_INITIALIZED}" == "true" ]; then
  return 0
fi

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=./utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

echo
echo "================================="
echo " Ballerina Dev Kit Configuration "
echo "================================="

DEV_BALLERINA_ROOT_DIR="$(readAbsolutePath "${DEV_BALLERINA_SCRIPTS_DIR}/..")"
export DEV_BALLERINA_ROOT_DIR
echo "Ballerina Dev Kit Root Directory: ${DEV_BALLERINA_ROOT_DIR}"

DEV_BALLERINA_REPOS_DIR="${DEV_BALLERINA_ROOT_DIR}/repos"
DEV_BALLERINA_PACKS_DIR="${DEV_BALLERINA_ROOT_DIR}/packs"

DEV_BALLERINA_LANG_REPO="${DEV_BALLERINA_REPOS_DIR}/ballerina-lang"
export DEV_BALLERINA_LANG_REPO
echo "Ballerina Lang Repo: ${DEV_BALLERINA_LANG_REPO}"

DEV_BALLERINA_DISTRIBUTION_REPO="${DEV_BALLERINA_REPOS_DIR}/ballerina-distribution"
export DEV_BALLERINA_DISTRIBUTION_REPO
echo "Ballerina Distribution Repo: ${DEV_BALLERINA_DISTRIBUTION_REPO}"

DEV_BALLERINA_STD_LIB_REPOS="${DEV_BALLERINA_REPOS_DIR}/std-libs"
export DEV_BALLERINA_STD_LIB_REPOS
echo "Ballerina Standard Library Repos: ${DEV_BALLERINA_STD_LIB_REPOS}"

DEV_BALLERINA_VERSION=$(< "${DEV_BALLERINA_DISTRIBUTION_REPO}/gradle.properties" grep "^version=" | cut -d'=' -f2)
export DEV_BALLERINA_VERSION
echo "Ballerina Version: ${DEV_BALLERINA_VERSION}"

DEV_BALLERINA_SHORT_VERSION=$(< "${DEV_BALLERINA_DISTRIBUTION_REPO}/gradle.properties" grep "^shortVersion=" | cut -d'=' -f2)
export DEV_BALLERINA_SHORT_VERSION
echo "Ballerina Short Version: ${DEV_BALLERINA_SHORT_VERSION}"

DEV_BALLERINA_PROJECT_VERSION=$(< "${DEV_BALLERINA_DISTRIBUTION_REPO}/gradle.properties" grep "^ballerinaVersion=" | cut -d'=' -f2)
export DEV_BALLERINA_PROJECT_VERSION
echo "Ballerina Project Version: ${DEV_BALLERINA_PROJECT_VERSION}"

DEV_BALLERINA_PACK_NAME="ballerina-linux-${DEV_BALLERINA_VERSION}"
export DEV_BALLERINA_PACK_NAME
echo "Ballerina Pack Name: ${DEV_BALLERINA_PACK_NAME}"

DEV_BALLERINA_PACK="${DEV_BALLERINA_PACKS_DIR}/${DEV_BALLERINA_PACK_NAME}"
export DEV_BALLERINA_PACK
echo "Ballerina Pack: ${DEV_BALLERINA_PACK}"

DEV_BALLERINA_EXECUTABLE="${DEV_BALLERINA_PACK}/bin/bal"
export DEV_BALLERINA_EXECUTABLE
echo "Ballerina Executable: ${DEV_BALLERINA_EXECUTABLE}"

DEV_BALLERINA_GRADLE_WRAPPER="gradlew"
export DEV_BALLERINA_GRADLE_WRAPPER
echo "Gradle Wrapper Name: ${DEV_BALLERINA_GRADLE_WRAPPER}"

echo

DEV_BALLERINA_PROPERTIES_INITIALIZED=true
export DEV_BALLERINA_PROPERTIES_INITIALIZED
