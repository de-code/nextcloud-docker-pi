#!/bin/bash

set -e

source .env

output_file=".temp/$(basename $IMAGE_NAME).tgz"

echo "saving $IMAGE_NAME to $output_file"

mkdir -p "$(dirname $output_file)"
docker save $IMAGE_NAME | gzip -c > .temp/$(basename $IMAGE_NAME).tgz
