#!/usr/bin/env bash

set -e
set -x

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BUILD_DIR="$(mktemp -d)"

EMSDK_MANIFEST="$(curl https://raw.githubusercontent.com/emscripten-core/emsdk/master/emscripten-releases-tags.txt)"

EMSCRIPTEN_TAG="${EMBIN_EMSCRIPTEN_TAG:-$(jq -r .latest <<< "$EMSDK_MANIFEST")}"
RELEASE_TAG="${EMBIN_RELEASE_TAG:-$EMSCRIPTEN_TAG}"

PREBUILD_TAG="$(jq -r ".releases[\"$EMSCRIPTEN_TAG\"]" <<< "$EMSDK_MANIFEST")"

error() {
    echo "$1"
    exit 1
}

case $EMBIN_PLATFORM in
    linux) EMSCRIPTEN_PLATFORM=linux;;
    darwin) EMSCRIPTEN_PLATFORM=mac;;
    win32) EMSCRIPTEN_PLATFORM=win;;
    *) error "Invalid platform ${EMBIN_PLATFORM}";;
esac

# Create the basic repository
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
yarn init -2

# Currently required because `executableFiles` is only in master
yarn set version from sources

# Install the release
wget -q https://storage.googleapis.com/webassembly/emscripten-releases-builds/"$EMSCRIPTEN_PLATFORM"/"$PREBUILD_TAG"/wasm-binaries.tbz2
tar xf wasm-binaries.tbz2

# Remove various useless items
rm -rf install/**/__pycache__
rm -rf install/emscripten/{tests,docs,site,media,.github,.circleci}
rm -rf install/emscripten/third_party/uglify-js/test
rm -rf install/emscripten/third_party/ply/{test,example,doc}
rm -rf install/emscripten/system/lib/libunwind/docs
rm -rf install/fastcomp
rm -f wasm-binaries.tbz2

# Copy the files
rsync -azh "$THIS_DIR"/static/ "$BUILD_DIR"

# Inject the variables
jq ". + {\"name\": \"embin-$EMBIN_PLATFORM\", \"version\": \"$RELEASE_TAG\"}" package.json | sponge package.json
jq ".peerDependencies[] = \"$RELEASE_TAG\"" package.json | sponge package.json

# Get the list of executable files and add them to publishConfig.executableFiles
EXECUTABLES=$(find . -type f -executable | jq -R -s -c 'split("\n")[:-1]')
jq ". * {\"publishConfig\": {\"executableFiles\": \$executableFiles}}" package.json --argjson executableFiles "${EXECUTABLES}" | sponge package.json

# Publish time!
yarn
yarn npm publish --tolerate-republish
