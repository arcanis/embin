const path = require(`path`);

module.exports.PATH = [
    path.join(__dirname, `install/emscripten`),
];
    
module.exports.EM_CONFIG = [
    `NODE_JS = '${process.execPath}'\n`,
    `LLVM_ROOT = '${path.join(__dirname, 'install/bin')}'\n`,
    `BINARYEN_ROOT = '${path.join(__dirname, 'install')}'\n`,
    `EMSCRIPTEN_ROOT = '${path.join(__dirname, 'install/emscripten')}'\n`,
    `CLOSURE_COMPILER = [NODE_JS, '${path.join(__dirname, 'gcc.js')}']\n`,
].join(``);
