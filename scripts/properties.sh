#!/usr/bin/env bash

echo
echo "================================="
echo " Ballerina Dev Kit Configuration "
echo "================================="

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DEV_BALLERINA_ROOT_DIR="$(realpath "${DEV_BALLERINA_SCRIPTS_DIR}/..")"
DEV_BALLERINA_REPOS_DIR="${DEV_BALLERINA_ROOT_DIR}/repos"
DEV_BALLERINA_PACKS_DIR="${DEV_BALLERINA_ROOT_DIR}/packs"

DEV_BALLERINA_REPO="${DEV_BALLERINA_REPOS_DIR}/ballerina-lang"
export DEV_BALLERINA_REPO
echo "Ballerina Repo: ${DEV_BALLERINA_REPO}"

DEV_BALLERINA_VERSION=$(< "${DEV_BALLERINA_REPO}/gradle.properties" grep "^version=" | cut -d'=' -f2)
export DEV_BALLERINA_VERSION
echo "Ballerina Version: ${DEV_BALLERINA_VERSION}"

DEV_BALLERINA_PACK_NAME="jballerina-tools-${DEV_BALLERINA_VERSION}"
export DEV_BALLERINA_PACK_NAME
echo "Target Pack Name: ${DEV_BALLERINA_PACK_NAME}"

DEV_BALLERINA_PACK="${DEV_BALLERINA_PACKS_DIR}/${DEV_BALLERINA_PACK_NAME}"
export DEV_BALLERINA_PACK
echo "Target Pack: ${DEV_BALLERINA_PACK}"

echo
