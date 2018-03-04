import chalk from 'chalk';
import { resolve } from 'path';
import { cwd } from 'process';
import PackageConfig from './package-config';
import * as logger from './logger';

export const parserOptions = {
  alias: { help: 'h' },
  boolean: [
    'dev',
    'peer',
    'prod',
    'raw',
  ],
};

export default function main(args) {
  if (args.help) {
    logger.help();
    return true;
  }

  const config = new PackageConfig();
  const remotePackage = args._.length > 0 ? args._[0] : null;
  const localManifest = resolve(cwd(), 'package.json');

  try {
    if (remotePackage) config.loadRemotePackage(remotePackage);
    else config.loadLocalPackage(localManifest);

    if (args.raw) {
      const deps = [].concat(
        config.getDependencies(),
        config.getDependencies('dev'),
        config.getDependencies('peer'),
      );
      logger.depsRaw(deps);

      return true;
    }

    const showAll = !(args.dev || args.prod || args.peer);
    if (showAll || args.prod) {
      logger.deps('Production', config.getDependencies());
    }
    if (showAll || args.dev) {
      logger.deps('Development', config.getDependencies('dev'));
    }
    if (showAll || args.peer) {
      logger.deps('Peer', config.getDependencies('peer'));
    }
  } catch ({ message }) {
    console.log(`${chalk.red.bold('Error')}: ${message}`);
    return false;
  }

  return true;
}

