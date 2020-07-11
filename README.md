# embin

This repository contains the prebuilt Emscripten releases repackaged for the npm registry (releases are automated and done daily, so even if this repo doesn't get content update it should still stay relevant). It makes it possible to list them as dependencies in your application:

```
yarn add embin-linux
```

**Note:** This package requires to use Yarn 2.2+ or npm. Prior releases are known to have some issues with how symlinks are stored.

## Usage

Once the dependency is added, just use `yarn embin emcc` to run the Emscripten compiler.
