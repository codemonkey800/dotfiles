from common.linux import dotfiles_path
from glob import glob
from plumbum import (
    FG,
    cli,
    colors,
    local as sh,
)

CONFIG_FILE = dotfiles_path / 'share/shittyfiles'


def expand_path(p):
    '''Expands a path's glob and tilde syntax if they're present.'''
    return glob(sh.env.expand(p))


class App(cli.Application):
    '''
    A script for removing user defined shitty files. Also has support for
    directory specific shitty config files.
    '''

    PROGNAME = 'rmshit'

    config = cli.SwitchAttr(
        names=('c', 'config'),
        argtype=cli.ExistingFile,
        argname='config-file',
        default=CONFIG_FILE,
        help='Specify a specific config file to load',
    )

    noconfirm = cli.Flag(
        names=('y', 'no-confirm'),
        help='Delete shitty files without confirmation',
    )

    verbose = cli.Flag(
        names=('v', 'verbose'),
        help='Print out files as they\'re being deleted',
    )

    def main(self):
        config = sh.path(self.config)
        local_config = sh.cwd / '.shittyfiles'
        files = []
        should_delete = True
        rm = sh['rm']

        if not config.exists():
            should_delete = False
            with colors.red:
                print('Your shitty config file does not exist!')
                print(f'Create the file at "{config}"')
        else:
            files.extend(config.read().splitlines())

        if local_config.exists():
            colors.green.print(f'local shittyfiles config found at {sh.cwd}')
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
            colors.green.print(f'{len(files)} files deleted!')
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
