FROM python:3.6-slim

RUN pip install --quiet elasticsearch-curator urllib3[secure]
ADD ./docker-entrypoint.sh /
ADD ./config/curator.yml /opt/curator/config/curator.yml
ADD ./config/action.yml /opt/curator/config/action.yml

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/curator" ]
