FROM centos:centos7

MAINTAINER "Olimpiu Rob" <olimpiu.rob@eaudeweb.ro>

ENV ZEO_HOME=/opt/zeoserver

RUN yum -y updateinfo && yum -y install \
    wget \
    make \
    gcc \
    gcc-c++ \
    tar \
    python \
    python-devel \
    openssl-devel* && \
    yum clean all && \
    mkdir -p $ZEO_HOME

COPY src/base.cfg                            $ZEO_HOME/base.cfg
COPY src/versions.cfg                        $ZEO_HOME/versions.cfg
COPY src/bootstrap.py                        $ZEO_HOME/
COPY src/start.sh                            /usr/bin/start
COPY src/configure.py                        /configure.py

WORKDIR $ZEO_HOME

RUN python bootstrap.py -v 2.2.1 --setuptools-version=7.0 -c base.cfg && \
    ./bin/buildout -c base.cfg && \
    groupadd -g 500 zope-www && \
    useradd -u 500 -g 500 -m -s /bin/bash zope-www && \
    chown -R 500:500 $ZEO_HOME

VOLUME $ZEO_HOME/var/

USER zope-www

CMD ["start"]
