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

USE_NO_CACHE=${USE_NO_CACHE:-"false"}
INHERIT_EXIT_CODE=${INHERIT_EXIT_CODE:-"true"}

DEV_BALLERINA_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

# shellcheck source=../init.sh
source "${DEV_BALLERINA_SCRIPTS_DIR}/init.sh"

pushd stdlib_builder
python3 main.py execute --stdlibs-dir="${DEV_BALLERINA_STD_LIB_REPOS}" --no-cache="${USE_NO_CACHE}" \
  --inherit-exit-code="${INHERIT_EXIT_CODE}" "${@}"
popd
