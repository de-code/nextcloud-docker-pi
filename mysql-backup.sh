#!/bin/bash

set -e

source ./load-env.sh


CURRENT_DATE_STR="`date +%Y-%m-%d_%H-%M`"
CURRENT_BACKUP_DIR="$BACKUP_DIR/$CURRENT_DATE_STR-mysql"

CURRENT_MYSQL_BACKUP_FILE="$CURRENT_BACKUP_DIR/nextcloud-mysql-backup.sql"


mkdir -p "$CURRENT_BACKUP_DIR"


docker-compose exec -T mysql \
    mysqldump --single-transaction -h localhost \
    --user="root" \
    --password="$MYSQL_ROOT_PASSWORD" \
    --port=3306 \
    --databases \
    "$MYSQL_DATABASE" \
    | tee "$CURRENT_MYSQL_BACKUP_FILE"

gzip "$CURRENT_MYSQL_BACKUP_FILE"
echo "saved to: $CURRENT_MYSQL_BACKUP_FILE.gz"
