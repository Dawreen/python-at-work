import logging
import sys


LOGGER = logging.getLogger(__name__)

def dependency_list(path: str) -> list[str]:
    LOGGER.info('Searching')
    query_rows = []
    dep_list = []
    with open(path, "r+") as query:
        # Reading from a file
        query_rows = query.read().split("\n")
        LOGGER.info(f'query has {len(query_rows)} rows')
    if len(query_rows) == 0:
        LOGGER.warning("Query has no rows")
    for row in query_rows:
        row = row.replace(" ", "").lower()
        is_from = row.split("from")
        if len(is_from) > 1:
            for part in is_from:
                if len(part.split(".")) > 2:
                    LOGGER.info(str(part))
                    dep_list.append(part)
    
    return dep_list