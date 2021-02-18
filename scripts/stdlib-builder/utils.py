import logging
import os
import subprocess

from typing import List

LOGGER = logging.getLogger("utils")


def read_env(key: str, default_value=None) -> str:
    """
    Read an environment variable value with a default value.

    :param key: The key of the environment variable
    :param default_value: The default value to be used if the environment variable is not provided
    :return: The environment variable value
    """
    if key in os.environ:
        return os.environ[key]
    else:
        return default_value


def repo_exists(repo: str) -> bool:
    """
    Check if a Git repository exists.

    :param repo: The URL of the repository
    :return: True if the repository exists
    """
    return _execute_command(["git", "ls-remote", repo, "HEAD"]) == 0


def clone_repo(repo: str, output_dir: str):
    """
    Clone a Git repository.

    :param repo: The URL of the Git repository
    :param output_dir: The directory to which the repository should be cloned to
    """
    if os.path.exists(output_dir):
        if os.path.isdir(output_dir):
            exit_code = _execute_command(["git", "rev-parse", "--git-dir"])
            if exit_code == 0:
                LOGGER.warning("Ignoring already existing repository %s found in %s" % (repo, output_dir))
            else:
                raise Exception("Existing directory %s is not git repository" % output_dir)
        else:
            raise Exception("Path %s already exists and not a directory" % output_dir)
    else:
        exit_code = _execute_command(["git", "clone", repo, output_dir])
        if exit_code == 0:
            LOGGER.debug("Cloned repository %s to directory %s" % (repo, output_dir))
        else:
            raise Exception("Failed to clone repository " + repo)


def _execute_command(command: List[str]) -> int:
    """
    Execute a command.

    :param command: The command to be executed
    :return: The exit code of the command
    """
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    process.wait()
    return process.returncode
