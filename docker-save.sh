#!/bin/bash

set -e

source .env

mkdir -p .temp

docker save $IMAGE_NAME | gzip -c > .temp/$(basename $IMAGE_NAME).tgz
