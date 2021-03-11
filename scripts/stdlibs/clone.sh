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

USE_NO_CACHE=${USE_NO_CACHE:-"true"}

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../properties.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/properties.sh"
# shellcheck source=../utils.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/utils.sh"

pushd stdlib_builder
CLONE_ARGS=(clone --output-dir="${DEV_BALLERINA_STD_LIB_REPOS}" --no-cache="${USE_NO_CACHE}")
if [[ -n "${CLEANUP_EXTRA_MODULES}" ]]; then
  if [[ "${CLEANUP_EXTRA_MODULES}" == "true" || "${CLEANUP_EXTRA_MODULES}" == "false" ]]; then
    CLONE_ARGS+=(--cleanup="${CLEANUP_EXTRA_MODULES}")
  else
    echo "Value of CLEANUP_EXTRA_MODULES env var expected to be one of true or false"
    exit 1
  fi
fi
python3 main.py  "${CLONE_ARGS[@]}"
popd
