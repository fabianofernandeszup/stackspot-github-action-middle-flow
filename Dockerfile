FROM ubuntu

RUN apt-get update \
    && apt-get install -y curl git uuid-runtime

RUN adduser --disabled-password --gecos '' stk
RUN uuid=$(uuidgen) \
&& echo ${uuid} > /etc/machine-id
USER stk

WORKDIR /home/stk

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONIOENCODING utf-8

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]


