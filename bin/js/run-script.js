const esm = require('@std/esm');
const parseArgs = require('minimist');
const { argv, exit } = require('process');

function loadModule(script) {
  const load = esm(module, {
    cjs: true,
    esm: 'js',
  });
  return load(script);
}

function runModule(mod, args) {
  const opts = Object.assign({}, mod.parserOptions || {});
  const scriptArgs = parseArgs(args, opts);
  const status = mod.default(scriptArgs);
  if (typeof (status) === 'number') return status;
  if (typeof (status) === 'undefined') return 0;
  return status ? 0 : -1;
}

function main(args) {
  if (args.length === 0) {
    console.log('Usage: node run-script <script>');
    return;
  }

  const script = args[0];
  const mod = loadModule(script);

  const status = runModule(mod, args.slice(1));
  exit(status);
}

main(argv.slice(2));

