# coding: utf8

from datetime import date
from datetime import timedelta
from elasticsearch import Elasticsearch
import json
import os
import sys

# read environment variables
elasticsearch_host = os.getenv("ELASTICSEARCH_HOST", "elasticsearch:9200")
retention_days = int(os.getenv("RETENTION_DAYS", "14"))
index_name_prefix = os.getenv("INDEX_NAME_PREFIX", "fluentd- gslogs-")
index_name_timeformat = os.getenv("INDEX_NAME_TIMEFORMAT", "%Y.%m.%d")


def log(level="info", message="", extra=None):
    """
    Prints a JSON-formatted log message
    """
    msg = {
        "level": level,
        "message": message
    }
    if extra is not None:
        msg["extra"] = extra
    print(json.dumps(msg))


def get_valid_indices(nameprefix, retention_days, timeformat):
    """
    Returns a set of valid index names to keep
    """
    out = set()
    for n in range(retention_days):
        today = date.today() - timedelta(days=n)
        index_name_format = nameprefix + timeformat
        string = today.strftime(index_name_format)
        out.add(string)
    return out


def main():
    global index_name_prefix
    global retention_days
    global index_name_timeformat
    global elasticsearch_host

    # Initial validation

    if retention_days < 1:
        log("error", "Retention period in days is too short (RETENTION_DAYS=%d)" % retention_days)
        sys.exit(1)

    if index_name_prefix == "":
        log("error", "Index name prefix is empty (INDEX_NAME_PREFIX='')")
        sys.exit(1)

    if index_name_timeformat == "":
        log("error", "Index name time format is empty (INDEX_NAME_TIMEFORMAT='')")
        sys.exit(1)

    if elasticsearch_host == "":
        log("error", "Elasticsearch host is empty (ELASTICSEARCH_HOST='')")
        sys.exit(1)

    # index name prefixes from space-separated string
    index_name_prefix_list = index_name_prefix.split()

    for index_name_prefix in index_name_prefix_list:

        log("info", "Removing indices with name format '{prefix}{timeformat}' older than {days} days from host '{host}'".format(
            prefix=index_name_prefix,
            timeformat=index_name_timeformat,
            days=retention_days,
            host=elasticsearch_host,
        ))

        # Create a set of names with index names that should be kept for now
        valid = get_valid_indices(index_name_prefix, retention_days, index_name_timeformat)
        if len(valid) == 0:
            log("error", "The current index name settings yield no index names to retain")
            sys.exit(1)

        try:
            es = Elasticsearch([elasticsearch_host])
        except Exception as e:
            log("error", "Could not connect to elasticsearch", extra={
                "exception": e
            })
            sys.exit(1)

        searchterm = index_name_prefix + "*"

        try:
            indices = es.indices.get(searchterm)
        except Exception as e:
            log("error", "Could not list indices for '%s'" % searchterm, extra={
                "exception": e
            })
            sys.exit(1)

        if len(indices) == 0:
            log("info", "No indices found")
            sys.exit()

        for index in es.indices.get(searchterm):
            if index not in valid:
                try:
                    es.indices.delete(index=index)
                    log("info", "Deleted index %s" % index)
                except Exception as e:
                    log("error", "Error deleting index '%s'" % index, extra={
                        "exception": e
                    })


if __name__ == "__main__":
    main()
