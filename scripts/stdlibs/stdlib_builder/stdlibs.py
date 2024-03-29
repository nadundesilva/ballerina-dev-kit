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
import logging
import re
import requests
from typing import Tuple, List, TypedDict, Dict
import utils

_BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE = "https://raw.githubusercontent.com/ballerina-platform" \
                                            "/ballerina-distribution/master/gradle.properties"
_BALLERINA_STD_LIB_MODULE_REPO_NAME = "module-ballerina-%s"
_BALLERINA_INTERNAL_STD_LIB_MODULE_REPO_NAME = "module-ballerinai-%s"
_BALLERINA_EXTERNAL_STD_LIB_MODULE_REPO_NAME = "module-ballerinax-%s"
_BALLERINA_REPO_URL = "https://github.com/ballerina-platform/%s.git"

_LOGGER = logging.getLogger("stdlibs")

_DependencyLevel = Tuple[int, List[Tuple[str, str]]]  # tuple(level_number, list(tuple(package_name, package_version)))


class Repo(TypedDict):
    name: str
    url: str


def get_ordered_std_lib_repos(std_lib_name_overrides: Dict[str, str], ignored_stdlibs: List[str]) -> List[Repo]:
    """
    Get the list of standard library levels.

    :returns: The list of levels ordered by the expected build order
    :raises: Exception when generating the list of standard library repos fails
    """
    response = requests.get(_BALLERINA_DISTRIBUTION_GRADLE_PROPS_FILE)
    if response.status_code == 200:
        # Identifying the standard library build levels to be used
        dependency_levels = _build_dependency_levels(response.content.decode("utf-8"), std_lib_name_overrides,
                                                     ignored_stdlibs)
        dependency_libs = [dependency_lib[0] for dependency_level in dependency_levels
                           for dependency_lib in dependency_level[1]]

        # Detecting existing modules and creating the list of repositories
        module_repo_name_templates = [_BALLERINA_STD_LIB_MODULE_REPO_NAME, _BALLERINA_INTERNAL_STD_LIB_MODULE_REPO_NAME,
                                      _BALLERINA_EXTERNAL_STD_LIB_MODULE_REPO_NAME]
        repos = []
        for lib in dependency_libs:
            is_lib_available = False
            for repo_name_template in module_repo_name_templates:  # Checking through repos to find an existing repo
                repo_name = repo_name_template % lib
                repo_url = _BALLERINA_REPO_URL % repo_name
                if utils.repo_exists(repo_url):
                    _LOGGER.debug("Detected existing module " + repo_name)
                    repos.append({"name": repo_name, "url": repo_url})
                    is_lib_available = True
            if not is_lib_available:
                raise Exception("No module repository found for %s" % lib)
        return repos
    else:
        raise Exception("Downloading Ballerina Distribution Gradle properties file failed with status code %s" %
                        response.status_code)


def _build_dependency_levels(level_declaration_props: str, package_name_overrides: {str: str},
                             ignored_stdlibs: List[str]) \
        -> List[_DependencyLevel]:
    """
    Build the dependency levels mentioned in the properties file.

    :param level_declaration_props: The properties file content declaring the standard library levels
    :returns: The list of dependency levels
    """
    level_title_pattern = re.compile("# Stdlib Level (\\d+)")
    stdlib_version_pattern = re.compile("stdlib([a-zA-Z0-9]+)Version=(.+)")

    _LOGGER.info("Building Standard Library Dependency Levels")
    levels = []
    current_level = None
    for line in level_declaration_props.split("\n"):
        level_title_match = level_title_pattern.match(line)
        if level_title_match:  # Standard Library Level Definition Line
            level = int(level_title_match.group(1))
            current_level = (level, [])
            levels.append(current_level)
        else:  # Standard Library Version Line
            stdlib_version_match = stdlib_version_pattern.match(line)
            if current_level is not None and len(line) > 0 and not (line.isspace()) and stdlib_version_match:
                package_name = _get_package_name(stdlib_version_match.group(1), package_name_overrides)
                if package_name in ignored_stdlibs:
                    continue
                else:
                    package_version = stdlib_version_match.group(2)
                    current_level[1].append((package_name.lower(), package_version))
            else:
                current_level = None
                _LOGGER.debug("Ignored Property Line: %s" % line)

    levels.sort(key=_get_dependency_tree_node_level)
    _print_dependency_levels(levels)
    return levels


def _get_package_name(version_prop_key: str, name_overrides: {str: str}) -> str:
    """
    Generate the package name from the property key of the version property in the level declaration.

    :param version_prop_key: The key of the property specifying the version
    :returns: The package name
    """
    module_name = version_prop_key[0].lower()
    i = 1
    while i < len(version_prop_key):
        current_letter = version_prop_key[i]
        if current_letter.isupper() and version_prop_key[i - 1].islower():
            module_name += ".%s" % current_letter.lower()
        else:
            module_name += current_letter
        i += 1
    return name_overrides[module_name] if module_name in name_overrides else module_name


def _get_dependency_tree_node_level(level_node: _DependencyLevel) -> int:
    """
    Get the dependency tree node level number.
    This can be used in functions such as sort.

    :param level_node: The node of which the level should be returned
    :returns: The level number
    """
    return level_node[0]


def _print_dependency_levels(levels: List[_DependencyLevel]):
    """
    Print the dependency levels in proper readable format.

    :param levels: The levels to be printed
    """
    print("\nDependency Levels")
    for level in levels:
        print("\tLevel %s" % level[0])
        for lib in level[1]:
            print("\t\t%s - %s" % (lib[0], lib[1]))
    print()
