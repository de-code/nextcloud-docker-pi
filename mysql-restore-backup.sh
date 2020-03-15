#!/bin/bash

set -e

source ./load-env.sh

MYSQL_BACKUP_FILE="$1"

if [ -z "${MYSQL_BACKUP_FILE}" ]; then
    echo "Usage: $0 <backup file>"
    exit 1
fi

if [ ! -f "${MYSQL_BACKUP_FILE}" ]; then
    echo "Backup file does not exist: ${MYSQL_BACKUP_FILE}"
    exit 2
fi

cat "$MYSQL_BACKUP_FILE" \
| docker-compose exec -T mysql \
    mysql \
    --user="root" \
    --password="$MYSQL_ROOT_PASSWORD"

echo "restored: $MYSQL_BACKUP_FILE"
