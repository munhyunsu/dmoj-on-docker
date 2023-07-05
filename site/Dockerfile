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
    apt install -y git gcc g++ make pkg-config wget python3-dev python3-pip python3-venv libxml2-dev libxslt1-dev zlib1g-dev gettext curl redis-server nodejs mariadb-server mariadb-client libmariadb-dev supervisor nginx

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt -y dist-upgrade && \
    npm install -g sass postcss-cli postcss autoprefixer qu ws simplesets

COPY initialize.sql /workspace/initialize.sql

RUN --mount=type=bind,source=initialize.sql,target=/workspace/initialize.sql \
    service mariadb start && \
    mariadb < /workspace/initialize.sql

RUN cd /workspace && \
    python3 -m venv venv_site && \
    git clone https://github.com/DMOJ/site.git && cd site && \ 
    git checkout v4.0.0 && git submodule init && git submodule update && \
    /workspace/venv_site/bin/pip3 install --upgrade pip wheel && \
    /workspace/venv_site/bin/pip3 install --upgrade -r requirements.txt && \
    /workspace/venv_site/bin/pip3 install --upgrade mysqlclient uwsgi redis websocket-client

COPY local_settings.py /workspace/site/dmoj/local_settings.py

RUN --mount=type=bind,source=local_settings.py,target=/workspace/site/dmoj/local_settings.py \
    service mariadb start && \
    cd /workspace/site && \
    ./make_style.sh && \
    /workspace/venv_site/bin/python3 manage.py collectstatic && \
    /workspace/venv_site/bin/python3 manage.py compilemessages && \
    /workspace/venv_site/bin/python3 manage.py compilejsi18n && \
    /workspace/venv_site/bin/python3 manage.py migrate && \
#    /workspace/venv_site/bin/python3 manage.py loaddata navbar && \
    /workspace/venv_site/bin/python3 manage.py loaddata language_all && \
#    /workspace/venv_site/bin/python3 manage.py loaddata demo && \
    DJANGO_SUPERUSER_USERNAME="admin" DJANGO_SUPERUSER_EMAIL="admin@example.com" DJANGO_SUPERUSER_PASSWORD="admin" /workspace/venv_site/bin/python3 manage.py createsuperuser --noinput

COPY uwsgi.ini /workspace/site/uwsgi.ini
COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY celery.conf /etc/supervisor/conf.d/celery.conf
COPY config.js /workspace/site/websocket/config.js
COPY nginx.conf /etc/nginx/sites-available/dmojsite

RUN rm /etc/nginx/sites-enabled/default && \
    ln -s ../sites-available/dmojsite /etc/nginx/sites-enabled/dmojsite

WORKDIR /workspace

COPY entrypoint.sh /workspace/entrypoint.sh

ENTRYPOINT ["/workspace/entrypoint.sh"]
