#!/usr/bin/env sh
#shellcheck shell=sh

set -xe

REPO=fredclausen
IMAGE=uat2esnt
PLATFORMS="linux/amd64,linux/arm/v7,linux/arm64"

docker context use default
export DOCKER_CLI_EXPERIMENTAL="enabled"
docker buildx use cluster

# Build & push latest
docker buildx build --no-cache -t "${REPO}/${IMAGE}:latest" --compress --push --platform "${PLATFORMS}" .