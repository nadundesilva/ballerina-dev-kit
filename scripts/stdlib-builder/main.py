import logging
import os
import std_libs
import utils

LOG_LEVEL_ENV_VAR_KEY = "LOG_LEVEL"
LOG_LEVEL_ENV_VAR_DEFAULT = "INFO"
STD_LIBS_REPOS_DIR_ENV_VAR_KEY = "STD_LIBS_REPOS_DIR"
STD_LIBS_REPOS_DIR_ENV_VAR_DEFAULT = os.path.abspath("./std_libs")
STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_KEY = "STD_LIB_NAME_OVERRIDES_FILE"
STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_DEFAULT = "std-lib-name-overrides.properties"


if __name__ == "__main__":
    # Initializing logger
    log_level = utils.read_env(LOG_LEVEL_ENV_VAR_KEY, LOG_LEVEL_ENV_VAR_DEFAULT)
    logging.basicConfig(level=logging.getLevelName(log_level),
                        format="%(asctime)s [%(levelname)s] %(name)s - %(message)s")

    # Creating the ordered list of repositories
    std_lib_name_overrides_file_path = utils.read_env(STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_KEY,
                                                      STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_DEFAULT)
    std_lib_name_overrides_file = open(std_lib_name_overrides_file_path, "r", encoding="utf-8")
    repos_list = std_libs.get_ordered_std_lib_repos(std_lib_name_overrides_file.readlines())

    std_libs_dir = utils.read_env(STD_LIBS_REPOS_DIR_ENV_VAR_KEY, STD_LIBS_REPOS_DIR_ENV_VAR_DEFAULT)
    for repo in repos_list:
        utils.clone_repo(repo[1], os.path.join(std_libs_dir, repo[0]))
