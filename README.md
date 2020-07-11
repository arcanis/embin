# embin

![](https://img.shields.io/npm/v/embin-linux)

This repository contains the prebuilt Emscripten releases repackaged for the npm registry (releases are automated and done daily, so even if this repo doesn't get content update it should still stay relevant). It makes it possible to list them as dependencies in your application:

```
yarn add embin-linux
```

**Note:** This package requires to use Yarn 2.2+ (preferred) or npm. Prior releases are known to have some issues with how symlinks are stored. You can upgrade Yarn by running [`yarn set version 2`](https://yarnpkg.com/cli/set/version) in your project repository.

## Usage

Once the dependency is added, just use `yarn embin emcc` to run the Emscripten compiler.
