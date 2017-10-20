FROM ubuntu:14.04
MAINTAINER Jeremy Miller <jmiller@chef.io>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends curl wget ntp ntpdate && \
    rm -rf /var/lib/apt/lists/*

COPY *.deb /var/tmp/
COPY setup.sh configure_chef.sh /usr/local/bin/

VOLUME /var/opt/opscode/postgresql
VOLUME /var/log

ENTRYPOINT ["setup.sh"]
