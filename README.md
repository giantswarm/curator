[![CircleCI](https://circleci.com/gh/giantswarm/curator.svg?style=shield&circle-token=706c3ae485e0c0d5d577eb67af13e67ea1fd90dd)](https://circleci.com/gh/giantswarm/curator) [![Docker Repository on Quay](https://quay.io/repository/giantswarm/curator/status "Docker Repository on Quay")](https://quay.io/repository/giantswarm/curator)

# Curator for Elasticsearch

Simplistic cousin of [Elasticsearch curator](https://github.com/elastic/curator),
created for one purpose only: Delete log indices created by fluentd which are
older than a certain number of days.

## Configuration

The following environment variables can be used for configuration:

- `ELASTICSEARCH_HOST`: Name of the host that's running elasticsearch (default: `elasticsearch:9200`)
- `RETENTION_DAYS`: Number of days to keep indices for (default: `14`)
- `INDEX_NAME_PREFIX`: Name prefix of the temporal index (default: `fluentd-`). This can also be a space-separated list of names, which means that there are several indexes per temporal unit.
- `INDEX_NAME_TIMEFORMAT`: Temporal string format in the index name (default: `%Y.%m.%d`)
