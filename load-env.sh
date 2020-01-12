#!/bin/bash

set -e

while IFS="=" read -r name value; do
    if [[ ! -z "$name" && "$name" != "#"* ]]; then
        existing_value="${!name}"
        if [ -z "$existing_value" ]; then
            declare $name="$value"
        fi
    fi
done < .env
