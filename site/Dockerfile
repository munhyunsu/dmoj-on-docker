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
    apt install -y git gcc g++ make pkg-config wget python3-dev python3-pip python3-venv libxml2-dev libxslt1-dev zlib1g-dev gettext curl redis-server nodejs mariadb-server mariadb-client libmariadb-dev supervisor

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt -y dist-upgrade && \
    npm install -g sass postcss-cli postcss autoprefixer && \
    service mariadb start

COPY initialize.sql /workspace/initialize.sql

RUN mariadb < /workspace/initialize.sql && \
    rm /workspace/initialize.sql

RUN cd /workspace && \
    python3 -m venv venv_site && source venv_site/bin/activate && \
    git clone https://github.com/DMOJ/site.git && cd site && \ 
    git checkout v4.0.0 && git submodule init && git submodile update && \
    pip3 install --upgrade pip wheel && pip3 install --upgrade -r requirements && pip3 install --upgrade mysqlclient uwsgi redis

COPY local_settings.py /workspace/site/dmoj/local_settings.py

RUN cd /workspace && source venv_site/bin/activate && cd site && \
    ./make_style.sh && 
    python3 manage.py collectstatic && \
    python3 manage.py compilemessages && \
    python3 manage.py compilejsi18n && \
    python3 manage.py migrate && \
    python3 manage.py loaddata navbar && \
    python3 manage.py loaddata language_small && \
    python3 manage.py loaddata demo && \
    DJANGO_SUPERUSER_USERNAME="superuser" DJANGO_SUPERUSER_EMAIL="superuser@example.com" DJANGO_SUPERUSER_PASSWORD="superuserpassword" python3 manage.py createsuperuser --noinput

COPY uwsgi.ini /workspace/site/uwsgi.ini
COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY celery.conf /etc/supervisor/conf.d/celery.conf
COPY config.js /workspace/site/websocket/config.js

RUN service redia-server start && service supervisor start && \
    supervisor update && supervisor restart all && \


