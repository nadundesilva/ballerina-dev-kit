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
import shutil
import stdlibs
from typing import List, Tuple
import utils

_LOG_FORMAT = "%(asctime)s [%(levelname)s] %(name)s - %(message)s"
_STDLIBS_REPO_LIST_CACHE_KEY = "stdlibs_repo_list"

_LOGGER = logging.getLogger("main")


@click.group("std-libs")
@click.option("--log-level", type=click.Choice(["WARNING", "DEBUG", "INFO"], case_sensitive=False), default="INFO")
def init_cli(log_level: str):
    logging.basicConfig(level=logging.getLevelName(log_level), format=_LOG_FORMAT)


@click.command("clone")
@click.option("--config-path", type=str, default="config.json")
@click.option("--no-cache", type=bool, default=False)
@click.option("--stdlibs-dir", type=str, default="stdlibs")
@click.option("--cleanup", type=bool)
def clone_stdlibs(config_path: str, no_cache: bool, stdlibs_dir: str, cleanup: bool):
    config = utils.read_config(config_path)
    repos_list = _build_stdlibs_order(no_cache, config)

    # Cloning the repositories
    stdlibs_dir = os.path.abspath(stdlibs_dir)
    _LOGGER.debug("Attempting to clone %d Standard Library Repositories to %s directory"
                  % (len(repos_list), stdlibs_dir))
    cloned_repo_count = 0
    for repo in repos_list:
        if utils.clone_repo(repo["url"], os.path.join(stdlibs_dir, repo["name"])):
            cloned_repo_count += 1
    if cloned_repo_count == 0:
        _LOGGER.info("All Standard Library Repositories already cloned to %s directory" % stdlibs_dir)
    else:
        _LOGGER.info("Cloned %d Standard Library Repositories to %s directory" % (cloned_repo_count, stdlibs_dir))

    # Cleaning up the repositories
    if cleanup or cleanup is None:
        extra_modules = [module for module in filter(
            lambda stdlib_repo_dir: (stdlib_repo_dir.startswith("module-") and
                                     stdlib_repo_dir not in [repo_list_item["name"] for repo_list_item in repos_list]),
            os.listdir(stdlibs_dir))]
        extra_module_count = len(extra_modules)
        if extra_module_count > 0:
            _LOGGER.info("Found extra repos: " + str(extra_modules))
            if (cleanup or click.confirm("Would you like cleanup the %d extra repo(s) ?" % extra_module_count,
                                         default=True)):
                for module in extra_modules:
                    shutil.rmtree(os.path.join(stdlibs_dir, module))


@click.command("execute")
@click.argument('command', nargs=-1)
@click.option("--config-path", type=str, default="config.json")
@click.option("--no-cache", type=bool, default=False)
@click.option("--stdlibs-dir", type=str, default="stdlibs")
@click.option("--inherit-exit-code", type=bool, default=True)
def execute_command(config_path: str, command: Tuple[str], no_cache: bool, stdlibs_dir: str, inherit_exit_code: bool):
    config = utils.read_config(config_path)
    repos_list = _build_stdlibs_order(no_cache, config)
    stdlibs_dir = os.path.abspath(stdlibs_dir)
    for repo in repos_list:
        working_dir = os.path.join(stdlibs_dir, repo["name"])
        exit_code = utils.execute_command(command, cwd=working_dir)
        if inherit_exit_code and exit_code != 0:
            _LOGGER.error("Failed to execute command %s for standard library %s" % (str(command), repo["name"]))
            exit(exit_code)


def _build_stdlibs_order(no_cache: bool, config: utils.Config) -> List[stdlibs.Repo]:
    if not no_cache and cache.contains(_STDLIBS_REPO_LIST_CACHE_KEY):
        repos_list: List[stdlibs.Repo] = cache.load(_STDLIBS_REPO_LIST_CACHE_KEY)
        _LOGGER.info("Loaded Standard Library list of size %d from cache" % len(repos_list))
    else:
        # Generating the ordered list of standard library repos list
        repos_list: List[stdlibs.Repo] = stdlibs.get_ordered_std_lib_repos(config["nameOverrides"], config["ignored"])
        _LOGGER.info("Loaded Standard Library list of size %d from properties file" % len(repos_list))
        cache.store(_STDLIBS_REPO_LIST_CACHE_KEY, repos_list)
        _LOGGER.debug("Stored Standard Library list of size %d into cache" % len(repos_list))
    return repos_list


init_cli.add_command(clone_stdlibs)
init_cli.add_command(execute_command)

if __name__ == "__main__":
    init_cli()
