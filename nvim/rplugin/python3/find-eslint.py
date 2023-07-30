import neovim
import os.path as path


@neovim.plugin
class FindEslintPlugin:
    def __init__(self, nvim):
        self.nvim = nvim

    @neovim.function('FindEslint', sync=True)
    def find_eslintd(self, args):
        file = self.nvim.current.buffer.name
        if not file:
            return ''

        parent_dir = path.dirname(file)
        while True:
            next_dir = path.dirname(parent_dir)
            if parent_dir == next_dir:
                return ''

            eslint = path.join(parent_dir, 'node_modules/.bin/eslint')
            if path.exists(eslint):
                return eslint

            parent_dir = next_dir
