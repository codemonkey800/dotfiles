import { program } from 'commander'

import { Script } from '../types'

class NewScript implements Script {
  async run() {
    program.command('TBD').description('TBD').argument('<tbd>', 'tbd').parse()
  }
}

export const script = new NewScript()
