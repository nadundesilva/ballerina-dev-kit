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

JAEGER_IMAGE="jaegertracing/all-in-one:1.18"
JAEGER_CONTAINER_NAME="ballerina-dev-kit-jaeger"
JAEGER_PORTAL_PORT=16686

JAEGER_OLD_CONTAINER_ID=$(docker ps -f name=${JAEGER_CONTAINER_NAME} -a -q)
if [ -n "${JAEGER_OLD_CONTAINER_ID}" ]; then
  echo "Removing old stopped container; Name: ${JAEGER_CONTAINER_NAME}, Container ID: ${JAEGER_OLD_CONTAINER_ID}"
  docker rm -f "${JAEGER_OLD_CONTAINER_ID}" > /dev/null
fi

echo
echo "==========================="
echo " Jaeger Server Information "
echo "==========================="
echo "Image: ${JAEGER_IMAGE}"
echo "Container Name: ${JAEGER_CONTAINER_NAME}"
echo "Jaeger Portal: http://localhost:${JAEGER_PORTAL_PORT}"
echo

echo "Starting Jaeger container"

docker run -it --name ${JAEGER_CONTAINER_NAME} \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p ${JAEGER_PORTAL_PORT}:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  ${JAEGER_IMAGE}
