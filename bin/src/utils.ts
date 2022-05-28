import path from 'path'

export const DOTFILES_ROOT = path.resolve(__dirname, '../..')

export const getDotfilesPath = (...paths: string[]) =>
  path.resolve(DOTFILES_ROOT, ...paths)
