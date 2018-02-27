# coding: utf8

# This script creates a bunch of indices in elasticsearch

import elasticsearch
from datetime import timedelta
from datetime import date
from elasticsearch import Elasticsearch


es = Elasticsearch(["localhost:9200"])

try:
    es.indices.create(index=".kibana")
except:
    pass

for n in range(30):
    today = date.today() - timedelta(days=n)
    string = today.strftime("fluentd-%Y.%m.%d")
    print(string)
    try:
        es.indices.create(index=string)
    except:
        pass
