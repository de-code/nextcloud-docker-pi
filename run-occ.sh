#!/bin/bash

set -e

source .env

# see https://docs.nextcloud.com/server/14/admin_manual/configuration_server/occ_command.html

docker-compose exec -u www-data nextcloud-rpi php occ $@
