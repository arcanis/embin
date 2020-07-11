#!/usr/bin/env node

const cp = require(`child_process`);
const os = require(`os`);
const path = require(`path`);

const manifest = require(`./package.json`);

main();

const richFormat = process.stdout.isTTY ? {
    error: str => `\x1b[31m\x1b[1m${str}\x1b[22m\x1b[39m`,
    code: str => `\x1b[36m${str}\x1b[39m`,
} : {
    error: str => str,
    code: str => str,
};;

function error(name, message) {
    console.log(`${richFormat.error(name)}: ${message}`);
    process.exitCode = 1;
}

function errorStack(error) {
    console.log(error.stack);
    process.exitCode = 1;
}

function main() {
    if (process.argv.length <= 2)
	return error(`Usage`, `yarn embin <emcc|em++|emar|...> [...args]`);

    const platform = os.platform();
    if (!Object.prototype.hasOwnProperty.call(manifest.peerDependencies, `embin-${platform}`))
	return error(`Unsupported platform`, `only linux, darwin, and win32 are supported`);

    const config = require(`embin-${platform}`);

    const env = {...process.env};
    env.PATH = [...config.PATH, env.PATH].join(path.delimiter);
    env.EM_CONFIG = config.EM_CONFIG;
    
    const sub = cp.spawn(process.argv[2], process.argv.slice(3), {
	stdio: `inherit`,
	env,
    });

    sub.on(`error`, err => {
	if (err.code === `ENOENT`) {
	    error(`Command not found`, `did you mean to call ${richFormat.code(`yarn embin emcc ${process.argv.slice(2).join(' ')}`)}`);
	} else {
	    errorStack(err.stack);
	}
    });
    
    sub.on(`exit`, (code, signal) => {
	process.exitCode = code != null ? code : 1;
    });
}
