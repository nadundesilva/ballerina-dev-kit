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
import os
import pickle
from typing import Any, IO

_CACHE_DIR = "./.cache"
_CACHE_FILE = "%s.data"


def store(key: str, data: Any):
    """
    Store data in the cache using a key.

    :param key: The cache data key to be used to access later
    :param data: The data to be stored
    """
    with _open_cache_file(key, "wb") as file:
        pickle.dump(data, file)


def load(key: str) -> Any:
    """
    Load data from the cache using a key.

    :param key: The key which was used to store the data
    :returns: The cached data
    """
    with _open_cache_file(key, "rb") as file:
        return pickle.load(file)


def contains(key: str) -> bool:
    """
    Check if a cache contains a key.

    :param key: The key which needs to be checked
    :returns: True if the cache contains the key
    """
    cache_file = _get_cache_file(key)
    return os.path.exists(cache_file)


def _open_cache_file(key: str, mode: str) -> IO[bytes]:
    """
    Open a cache file for a cache key.

    :param key: The key for which cache file should be fetched
    :returns: The cache file
    """
    cache_file = _get_cache_file(key)
    return open(cache_file, mode)


def _get_cache_file(key: str) -> str:
    """
    Return the cache file for a cache key.
    The file is used for storing the cache data.

    :param key: The key used with the cache
    """
    return os.path.join(_CACHE_DIR, _CACHE_FILE % key)
