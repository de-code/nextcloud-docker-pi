#!/bin/bash

set -e

source .env

container_id=$(docker-compose ps -q nextcloud-docker-pi)
echo "container_id=$container_id"

docker-compose exec nextcloud-docker-pi ls -l /var/www/html/config/

docker cp config/config.php $container_id:/var/www/html/config/

docker-compose exec nextcloud-docker-pi ls -l /var/www/html/config/
