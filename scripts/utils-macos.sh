#!/usr/bin/env bash

set -e

function readAbsolutePath() {
  echo "$(dirname $1)/$(basename $1)"
}
