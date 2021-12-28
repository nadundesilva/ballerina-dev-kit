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

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

GRAFANA_IMAGE="grafana/grafana:7.1.4-ubuntu"
GRAFANA_CONTAINER_NAME="ballerina-dev-kit-grafana"
GRAFANA_CONFIG_FILE="${DEV_BALLERINA_SCRIPTS_DIR}/misc/resources/grafana/config.yml"
GRAFANA_DASHBOARD_JSON="${DEV_BALLERINA_SCRIPTS_DIR}/misc/resources/grafana/ballerina-dashboard.json"
GRAFANA_PORTAL_PORT=3000

GRAFANA_OLD_CONTAINER_ID=$(docker ps -f name=${GRAFANA_CONTAINER_NAME} -a -q)
if [ -n "${GRAFANA_OLD_CONTAINER_ID}" ]; then
  echo "Removing old stopped container; Name: ${GRAFANA_CONTAINER_NAME}, Container ID: ${GRAFANA_OLD_CONTAINER_ID}"
  docker rm -f "${GRAFANA_OLD_CONTAINER_ID}" > /dev/null
fi

echo
echo "==============================="
echo " Grafana Server Information "
echo "==============================="
echo "Image: ${GRAFANA_IMAGE}"
echo "Container Name: ${GRAFANA_CONTAINER_NAME}"
echo "Grafana Portal: http://localhost:${GRAFANA_PORTAL_PORT}"
echo

echo "Starting Grafana container"

docker run -it --name ${GRAFANA_CONTAINER_NAME} \
  -p "${GRAFANA_PORTAL_PORT}:3000" \
  -v "${GRAFANA_CONFIG_FILE}:/etc/grafana/config.yml" \
  --net host \
  ${GRAFANA_IMAGE} \
  --config=/etc/grafana/config.yml
