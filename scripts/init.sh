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

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

if [[ ! "${CI}" == "true" ]]; then
  if [[ "${SHELL}" == *"/bash" ]]; then
    eval "$(conda shell.bash hook)"
  elif [[ "${SHELL}" == *"/zsh" ]]; then
    eval "$(conda shell.zsh hook)"
  else
    echo "Unsupported Shell: ${SHELL}"
    exit 1
  fi
  conda activate "${DEV_CONDA_ENVIRONMENT_NAME}"
  echo "Changed conda environment to ${CONDA_DEFAULT_ENV}"
fi
