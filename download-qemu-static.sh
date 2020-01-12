#!/bin/bash

set -e

source .env

mkdir -p .docker-temp

pushd .docker-temp \
  && curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v2.6.0/qemu-arm-static.tar.gz \
  && tar xzf qemu-arm-static.tar.gz \
  && popd
