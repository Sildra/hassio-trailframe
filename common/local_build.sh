#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."

ADDON=${1:-trailframe-edge}

cp common/Dockerfile "$ADDON/"
cp -R common/rootfs "$ADDON/"
cp common/build.yaml "$ADDON/"

docker run --rm --privileged \
  -v "$(pwd)/$ADDON:/data" homeassistant/amd64-builder --amd64 -t /data --no-cache

rm -rf "$ADDON/rootfs"
rm "$ADDON/Dockerfile"
rm "$ADDON/build.yaml"
