# embin

This repository contains the prebuilt Emscripten releases repackaged for the npm registry (releases are automated and done daily, so even if this repo doesn't get content update it should still stay relevant). It makes it possible to list them as dependencies in your application:

```
yarn add embin-linux
```

## Usage

Once the dependency is added, just use `yarn embin emcc` to run the Emscripten compiler.
