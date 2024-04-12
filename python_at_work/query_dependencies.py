import logging
import re


LOGGER = logging.getLogger(__name__)

def dependency_list(path: str) -> list[str]:
    query_rows = []
    res = []
    with open(path, "r+") as query:
        # Reading from a file
        query_rows = query.read().split("\n")
    for row in query_rows:
        filtered = re.findall(r'\`([^`]*)\`', row)
        if filtered:
            res.extend(filtered)
    return res
