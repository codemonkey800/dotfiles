import os
import plumbum.cli as cli

from pyfiglet import Figlet
from plumbum import FG, colors, local as sh
from common import dotfiles_path

# Commands
echo = sh['echo']
find = sh['find']
fish = sh['fish']
git = sh['git']
ln = sh['ln']
lolcat = sh['lolcat']
pacman = sh['pacman']
pkgfile = sh['pkgfile']
reflector = sh['reflector']
sudo = sh['sudo']
yaourt = sh['yaourt']

_figlet = Figlet()


def print_banner(text, updating=True):
    if updating:
        text = f'Updating {text}'
    text = _figlet.renderText(text)

    chain = echo[text] | lolcat
    chain & FG


class App(cli.Application):
    PROGNAME = 'update'

    DESCRIPTION = (
        'If you omit the switches, then updates will follow this order:\n'
        '  git -> fish -> pacmandb -> pkgfile -> aur'
    )

    updated = False

    @cli.switch(
        names='fish',
        help=(
            'Updates fisherman, fish completions, '
            'and links all dotfiles fish functions'
        ),
    )
    def update_fish(self):
        print_banner('fish')

        fish['-c', 'fisher up'] & FG

        fish_func_dir = dotfiles_path / 'config/fish/functions'
        fish_funcs = fish_func_dir.glob('*.fish')

        if fish_funcs:
            dest = sh.env.expand('~/etc/fish/functions')
            ln['-svf', fish_func_dir.glob('*.fish'), dest] & FG

        fish['-c', 'fish_update_completions'] & FG

        self.updated = True

    @cli.switch(
        names='git',
        help='Updates repos located in ~/src',
    )
    def update_git(self):
        print_banner('git')

        git_dirs = find(sh.env.expand('~/src'), '-name', '.git')
        git_dirs = [
            sh.path(git_dir.strip())
            for git_dir in git_dirs.split('\n')
            if git_dir
        ]

        for git_dir in git_dirs:
            repo_dir = git_dir.dirname
            repo = repo_dir.basename

            with colors.green:
                print(f'Pulling from {repo}')
            with sh.cwd(repo_dir):
                try:
                    git('diff-index', '--quiet', 'HEAD', retcode=0)
                except:
                    with colors.red:
                        print(f'Skipping {git_dir} because it has uncommitted changes')
                    print()
                    continue

                current_branch = git(
                    'rev-parse',
                    '--abbrev-ref', 'HEAD',
                ).strip()
                git['pull', 'origin', current_branch] & FG

                print()

        self.updated = True

    @cli.switch(
        names='aur',
        excludes=('pacman',),
        help='Updates pacman and aur packages using `yaourt`',
    )
    def update_aur(self):
        print_banner('aur')
        with sh.as_root():
            pacman['-Syu'] & FG

        self.updated = True

    @cli.switch(
        names='pacman',
        excludes=('aur',),
        help='Updates pacman packages using `pacman`',
    )
    def update_pacman(self):
        print_banner('pacman')
        with sh.as_root():
            pacman['-Syu'] & FG

        self.updated = True

    @cli.switch(
        names='pacmandb',
        help='Updates pacman database using `reflector`',
    )
    def update_pacmandb(self):
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
        print_banner('pkgfile')
        with sh.as_root():
            pkgfile['-u'] & FG

        self.updated = True

    def main(self):
        if not self.updated:
            self.update_git()
            self.update_fish()
            self.update_pacmandb()
            self.update_pkgfile()
            self.update_aur()
        print(_figlet.renderText('Done Updating!'))


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
