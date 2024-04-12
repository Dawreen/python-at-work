import pytest
import sys
from python_at_work.query_dependencies import dependency_list

def test_print_word():
    dep_list = dependency_list("query.sql")
    res = ["`$source_project.operational_support.wifi_test_trigger`",
           "`$source_project.operational_support.wifi_test`"]
    assert dep_list == res
