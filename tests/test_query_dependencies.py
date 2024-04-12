import pytest
import os
import logging

from python_at_work.query_dependencies import dependency_list


LOGGER = logging.getLogger(__name__)

def test_print_word():
    dep_list = dependency_list("query.sql")
    res = ["$source_project.operational_support.wifi_test_trigger",
           "$source_project.operational_support.wifi_test"]
    LOGGER.info(str(dep_list))

    assert dep_list == res