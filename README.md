[![CircleCI](https://circleci.com/gh/giantswarm/curator.svg?style=svg&circle-token=706c3ae485e0c0d5d577eb67af13e67ea1fd90dd)](https://circleci.com/gh/giantswarm/curator) [![Docker Repository on Quay](https://quay.io/repository/giantswarm/curator/status "Docker Repository on Quay")](https://quay.io/repository/giantswarm/curator)

# Elasticsearch Curator

Docker image wrapping [Elasticsearch curator](https://github.com/elastic/curator)

## Configuration

The following environment variables can be used for configuration:

- `ES_HOST`: Name of the host that's running elasticsearch (default: `elasticsearch`)
- `ES_PORT`: Port number where the elasticsearch service is reachable (default: `9200`)
- `INDEX_NAME_PREFIX`: Name prefix of the temporal index (default: `fluentd-`)
- `TIMESTRING`: Temporal string format in the index name (default: `%Y.%m.%d`)
- `DELETE_UNIT`: Temporal unit for indexes (default: `days`)
- `DELETE_UNIT_COUNT`: Number of indexes to keep (default: `14`)
- `KIBANA_INDEX`: default `.kibana`

The result will be used in `docker-entrypoint.sh` to overwrite config file
settings as stored in `config/*`.

## Build

```nohighlight
docker build -t curator .
```

## Usage

```nohighlight
docker run --rm -ti curator \
  --config /opt/curator/config/curator.yaml
  /opt/curator/config/action.yaml
```
