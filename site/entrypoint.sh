#!/bin/bash

service mariadb start
service redis-server start
service supervisor start

supervisorctl update
supervisorctl restart all

bash
