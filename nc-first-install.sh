#!/bin/bash

set -ex

source ./load-env.sh

# see https://docs.nextcloud.com/server/14/admin_manual/configuration_server/occ_command.html

docker-compose exec -u www-data nextcloud-rpi php occ \
    maintenance:install \
    --database mysql \
    --database-host "mysql" \
    --database-name "$MYSQL_DATABASE" \
    --database-user "$MYSQL_USER" \
    --database-pass "$MYSQL_PASSWORD" \
    --admin-user "$NC_ADMIN_USER" \
    $@

docker-compose exec -u root nextcloud-rpi chown www-data:root data
docker-compose exec -u root nextcloud-rpi chmod a-rw,ug+rw data
