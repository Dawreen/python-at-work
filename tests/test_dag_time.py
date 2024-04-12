import pytest
import json
import os
import logging

from python_at_work.dag_time import get_DAG


LOGGER = logging.getLogger(__name__)

def test_print_word():
    f = open('config.json')
    data = json.load(f)
    f.close()
    
    path_dags = data["path"]
    my_dag = get_DAG("project.dataset.table")
    LOGGER.info(str(os.listdir(path_dags)))

    assert True