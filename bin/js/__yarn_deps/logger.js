import chalk from 'chalk';

export function deps(label, dependencies) {
  if (dependencies.length === 0) return;
  console.log(chalk.green.bold.underline(`${label} Dependencies:`));
  for (const dep of dependencies) console.log(`  ${dep}`);
}

export function depsRaw(dependencies) {
  for (const dep of dependencies) console.log(dep);
}

export function help() {
  const output = [
    'Usage: yarn deps [flags] [package]',
    '',
    'Arguments:',
    '  package - A remote package to inspect.',
    '',
    'Flags:',
    '  --dev   - Lists only development dependencies',
    '  --peer  - Lists only peer dependencies',
    '  --prod  - Lists only production dependencies',
    '  --raw   - Prints dependencies without labels, indentation, and coloring',
  ].join('\n');

  console.log(output);
}

