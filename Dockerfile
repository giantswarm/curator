FROM alpine:3.7

RUN apk add --no-cache python2 py-pip

RUN pip install elasticsearch-curator
ADD ./docker-entrypoint.sh /
ADD ./config/curator.yaml /opt/curator/config/curator.yaml
ADD ./config/action.yaml /opt/curator/config/action.yaml

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/curator" ]
