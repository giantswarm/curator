# coding: utf8

import os
import sys
from elasticsearch import Elasticsearch
from datetime import date
from datetime import timedelta

# read environment variables
elasticsearch_host = os.getenv("ELASTICSEARCH_HOST", "elasticsearch:9200")
retention_days = int(os.getenv("RETENTION_DAYS", "14"))
index_name_prefix = os.getenv("INDEX_NAME_PREFIX", "fluentd-")
index_name_timeformat = os.getenv("INDEX_NAME_TIMEFORMAT", "%Y.%m.%d")

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



if __name__ == "__main__":
    print("Removing indices with name format '{prefix}{timeformat}' older than {days} days from host '{host}'".format(
        prefix=index_name_prefix,
        timeformat=index_name_timeformat,
        days=retention_days,
        host=elasticsearch_host,
    ))

    valid = get_valid_indices(index_name_prefix, retention_days, index_name_timeformat)

    es = Elasticsearch([elasticsearch_host])

    searchterm = index_name_prefix + "*"
    for index in es.indices.get(searchterm):
        if index not in valid:
            try:
                es.indices.delete(index=index)
                print("Deleted index %s" % index)
            except Exception, e:
                print("Error deleting index '%s': %s" % (index, e))
