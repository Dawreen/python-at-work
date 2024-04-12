import pytest
import sys
from python_at_work.query_dependencies import dependency_list

def test_print_word():
    dep_list = dependency_list("query.sql")
    res = ["`$source_project_daita.operational_support.skywifi_test_trigger`",
           "`$source_project_daita.operational_support.skywifi_test`"]
    assert dep_list == res
