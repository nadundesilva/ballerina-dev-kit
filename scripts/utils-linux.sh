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
  readlink -f "$1"
}

function installDependencies() {
  sudo apt update --yes
  sudo apt upgrade --yes

  which conda &>/dev/null
  if [[ $? -eq 0 ]]; then
    # Install miniconda
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p ~/miniconda
    rm ~/miniconda.sh
  fi
}
