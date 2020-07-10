#!/usr/bin/env bash

set -e
set -x

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BUILD_DIR="$(mktemp -d)"

EMSDK_MANIFEST="$(curl https://raw.githubusercontent.com/emscripten-core/emsdk/master/emscripten-releases-tags.txt)"

EMSCRIPTEN_TAG="${EMSCRIPTEN_TAG:-$(jq -r .latest <<< "$EMSDK_MANIFEST")}"
RELEASE_TAG="${RELEASE_TAG:-$EMSCRIPTEN_TAG}"

PREBUILD_TAG="$(jq -r ".releases[\"$EMSCRIPTEN_TAG\"]" <<< "$EMSDK_MANIFEST")"

PLATFORM=linux

# Create the basic repository
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
yarn init -2

# Install the release
wget -q https://storage.googleapis.com/webassembly/emscripten-releases-builds/"$PLATFORM"/"$PREBUILD_TAG"/wasm-binaries.tbz2
tar xf wasm-binaries.tbz2

# Remove various useless items
rm -rf install/emscripten/{tests,docs,site,media,.github,.circleci}
rm -f wasm-binaries.tbz2

# Copy the files
rsync -azh "$THIS_DIR"/static/ "$BUILD_DIR"

# Inject the variables
jq ". + {\"name\": \"embin-$PLATFORM\", \"version\": \"$RELEASE_TAG\"}" package.json | sponge package.json

# Publish time!
yarn npm publish --tolerate-republish
