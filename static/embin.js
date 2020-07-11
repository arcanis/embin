#!/usr/bin/env node

const cp = require(`child_process`);
const path = require(`path`);

const env = {...process.env};

env.PATH = [
    path.join(__dirname, `install/emscripten`),
    env.PATH,
].join(path.delimiter);

env.EM_CONFIG = [
    `NODE_JS = '${process.execPath}'\n`,
    `LLVM_ROOT = '${path.join(__dirname, 'install/bin')}'\n`,
    `BINARYEN_ROOT = '${path.join(__dirname, 'install')}'\n`,
    `EMSCRIPTEN_ROOT = '${path.join(__dirname, 'install/emscripten')}'\n`,
].join(``);

const sub = cp.spawn(process.argv[2], process.argv.slice(3), {
    stdio: `inherit`,
    env,
});

sub.on(`exit`, (code, signal) => {
    process.exitCode = code ?? 1;
});
