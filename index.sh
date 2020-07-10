#!/usr/bin/env bash

set -e
set -x

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BUILD_DIR="$(mktemp -d)"

EMSCRIPTEN_TAG=1.39.19
RELEASE_TAG=665121d026cafc46c29b30d6d4c45ed73eedbb7e

PLATFORM=linux

# Create the basic repository
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
yarn init -2

# Install the release
wget -q https://storage.googleapis.com/webassembly/emscripten-releases-builds/"$PLATFORM"/"$RELEASE_TAG"/wasm-binaries.tbz2
tar xf wasm-binaries.tbz2

# Remove various useless items
rm -rf install/emscripten/{tests,docs,site,media,.github,.circleci}
rm -f wasm-binaries.tbz2

# Copy the files
rsync -azh "$THIS_DIR"/static/ "$BUILD_DIR"

# Inject the variables
jq ". + {\"name\": \"embin-$PLATFORM\", \"version\": \"$EMSCRIPTEN_TAG\"}" package.json | sponge package.json

# Publish time!
yarn npm publish
