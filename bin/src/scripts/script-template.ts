import 'zx/globals'

import { program } from 'commander'

import { Script } from 'src/types'

class NewScript implements Script {
  async run() {
    program.command('TBD').description('TBD').argument('<tbd>', 'tbd').parse()
  }
}

export const script = new NewScript()
