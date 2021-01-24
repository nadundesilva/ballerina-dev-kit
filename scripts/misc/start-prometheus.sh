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

PROMETHEUS_IMAGE="prom/prometheus:v2.20.1"
PROMETHEUS_CONTAINER_NAME="ballerina-dev-kit-prometheus"
PROMETHEUS_CONFIG_FILE="${DEV_BALLERINA_SCRIPTS_DIR}/misc/resources/prometheus/config.yml"
PROMETHEUS_PORTAL_PORT=9090

PROMETHEUS_OLD_CONTAINER_ID=$(docker ps -f name=${PROMETHEUS_CONTAINER_NAME} -a -q)
if [ -n "${PROMETHEUS_OLD_CONTAINER_ID}" ]; then
  echo "Removing old stopped container; Name: ${PROMETHEUS_CONTAINER_NAME}, Container ID: ${PROMETHEUS_OLD_CONTAINER_ID}"
  docker rm -f "${PROMETHEUS_OLD_CONTAINER_ID}" > /dev/null
fi

echo
echo "==============================="
echo " Prometheus Server Information "
echo "==============================="
echo "Image: ${PROMETHEUS_IMAGE}"
echo "Container Name: ${PROMETHEUS_CONTAINER_NAME}"
echo "Prometheus Portal: http://localhost:${PROMETHEUS_PORTAL_PORT}"
echo

echo "Starting Prometheus container"

docker run -it --name ${PROMETHEUS_CONTAINER_NAME} \
  -p "${PROMETHEUS_PORTAL_PORT}:9090" \
  -v "${PROMETHEUS_CONFIG_FILE}:/etc/prometheus/prometheus.yml" \
  --net host \
  ${PROMETHEUS_IMAGE}
