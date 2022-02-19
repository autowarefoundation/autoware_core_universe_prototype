#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../"

# Check arg
if [ "$1" = "" ] || ! [ -f "$SCRIPT_DIR/$1/Dockerfile" ]; then
    echo -e "\e[31mPlease input a valid image name as the 1st argument.\e[m"
    exit 1
fi

target_image="$1"

# Load env
source "$WORKSPACE_ROOT/amd64.env"
if [ "$(uname -m)" = "aarch64" ]; then
    source "$WORKSPACE_ROOT/arm64.env"
fi

# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/$target_image/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "devel.tags=ghcr.io/autowarefoundation/$target_image:$rosdistro-latest" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/$target_image:$rosdistro-latest-prebuilt"
