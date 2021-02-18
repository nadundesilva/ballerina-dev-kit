import logging
from typing import Tuple, List
import re

LOGGER = logging.getLogger("std_libs")

DependencyLevel = Tuple[int, List[Tuple[str, str]]]


def build_dependency_levels(level_declaration_props: str) -> List[DependencyLevel]:
    """
    Build the dependency levels mentioned in the properties file.

    :param level_declaration_props: The properties file content declaring the standard library levels
    :return: The list of dependency levels
    """
    level_title_pattern = re.compile("# Stdlib Level (\\d+)")
    stdlib_version_pattern = re.compile("stdlib([a-zA-Z0-9]+)Version=(.+)")

    LOGGER.info("Building Standard Library Dependency Levels")
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
                package_name = _get_package_name(stdlib_version_match.group(1))
                package_version = stdlib_version_match.group(2)
                current_level[1].append((package_name.lower(), package_version))
            else:
                current_level = None
                LOGGER.debug("Ignored Property Line: %s" % line)

    levels.sort(key=_get_dependency_tree_node_level)
    _print_dependency_levels(levels)
    return levels


def _get_package_name(version_prop_key: str) -> str:
    """
    Generate the package name from the property key of the version property in the level declaration.

    :param version_prop_key: The key of the property specifying the version
    :return: The package name
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
    return module_name


def _get_dependency_tree_node_level(level_node: DependencyLevel) -> int:
    """
    Get the dependency tree node level number.
    This can be used in functions such as sort.

    :param level_node: The node of which the level should be returned
    :return: The level number
    """
    return level_node[0]


def _print_dependency_levels(levels: List[DependencyLevel]):
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
