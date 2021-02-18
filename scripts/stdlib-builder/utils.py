import os


def read_env(key: str, default_value=None):
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
