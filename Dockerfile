FROM alpine:3.7

RUN apk add --no-cache python2 py-pip

RUN pip install elasticsearch-curator
ADD ./docker-entrypoint.sh /
ADD ./config /opt/curator/config

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/curator" ]
