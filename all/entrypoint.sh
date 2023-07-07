#!/bin/bash

service nginx start
service mariadb start
service redis-server start
service supervisor start

supervisorctl update
supervisorctl restart all

/judge/.docker/entry run -c /judge.yml localhost -a 10000
