#!/usr/bin/env bash

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

echo

DEV_BALLERINA_PROPERTIES_INITIALIZED=true
export DEV_BALLERINA_PROPERTIES_INITIALIZED
