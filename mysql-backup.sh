#!/bin/bash

set -e

source ./load-env.sh


CURRENT_DATE_STR="`date +%F`"
CURRENT_BACKUP_DIR="$BACKUP_DIR/$CURRENT_DATE_STR"

CURRENT_MYSQL_BACKUP_FILE="$CURRENT_BACKUP_DIR/nextcloud-mysql-backup.sql"


docker-compose exec mysql \
    mysqldump --single-transaction -h localhost \
    --user="$MYSQL_USER" \
    --password="$MYSQL_PASSWORD" \
    --port=3306 \
    --databases \
    "$MYSQL_DATABASE" \
    | tee "$CURRENT_MYSQL_BACKUP_FILE"

echo "saved to: $CURRENT_MYSQL_BACKUP_FILE"