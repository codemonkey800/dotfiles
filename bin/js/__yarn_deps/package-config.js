import chalk from 'chalk';
import { execSync as exec } from 'child_process';
import {
  existsSync as exists,
  readFileSync as readFile,
} from 'fs';

function formatPackages(deps) {
  if (!deps) return [];
  return Object
    .entries(deps)
    .map(([pkg, version]) => `${pkg}@${version}`);
}

export default class PackageConfig {
  loadLocalPackage(manifestFile) {
    if (!exists(manifestFile)) {
      throw new Error('package.json file not found!');
    }
    const data = readFile(manifestFile, 'utf-8');
    this._pkg = JSON.parse(data);
  }

  loadRemotePackage(pkg) {
    try {
      const response = exec(`yarn --json info ${pkg}`, {
        stdio: ['pipe', 'pipe', 'ignore'],
      });
      const { data } = JSON.parse(response);
      this._pkg = data;
    } catch (_) {
      throw new Error(`Unable inspect package ${chalk.green(pkg)}`);
    }
  }

  getDependencies(type = 'prod') {
    let deps = null;
    switch (type) {
      case 'dev':
        deps = formatPackages(this._pkg.devDependencies);
        break;
      case 'peer':
        deps = formatPackages(this._pkg.peerDependencies);
        break;
      default:
        deps = formatPackages(this._pkg.dependencies);
        break;
    }
    return deps;
  }
}
