import logging
import os
import requests
import std_libs
import utils

BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE = "https://raw.githubusercontent.com/ballerina-platform" \
                                           "/ballerina-distribution/master/gradle.properties"
BALLERINA_STD_LIB_MODULE_REPO_NAME = "module-ballerina-%s"
BALLERINA_INTERNAL_STD_LIB_MODULE_REPO_NAME = "module-ballerinai-%s"
BALLERINA_EXTERNAL_STD_LIB_MODULE_REPO_NAME = "module-ballerinax-%s"
BALLERINA_REPO_URL = "https://github.com/ballerina-platform/%s.git"

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

    response = requests.get(BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE)
    if response.status_code == 200:
        std_libs_dir = utils.read_env(STD_LIBS_REPOS_DIR_ENV_VAR_KEY, STD_LIBS_REPOS_DIR_ENV_VAR_DEFAULT)

        # Reading the standard library name overrides
        std_lib_name_overrides_file = open(utils.read_env(STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_KEY,
                                                          STD_LIB_NAME_OVERRIDES_FILE_ENV_VAR_DEFAULT))
        std_lib_name_overrides = {x[0]: x[1].strip() for x in [line.split("=")
                                                               for line in std_lib_name_overrides_file.readlines()]}

        # Identifying the standard library build levels to be used
        dependency_levels = std_libs.build_dependency_levels(response.content.decode("utf-8"))
        libs_list = [lib[0] for libs in dependency_levels for lib in libs[1]]
        libs_list = [std_lib_name_overrides[x] if x in std_lib_name_overrides else x for x in libs_list]

        module_repo_name_templates = [BALLERINA_STD_LIB_MODULE_REPO_NAME, BALLERINA_INTERNAL_STD_LIB_MODULE_REPO_NAME,
                                      BALLERINA_EXTERNAL_STD_LIB_MODULE_REPO_NAME]
        for lib in libs_list:
            is_lib_clone_successful = False
            for repo_name_template in module_repo_name_templates:
                repo_name = repo_name_template % lib
                repo_url = BALLERINA_REPO_URL % repo_name
                if utils.repo_exists(repo_url):
                    utils.clone_repo(repo_url, os.path.join(std_libs_dir, repo_name))
                    is_lib_clone_successful = True
            if not is_lib_clone_successful:
                raise Exception("No Ballerina / Ballerina Internal / Ballerina External Module found for %s" % lib)
    else:
        raise Exception("Downloading Ballerina Distribution Gradle properties file failed with status code %s" %
                        response.status_code)
