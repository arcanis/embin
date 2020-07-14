# embin

![](https://img.shields.io/npm/v/embin-linux)

This repository contains the prebuilt Emscripten releases repackaged for the npm registry (releases are automated and done daily, so even if this repo doesn't get content update it should still stay relevant). It makes it possible to list them as dependencies in your application:

```
yarn add embin-linux
```

**Note:** This package requires to use Yarn 2.2+ (preferred) or npm. Prior releases are known to have some issues with how symlinks are stored. You can upgrade Yarn by running [`yarn set version 2`](https://yarnpkg.com/cli/set/version) in your project repository.

## Usage

Once the dependency is added, just use `yarn embin emcc` to run the Emscripten compiler.

You can also use [`yarn dlx`](https://yarnpkg.com/cli/dlx), but note that the run may be slow from time to time as Yarn will periodically fetch the new embin releases, which can be pretty heavy:

```
yarn dlx -p embin-linux embin emcc -h
```

## Cross platform

To add support for other platforms than Linux, just add the relevant package to your dependencies (in the case of OSX, it'll be `embin-darwin`). Note that all versions will be fetched from the registry, so the cold cache install will be increasingly slower. To offset this, you can use [zero-installs](https://yarnpkg.com/features/zero-installs), or wait for us to implement native package flavor mechanisms in Yarn.

> Note that Embin repackages the Linux and Darwin prebuilt Emscripten releases, but not the Windows one which is much too heavy at the moment (more than a gigabyte unpacked).
