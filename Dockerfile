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

COPY base.cfg                            $ZEO_HOME/base.cfg
COPY zope-2.13.23-versions.cfg           $ZEO_HOME/zope-2.13.23-versions.cfg
COPY bootstrap.py                        $ZEO_HOME/
COPY start.sh                            /usr/bin/start
COPY configure.py                        /configure.py

WORKDIR $ZEO_HOME

RUN python bootstrap.py -v 2.2.1 --setuptools-version=7.0 -c base.cfg && \
    ./bin/buildout -c base.cfg && \
    groupadd -g 500 zope-www && \
    useradd -u 500 -g 500 -m -s /bin/bash zope-www && \
    chown -R 500:500 $ZEO_HOME

VOLUME $ZEO_HOME/var/

USER zope-www

CMD ["start"]
