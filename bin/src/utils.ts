import { spawnSync } from 'child_process'
import path from 'path'

export const DOTFILES_ROOT = path.resolve(__dirname, '../..')

export const getDotfilesPath = (...paths: string[]) =>
  path.resolve(DOTFILES_ROOT, ...paths)

export function run(command: string) {
  const [exe, ...args] = command.split(' ')
  spawnSync(exe, args, { stdio: 'inherit' })
}
