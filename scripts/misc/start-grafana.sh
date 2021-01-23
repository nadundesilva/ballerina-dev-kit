#!/usr/bin/env bash

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
