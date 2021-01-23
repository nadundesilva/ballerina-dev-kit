#!/usr/bin/env bash

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
