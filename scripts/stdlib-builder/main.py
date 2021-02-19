import cache
import logging
import os
import std_libs
from typing import List
import utils

LOG_LEVEL_ENV_VAR_KEY = "LOG_LEVEL"
LOG_LEVEL_ENV_VAR_DEFAULT = "INFO"
STD_LIBS_REPOS_DIR_ENV_VAR_KEY = "STD_LIBS_REPOS_DIR"
STD_LIBS_REPOS_DIR_ENV_VAR_DEFAULT = os.path.abspath("./std_libs")
STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_KEY = "STD_LIB_NAME_OVERRIDES_FILE"
STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_DEFAULT = "std-lib-name-overrides.properties"

STD_LIBS_REPO_LIST_CACHE_KEY = "std_libs_repo_list"

LOGGER = logging.getLogger("main")

if __name__ == "__main__":
    # Initializing logger
    log_level = utils.read_env(LOG_LEVEL_ENV_VAR_KEY, LOG_LEVEL_ENV_VAR_DEFAULT)
    logging.basicConfig(level=logging.getLevelName(log_level),
                        format="%(asctime)s [%(levelname)s] %(name)s - %(message)s")

    if cache.contains(STD_LIBS_REPO_LIST_CACHE_KEY):
        repos_list: List[std_libs.Repo] = cache.load(STD_LIBS_REPO_LIST_CACHE_KEY)
        LOGGER.info("Loaded Standard Library list of size %d from cache" % len(repos_list))
    else:
        # Creating the ordered list of repositories
        std_lib_name_overrides_file_path = utils.read_env(STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_KEY,
                                                          STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_DEFAULT)
        LOGGER.debug("Using Standard Library overrides file %s" % std_lib_name_overrides_file_path)

        with open(std_lib_name_overrides_file_path, "r", encoding="utf-8") as std_lib_name_overrides_file:
            repos_list = std_libs.get_ordered_std_lib_repos(std_lib_name_overrides_file.readlines())
            LOGGER.info("Loaded Standard Library list of size %d from properties file" % len(repos_list))
            cache.store(STD_LIBS_REPO_LIST_CACHE_KEY, repos_list)
            LOGGER.debug("Stored Standard Library list of size %d into cache" % len(repos_list))

    # Cloning the repositories
    std_libs_dir = utils.read_env(STD_LIBS_REPOS_DIR_ENV_VAR_KEY, STD_LIBS_REPOS_DIR_ENV_VAR_DEFAULT)
    LOGGER.debug("Attempting to clone %d Standard Library Repositories to %s directory"
                 % (len(repos_list), std_libs_dir))
    cloned_repo_count = 0
    for repo in repos_list:
        if utils.clone_repo(repo["name"], os.path.join(std_libs_dir, repo["url"])):
            cloned_repo_count += 1
    if cloned_repo_count == 0:
        LOGGER.info("All Standard Library Repositories already cloned to %s directory" % std_libs_dir)
    else:
        LOGGER.info("Cloned %d Standard Library Repositories to %s directory" % (len(repos_list), std_libs_dir))
