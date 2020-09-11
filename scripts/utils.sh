#!/usr/bin/env bash

set -e

function printBallerinaPackInfo() {
  echo
  echo "============================"
  echo " Ballerina Pack Information "
  echo "============================"
  "${DEV_BALLERINA_EXECUTABLE}" version
  echo "Ballerina Home: $("${DEV_BALLERINA_EXECUTABLE}" home)"
  echo
}
