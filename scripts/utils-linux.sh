#!/usr/bin/env bash

set -e

function readAbsolutePath() {
  readlink -f "$1"
}
