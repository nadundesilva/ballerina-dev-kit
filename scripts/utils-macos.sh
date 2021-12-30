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

function readAbsolutePath() {
  echo "$(dirname "${1}")/$(basename "${1}")"
}

function installWithBrew() {
  if brew ls --versions "${1}" > /dev/null; then
    echo "Package ${1} already installed"
  else
    brew install "${1}"
  fi
}

function installDependencies() {
  brew update
  installWithBrew miniconda
}
