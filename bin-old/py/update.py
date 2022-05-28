import os

from common.linux import dotfiles_path
from pyfiglet import Figlet
from plumbum import (
    FG,
    cli,
    colors,
    commands,
    local as sh,
)

_figlet = Figlet()


def print_banner(text, updating=True):
    echo = sh['echo']
    lolcat = sh['lolcat']

    if updating:
        text = f'Updating {text}'
    text = _figlet.renderText(text)

    chain = echo[text] | lolcat
    chain & FG


class App(cli.Application):
    '''
    If you omit the switches, then updates will follow this order:\n
        git -> fish -> pacmandb -> pkgfile -> aur
    '''

    PROGNAME = 'update'

    updated = False

    @cli.switch(
        names='fish',
        help=(
            'Updates fisherman, fish completions, '
            'and links all dotfiles fish functions'
        ),
    )
    def update_fish(self):
        fish = sh['fish']
        ln = sh['ln']

        print_banner('fish')

        fish['-c', 'fisher'] & FG

        fish_func_dir = dotfiles_path / 'config/fish/functions'
        fish_funcs = fish_func_dir.glob('*.fish')

        if fish_funcs:
            dest = sh.env.expand('~/etc/fish/functions')
            ln['-sf', fish_func_dir.glob('*.fish'), dest] & FG

        fish['-c', 'fish_update_completions'] & FG

        self.updated = True

    @cli.switch(
        names='git',
        help='Updates repos located in ~/projects',
    )
    def update_git(self):
        find = sh['find']
        git = sh['git']

        print_banner('git')

        git_dirs = find(sh.env.expand('~/projects'), '-name', '.git')
        git_dirs = [
            sh.path(git_dir.strip())
            for git_dir in git_dirs.split('\n')
            if git_dir
        ]

        for git_dir in git_dirs:
            repo_dir = git_dir.dirname
            repo = repo_dir.basename

            colors.green.print(f'Pulling from {repo}')
            with sh.cwd(repo_dir):
                try:
                    git('diff-index', 'HEAD')
                except commands.ProcessExecutionError:
                    colors.red.print((
                        f'Skipping {git_dir} because '
                        'it has uncommitted changes\n'
                    ))
                    continue

                current_branch = git(
                    'rev-parse',
                    '--abbrev-ref', 'HEAD',
                ).strip()

                try:
                    git['pull', 'origin', current_branch] & FG
                    print()
                except commands.ProcessExecutionError:
                    colors.red.print('Unable to pull from repo\n')

        self.updated = True

    @cli.switch(
        names='aur',
        excludes=('pacman',),
        help='Updates pacman and aur packages using `yaourt`',
    )
    def update_aur(self):
        yaourt = sh['yaourt']

        print_banner('aur')
        yaourt['-Syu', '--aur', '--noconfirm'] & FG

        for yaourt_dir in sh.path('/tmp').glob('yaourt-*'):
            with sh.as_root():
                yaourt_dir.delete()

        self.updated = True

    @cli.switch(
        names='pacman',
        excludes=('aur',),
        help='Updates pacman packages using `pacman`',
    )
    def update_pacman(self):
        pacman = sh['pacman']

        print_banner('pacman')
        with sh.as_root():
            pacman['-Syu', '--overwrite', '--noconfirm'] & FG

        self.updated = True

    @cli.switch(
        names='pacmandb',
        help='Updates pacman database using `reflector`',
    )
    def update_pacmandb(self):
        # We have to use the Python module directly using the host interpreter.
        reflector = sh['/bin/python3']['-m', 'Reflector']

        print_banner('pacmandb')
        with sh.as_root():
            reflector[
                '--verbose',
                '--threads', os.cpu_count(),
                '--sort', 'score',
                '--save', '/etc/pacman.d/mirrorlist',
                '--country', 'US',
                '--fastest', 10,
            ] & FG

        self.updated = True

    @cli.switch(
        names='pkgfile',
        help='Updates using `pkgfile`',
    )
    def update_pkgfile(self):
        pkgfile = sh['pkgfile']

        print_banner('pkgfile')
        with sh.as_root():
            pkgfile['-u'] & FG

        self.updated = True

    @cli.switch(
        names='brew',
        help='Updates using brew.',
    )
    def update_brew(self):
        brew = sh['brew']

        print_banner('brew')

        print('$ brew update')
        brew['update'] & FG

        print('$ brew upgrade')
        brew['upgrade'] & FG

        print('$ brew cask upgrade')
        brew['cask', 'upgrade'] & FG

        print('$ brew cleanup')
        brew['cleanup'] & FG

        self.updated = True

    def main(self):
        if not self.updated:
            self.update_git()
            self.update_fish()
            self.update_pacmandb()
            self.update_pkgfile()
            self.update_aur()
        print_banner('Done Updating!', updating=False)


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
