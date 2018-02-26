FROM python:3.6-slim

RUN pip install elasticsearch-curator urllib3[secure]
ADD ./docker-entrypoint.sh /
ADD ./config/curator.yaml /opt/curator/config/curator.yaml
ADD ./config/action.yaml /opt/curator/config/action.yaml

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/curator" ]
