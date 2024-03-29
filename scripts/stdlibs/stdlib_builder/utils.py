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
import json
import logging
import os
import subprocess
from typing import Dict, List, Tuple, TypedDict

_LOGGER = logging.getLogger("utils")


class Config(TypedDict):
    nameOverrides: Dict[str, str]
    ignored: List[str]


def repo_exists(repo: str) -> bool:
    """
    Check if a Git repository exists.

    :param repo: The URL of the repository
    :returns: True if the repository exists
    """
    return execute_command(("git", "ls-remote", repo, "HEAD"), stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0


def clone_repo(repo: str, output_dir: str) -> bool:
    """
    Clone a Git repository.

    :param repo: The URL of the Git repository
    :param output_dir: The directory to which the repository should be cloned to
    :returns: True if repository was cloned
    :raises: Exception when cloning the repository fails
    """
    if os.path.exists(output_dir):
        if os.path.isdir(output_dir):
            exit_code = execute_command(("git", "rev-parse", "--git-dir"), stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE)
            if exit_code == 0:
                _LOGGER.debug("Ignoring already existing repository %s found in %s" % (repo, output_dir))
                return False
            else:
                raise Exception("Existing directory %s is not git repository" % output_dir)
        else:
            raise Exception("Path %s already exists and not a directory" % output_dir)
    else:
        exit_code = execute_command(("git", "clone", repo, output_dir), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if exit_code == 0:
            _LOGGER.debug("Cloned repository %s to directory %s" % (repo, output_dir))
            return True
        else:
            raise Exception("Failed to clone repository " + repo + " to directory " + output_dir)


def execute_command(command: Tuple, **p_open_args) -> int:
    """
    Execute a command.

    :param command: The command to be executed
    :param cwd: The current working directory in which the command should be executed
    :returns: The exit code of the command
    """
    process = subprocess.Popen(command, **p_open_args)
    process.wait()
    return process.returncode


def read_config(config_file_path: str) -> Config:
    """
    Read the configuration from a file path.

    :param config_file_path: The path of the configuration file
    :return: The configuration
    """
    _LOGGER.debug("Using the configuration file %s" % config_file_path)
    with open(config_file_path, "r", encoding="utf-8") as config_file:
        return json.load(config_file)
