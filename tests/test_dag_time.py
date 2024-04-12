import pytest
import json
import os
import logging

from python_at_work.dag_time import get_DAG, get_time


LOGGER = logging.getLogger(__name__)

def test_print_word():
    f = open('config.json')
    data = json.load(f)
    f.close()

    path_dags = data["path"]
    my_dag = get_DAG("project.dataset.table")
    dag_check = "account_enriched"
    time = get_time(dag_check)
    LOGGER.info(f"DAG:{dag_check} --- {time}")

    assert time == "35 00 * * *"