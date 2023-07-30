import 'zx/globals'

import { program } from 'commander'
import fs from 'fs-extra'
import om from 'omelette'
import os from 'os'
import path from 'path'

import { Script } from 'src/types'

import { run } from '../utils'

const ME_REPO = path.resolve(os.homedir(), 'dev/me/magiceden')

class MagicEdenCLI implements Script {
  private getAllPackages() {
    return fs.readdirSync(`${ME_REPO}/js/packages`)
  }

  private validatePackage(name: string) {
    const packages = this.getAllPackages()
    return packages.includes(name)
  }

  private async buildForPackage() {
    const packageName = program.args[1]
    console.log(`Building for package "${packageName}"`)

    cd(`${ME_REPO}/js`)
    run('pnpm i')
    run(`pnpm build --filter=${packageName}^...`)
  }

  private async cleanInstall() {
    console.log('clean install', program.args)
    run('pnpm clean')
    run('pnpm cleanAll')
  }

  async run() {
    program.description('Magic Eden CLI')

    program
      .command('build-package')
      .description('Builds all dependencies for a package')
      .argument('<package>', 'Package to build dependencies for.', name =>
        this.validatePackage(name),
      )
      .option('--clean', 'Cleans repo before building for package')
      .action(() => this.buildForPackage())

    program
      .command('clean')
      .description('Cleans entire repo of dependnecies + caches')
      .action(() => this.cleanInstall())

    await program.parseAsync()
  }

  getAutocomplete() {
    return om`me-cli ${['build-package', 'clean']} ${({
      line,
      before,
      reply,
    }) => {
      // Allow partial completions
      if (line.includes('me-cli build-package') && before !== 'build-package') {
        const packages = this.getAllPackages()
        reply(packages.filter(pkg => pkg.includes(before)))
        return
      }

      switch (before) {
        case 'help':
          reply(['build-package', 'clean'])
          break
        case 'build-package':
          reply(this.getAllPackages())
          break
        default:
          reply([])
      }
    }}`
  }
}

export const script = new MagicEdenCLI()
