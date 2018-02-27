FROM alpine:3.7

RUN apk add --no-cache python2 py-pip

RUN pip install elasticsearch

ADD ./curator.py /curator.py

ENTRYPOINT ["python", "/curator.py"]
