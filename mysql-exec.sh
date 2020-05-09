#!/bin/bash

set -e

source ./load-env.sh


docker-compose exec mysql \
    mysql -h localhost \
    --user="root" \
    --password="$MYSQL_ROOT_PASSWORD" \
    --port=3306 \
    "$@"
