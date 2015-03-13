FROM debian:wheezy

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y python2.7 python-pip

RUN pip install elasticsearch-curator==3.0.0

ENTRYPOINT ["curator"]
