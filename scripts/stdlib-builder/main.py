import cache
import click
import logging
import os
import std_libs
from typing import List
import utils

_LOG_FORMAT = "%(asctime)s [%(levelname)s] %(name)s - %(message)s"
_STD_LIBS_REPO_LIST_CACHE_KEY = "std_libs_repo_list"

_LOGGER = logging.getLogger("main")


@click.group("std-libs")
def std_libs_cli():
    pass


@click.command("clone")
@click.option("--no-cache", type=bool, default=False)
@click.option("--output-dir", type=str, default="std_libs")
@click.option("--name-overrides-file", type=str, default="std-lib-name-overrides.properties")
@click.option("--log-level", type=click.Choice(["DEBUG", "INFO"], case_sensitive=False), default="INFO")
def clone_std_libs(no_cache: bool, output_dir: str, name_overrides_file: str, log_level: str):
    # Initializing logger
    logging.basicConfig(level=logging.getLevelName(log_level), format=_LOG_FORMAT)

    if not no_cache and cache.contains(_STD_LIBS_REPO_LIST_CACHE_KEY):
        repos_list: List[std_libs.Repo] = cache.load(_STD_LIBS_REPO_LIST_CACHE_KEY)
        _LOGGER.info("Loaded Standard Library list of size %d from cache" % len(repos_list))
    else:
        # Creating the ordered list of repositories
        std_lib_name_overrides_file_path = os.path.abspath(name_overrides_file)
        _LOGGER.debug("Using Standard Library overrides file %s" % std_lib_name_overrides_file_path)

        with open(std_lib_name_overrides_file_path, "r", encoding="utf-8") as std_lib_name_overrides_file:
            repos_list = std_libs.get_ordered_std_lib_repos(std_lib_name_overrides_file.readlines())
            _LOGGER.info("Loaded Standard Library list of size %d from properties file" % len(repos_list))
            cache.store(_STD_LIBS_REPO_LIST_CACHE_KEY, repos_list)
            _LOGGER.debug("Stored Standard Library list of size %d into cache" % len(repos_list))

    # Cloning the repositories
    std_libs_dir = os.path.abspath(output_dir)
    _LOGGER.debug("Attempting to clone %d Standard Library Repositories to %s directory"
                  % (len(repos_list), std_libs_dir))
    cloned_repo_count = 0
    for repo in repos_list:
        if utils.clone_repo(repo["name"], os.path.join(std_libs_dir, repo["url"])):
            cloned_repo_count += 1
    if cloned_repo_count == 0:
        _LOGGER.info("All Standard Library Repositories already cloned to %s directory" % std_libs_dir)
    else:
        _LOGGER.info("Cloned %d Standard Library Repositories to %s directory" % (len(repos_list), std_libs_dir))


std_libs_cli.add_command(clone_std_libs)

if __name__ == "__main__":
    std_libs_cli()
