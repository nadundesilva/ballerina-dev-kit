import logging
from typing import Tuple, List
import re

LOGGER = logging.getLogger("dependency_level_builder")


DependencyLevel = Tuple[int, List[Tuple[str, str]]]


def build_dependency_levels(prop_file_content: str) -> List[DependencyLevel]:
    """
    Build the dependency levels mentioned in the properties file

    :param prop_file_content: The content of properties file
    :return: The list of dependency levels

    """
    level_title_pattern = re.compile("# Stdlib Level (\\d+)")
    stdlib_version_pattern = re.compile("stdlib([a-zA-Z0-9]+)Version=(.+)")

    logging.info("Building Standard Library Dependency Levels")
    levels = []
    current_level = None
    for line in prop_file_content.split("\n"):
        level_title_match = level_title_pattern.match(line)
        if level_title_match:  # Standard Library Level Definition Line
            level = int(level_title_match.group(1))
            current_level = (level, [])
            levels.append(current_level)
        else:  # Standard Library Version Line
            stdlib_version_match = stdlib_version_pattern.match(line)
            if current_level is not None and len(line) > 0 and not (line.isspace()) and stdlib_version_match:
                current_level[1].append((stdlib_version_match.group(1).lower(), stdlib_version_match.group(2)))
            else:
                current_level = None
                LOGGER.debug("Ignored Property Line: " + line)

    levels.sort(key=_get_dependency_tree_node_level)
    _print_dependency_levels(levels)
    return levels


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
        print("\tLevel " + str(level[0]))
        for lib in level[1]:
            print("\t\t" + str(lib[0]) + " - " + str(lib[1]))
    print("\n")
