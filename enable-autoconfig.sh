#!/bin/bash

set -e

source .env

container_id=$(docker-compose ps -q nextcloud-rpi)

docker cp 14.0/apache/config/autoconfig.php $container_id:/var/www/html/config/

docker-compose exec nextcloud-rpi ls -l /var/www/html/config/
