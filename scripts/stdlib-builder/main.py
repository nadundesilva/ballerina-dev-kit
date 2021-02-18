import stdlibs
import logging
import requests
import utils

BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE = "https://raw.githubusercontent.com/ballerina-platform" \
                                           "/ballerina-distribution/master/gradle.properties"
LOG_LEVEL_ENV_VAR_KEY = "LOG_LEVEL"

if __name__ == "__main__":
    log_level = utils.read_env(LOG_LEVEL_ENV_VAR_KEY, "INFO")
    logging.basicConfig(level=logging.getLevelName(log_level),
                        format="%(asctime)s [%(levelname)s] %(name)s - %(message)s")

    response = requests.get(BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE)
    if response.status_code == 200:
        dependency_levels = stdlibs.build_dependency_levels(response.content.decode("utf-8"))
    else:
        raise Exception("Downloading Ballerina Distribution Gradle properties file failed with status code " +
                        str(response.status_code))
