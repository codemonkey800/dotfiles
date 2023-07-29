#!/usr/bin/env tsx

import path from 'path'

import { Script } from './types'

interface ScriptModule {
  script: Script
}

const SCRIPT_NAME = `./scripts/${path.basename(process.argv[1])}`

async function main() {
  let script: Script

  try {
    const module = (await import(SCRIPT_NAME)) as ScriptModule
    script = module.script
  } catch (err) {
    console.error(`Script "${SCRIPT_NAME}" not found.`)
    throw err
  }

  script.getAutocomplete?.().init()
  await script.run()
}

main().catch(err => {
  console.error(`Error running script "${SCRIPT_NAME}":`, err)
  process.exit(-1)
})
