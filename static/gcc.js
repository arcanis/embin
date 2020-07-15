// We require this file because Emscripten checks for the google-closure-compiler
// existence, but it does so from Python. Since Python isn't aware of the zip layer,
// it would report that the file doesn't exist. Since embin is always unplugged, we
// use this indirection file that ensures that Python always see GCC as being there.
require(`google-closure-compiler/cli`);
