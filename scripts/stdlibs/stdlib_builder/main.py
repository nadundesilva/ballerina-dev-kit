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
import cache
import click
import logging
import os
import stdlibs
from typing import List
import utils

_LOG_FORMAT = "%(asctime)s [%(levelname)s] %(name)s - %(message)s"
_STDLIBS_REPO_LIST_CACHE_KEY = "stdlibs_repo_list"

_LOGGER = logging.getLogger("main")


@click.group("std-libs")
@click.option("--log-level", type=click.Choice(["WARNING", "DEBUG", "INFO"], case_sensitive=False), default="INFO")
def init_cli(log_level: str):
    logging.basicConfig(level=logging.getLevelName(log_level), format=_LOG_FORMAT)


@click.command("clone")
@click.option("--no-cache", type=bool, default=False)
@click.option("--output-dir", type=str, default="stdlibs")
@click.option("--name-overrides-file", type=str, default="std-lib-name-overrides.properties")
def clone_stdlibs(no_cache: bool, output_dir: str, name_overrides_file: str):
    if not no_cache and cache.contains(_STDLIBS_REPO_LIST_CACHE_KEY):
        repos_list: List[stdlibs.Repo] = cache.load(_STDLIBS_REPO_LIST_CACHE_KEY)
        _LOGGER.info("Loaded Standard Library list of size %d from cache" % len(repos_list))
    else:
        # Creating the ordered list of repositories
        std_lib_name_overrides_file_path = os.path.abspath(name_overrides_file)
        _LOGGER.debug("Using Standard Library overrides file %s" % std_lib_name_overrides_file_path)

        # Reading the standard library name overrides
        with open(std_lib_name_overrides_file_path, "r", encoding="utf-8") as std_lib_name_overrides_file:
            sanitized_lines = [line.strip() for line in std_lib_name_overrides_file.readlines()]
            property_lines = [line for line in filter(lambda line: not line.startswith("#") and line, sanitized_lines)]
            std_lib_name_overrides = {line_split[0]: line_split[1] for line_split
                                      in [line.split("=") for line in property_lines]}

        # Generating the ordered list of standard library repos list
        repos_list = stdlibs.get_ordered_std_lib_repos(std_lib_name_overrides)
        _LOGGER.info("Loaded Standard Library list of size %d from properties file" % len(repos_list))
        cache.store(_STDLIBS_REPO_LIST_CACHE_KEY, repos_list)
        _LOGGER.debug("Stored Standard Library list of size %d into cache" % len(repos_list))

    # Cloning the repositories
    stdlibs_dir = os.path.abspath(output_dir)
    _LOGGER.debug("Attempting to clone %d Standard Library Repositories to %s directory"
                  % (len(repos_list), stdlibs_dir))
    cloned_repo_count = 0
    for repo in repos_list:
        if utils.clone_repo(repo["name"], os.path.join(stdlibs_dir, repo["url"])):
            cloned_repo_count += 1
    if cloned_repo_count == 0:
        _LOGGER.info("All Standard Library Repositories already cloned to %s directory" % stdlibs_dir)
    else:
        _LOGGER.info("Cloned %d Standard Library Repositories to %s directory" % (cloned_repo_count, stdlibs_dir))


init_cli.add_command(clone_stdlibs)

if __name__ == "__main__":
    init_cli()
