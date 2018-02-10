import os.path as path
import plumbum.cli as cli

from glob import glob
from plumbum import FG, local as sh

CONFIG_FILE = sh.path(path.expandvars('$DOTFILES/share/shittyfiles'))


def expand_path(p):
    '''Expands a path's glob and tilde syntax if they're present.'''
    return glob(path.expanduser(p))


class App(cli.Application):
    '''
        A script for removing user defined shitty files.  Also has support for
        directory specific shitty config files.
    '''

    PROGNAME = 'rmshit'
    VERSION = '0.2.0'

    config = cli.SwitchAttr(
        ['-c', '--config'],
        cli.ExistingFile,
        help='Specify a specific config file to load',
        default=CONFIG_FILE,
    )

    noconfirm = cli.Flag(
        ['-y', '--no-confirm'],
        help='Delete shitty files without confirmation',
        default=False,
    )

    verbose = cli.Flag(
        ['-v', '--verbose'],
        help='Print out files as they\'re being deleted',
        default=False,
    )

    def main(self):
        config = sh.path(self.config)
        local_config = sh.cwd / '.shittyfiles'
        files = []
        should_delete = True
        rm = sh['rm']

        if not config.exists():
            should_delete = False
            print('Your shitty config file does not exist!')
            print(f'Create the file at "{config}"')
        else:
            files.extend(config.read().splitlines())

        if local_config.exists():
            print(f'local shittyfiles config found at {sh.cwd}')
            should_delete = True
            files.extend(local_config.read().splitlines())

        files = [
            sh.path(f)
            for pattern in files
            for f in expand_path(pattern)
        ]

        if len(files) == 0:
            should_delete = False

        if not self.noconfirm and len(files) > 0:
            if self.verbose:
                for f in files:
                    print(f'  {f}')
            should_delete = cli.terminal.ask(
                f'Delete {len(files)} files',
                default=True,
            )

        if should_delete:
            rm['-rfv' if self.verbose else '-rf', files] & FG
            print(f'{len(files)} files deleted!')
        else:
            if len(files) > 0:
                print('Nothing was deleted!')
            else:
                print('No shitty files to be found!')


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
