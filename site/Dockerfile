ARG DISTRO=debian
ARG RELEASE=bookworm
FROM ${DISTRO}:${RELEASE}

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

LABEL \
    maintainer="Hyunsu Mun" \
    org.label-schema.description="DMOJ site image" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="DNLab"

RUN apt update && apt -y upgrade && apt -y dist-upgrade && \
    apt install -y git gcc g++ make python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl redis-server nodejs mariadb-server mariadb-client supervisor

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt -y dist-upgrade && \
    npm install -g sass postcss-cli postcss autoprefixer && \
    service mariadb start

COPY initialize.sql /workspace/initialize.sql

RUN mariadb < /workspace/initialize.sql && \
    rm /workspace/initialize.sql

RUN cd /workspace && \
    git clone https://github.com/DMOJ/site.git && cd site && \ 
    git checkout v4.0.0 && git submodule init && git submodile update && \
    
