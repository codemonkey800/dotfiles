import { program } from 'commander'
import dedent from 'dedent'
import fs from 'fs-extra'
import om from 'omelette'
import path from 'path'

import { Script } from '../types'
import { getDotfilesPath } from '../utils'

const MAIN_SCRIPT = getDotfilesPath('bin/src/main.ts')
const LINK_DIR = getDotfilesPath('bin')
const SCRIPT_DIR = getDotfilesPath('bin/src/scripts')
const SCRIPT_TEMPLATE = getDotfilesPath('bin/src/scripts/script-template.ts')

const SCRIPT_BLOCKLIST = new Set(['dotfiles-script', 'script-template'])

enum Command {
  Add = 'add',
  Remove = 'remove',
}

class NewDotfilesScript implements Script {
  private get command() {
    return program.args[0]
  }

  private get name() {
    return program.args[1]
  }

  private get scriptLink() {
    return getDotfilesPath(`bin/${this.name}`)
  }

  private get typescriptFile() {
    return getDotfilesPath(`bin/src/scripts/${this.name}.ts`)
  }

  private async addScript() {
    if (await fs.pathExists(this.scriptLink)) {
      throw new Error(`Script "${this.name}" already exists`)
    }

    await fs.ensureSymlink(MAIN_SCRIPT, this.scriptLink, 'file')
    fs.createReadStream(SCRIPT_TEMPLATE).pipe(
      fs.createWriteStream(this.typescriptFile),
    )

    console.log(dedent`
      Files created:
        ${this.scriptLink}
        ${this.typescriptFile}
    `)
  }

  private async removeScript() {
    let linkRemoved = false
    let scriptRemoved = false

    await Promise.allSettled(
      [this.scriptLink, this.typescriptFile].map(async file => {
        if (await fs.pathExists(file)) {
          await fs.remove(file)

          if (file === this.scriptLink) {
            linkRemoved = true
          }
          if (file === this.typescriptFile) {
            scriptRemoved = true
          }
        }
      }),
    )

    if (linkRemoved || scriptRemoved) {
      console.log(dedent`
        Files removed:
          ${linkRemoved ? this.scriptLink : ''}
          ${scriptRemoved ? this.typescriptFile : ''}
      `)
    }
  }

  private validateName(name: string) {
    if (!name) {
      throw new Error('Name not provided')
    }

    if (SCRIPT_BLOCKLIST.has(name)) {
      throw new Error(`Name "${name}" is reserved`)
    }

    return name
  }

  async run() {
    program
      .command(Command.Add)
      .description('Adds a new script')
      .argument('<name>', 'Name of the script', this.validateName)

    program
      .command(Command.Remove)
      .description('Removes an existing script')
      .argument('<name>', 'Name of the script', this.validateName)

    program.parse()

    switch (this.command) {
      case Command.Add:
        await this.addScript()
        break

      case Command.Remove:
        await this.removeScript()
        break

      default:
        break
    }
  }

  getAutocomplete() {
    return om`dotfiles-script ${['add', 'remove', 'help']} ${({ before }) => {
      if (before === 'help') {
        return ['add', 'remove']
      }

      if (before === 'remove') {
        const links = fs
          .readdirSync(LINK_DIR)
          .filter(file =>
            fs.statSync(path.resolve(LINK_DIR, file)).isSymbolicLink(),
          )
          .filter(file => file !== 'dotfiles-script')
        const scripts = fs
          .readdirSync(SCRIPT_DIR)
          .map(file => path.basename(file).replaceAll('.ts', ''))

        return Array.from(new Set([...links, ...scripts])).filter(
          name => !SCRIPT_BLOCKLIST.has(name),
        )
      }

      return ['']
    }}`
  }
}

export const script = new NewDotfilesScript()
