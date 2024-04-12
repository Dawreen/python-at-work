import logging
import json
import yaml


LOGGER = logging.getLogger(__name__)

def get_time(dag_id: str) -> str:
    f = open('config.json')
    data = json.load(f)
    f.close()

    path_dag = f"{data["path"]}/{dag_id}/config/dag_config.yaml" 
    with open(path_dag, 'r') as file:
        dag_config = yaml.safe_load(file)
        return dag_config["dag_parameters"]["schedule"]

def get_DAG(table_id: str) -> str:
    return ""