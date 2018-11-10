#!/bin/bash

set -e

source .env

gunzip -c .temp/$(basename $IMAGE_NAME).tgz | docker load
