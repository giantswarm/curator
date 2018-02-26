FROM python:3.6-slim

RUN pip install elasticsearch-curator urllib3[secure]
ADD ./docker-entrypoint.sh /
ADD ./config/curator.yml /opt/curator/config/curator.yaml
ADD ./config/action.yml /opt/curator/config/action.yaml

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/curator" ]
