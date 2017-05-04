import plumbum.cli as cli
import re
import sys
import xml.dom.minidom as dom

from abc import (
    ABC,
    abstractmethod,
)
from plumbum import FG, local as sh

LINK_TEMPLATES = dict(
    node='https://nodejs.org/dist/v{version}/node-v{version}-linux-x64.tar.gz',
    go='https://storage.googleapis.com/golang/{version}.linux-amd64.tar.gz',
)

ENV_SCRIPTS = {
    file.stem: file
    for file in sh.path(sh.env['DOTFILES'], 'share/virtual')
}


class Environment(ABC):
    '''Abstract class that represents a development environment.'''

    def __init__(self, dest='.venv'):
        self.dest = sh.cwd / dest

    @property
    @abstractmethod
    def name(self):
        '''Name of the environment.'''

    @property
    @abstractmethod
    def version(self):
        '''Latest version of environment'''

    @property
    def cache(self):
        '''Returns the file path for this environment's cache file.'''
        return sh.path(f'/tmp/{self.name}_venv.7z')

    @property
    def links(self):
        '''Returns a list of download links for the dev environment.'''
        if self.name in LINK_TEMPLATES:
            link = LINK_TEMPLATES[self.name]
            return [link.format(version=self.version)]
        else:
            return []

    def load_cache(self):
        '''Load a cached virtual environment.'''
        print('Extracting cached virtual environment:')
        sh['7z']['x', self.cache, f'-o{self.dest.dirname}'] & FG

    def save_cache(self, force=False):
        '''Caches the current virtual environment for later use.'''
        print('Caching virtual environment:')

        # set to update if file exists so that 7zip only archives changed files
        # set to add otherwise
        operation = 'u' if not force and self.cache.exists() else 'a'

        sh['7z'][operation, self.cache, '-mx=9', self.dest] & FG

    def mkdest(self):
        '''
            Creates the destination directory. If it already exists, then
            prompt the user to continue by deleting the contents of the
            existing virtual environment or exit.
        '''
        if self.dest.exists() and len([*self.dest]) > 0:
            print(f'{self.dest} exists and is non-empty.')
            ans = cli.terminal.ask('Erase contents and continue?', 'y')

            if ans in ['', 'y', 'yes']:
                self.dest.delete()
            else:
                print('Exiting.')
                sys.exit(0)

        self.dest.mkdir()

    def init(self, use_cache=True, force=False):
        '''Creates and caches the virtual environment.'''
        self.mkdest()

        if not force and use_cache and self.cache.exists():
            self.load_cache()
        else:
            self.fetch()
            if use_cache:
                self.save_cache(force)

        self.write_activate_script()

        # ayy lmao we did it bois
        print('Done!')
        print('Run to activate:')
        print(f'  $ source {self.dest.name}/activate.fish')

    def write_activate_script(self):
        '''Creates a template file.'''
        if self.name in ENV_SCRIPTS:
            data = ENV_SCRIPTS[self.name].read()
            (sh.cwd / self.dest / 'activate.fish').write(
                data.format(venv_dir=self.dest.name),
            )

    def post_fetch(self):
        '''
            Hook that child classes should override for performing operations
            after fetching.
        '''

    def fetch(self, force=False):
        '''Fetches the latest distribution of this development environment.'''
        curl = sh['curl']['-#L']
        tar = sh['tar'][
            '-z', '-x',
            '-f', '-',
            '-C', self.dest,
            '--strip-components', 1,
        ]

        for link in self.links:
            print(f'Fetching {link}')
            # pipeline won't work unless in
            # parenthesis for some reason
            (curl[link] | tar) & FG

        self.post_fetch()

    def __repr__(self):
        return f'<Environment {self.name}>'

    def __str__(self):
        return self.name


class NodeEnvironment(Environment):
    NODE_MIRROR = 'https://nodejs.org/dist/latest'

    @property
    def name(self):
        return 'node'

    @property
    def version(self):
        return sh['curl']('https://semver.io/node/unstable')

    @property
    def links(self):
        return super().links + ['https://yarnpkg.com/latest.tar.gz']

    def post_fetch(self):
        '''Install latest npm and npm-check-updates after being fetched.'''
        with sh.env(PATH=sh.env['PATH'] + ':' + sh.cwd / self.dest / 'bin'):
            yarn = sh.which('yarn')

            data = yarn.read()
            data = re.sub(
                r'^(\s*)node(.*)',
                f'\\1HOME={sh.cwd / self.dest} node\\2',
                data,
                flags=re.MULTILINE,
            )
            yarn.write(data)

            print('Adding npm@next and npm-check-updates.')
            sh['yarn'][
                'global', 'add',
                'npm-check-updates',
                'npm@next',
            ] & FG


class GoEnvironment(Environment):
    GO_DL_URL = 'https://storage.googleapis.com/golang'

    @property
    def name(self):
        return 'go'

    @property
    def version(self):
        data = sh['curl'](self.GO_DL_URL)
        xml = dom.parseString(data)
        ver = xml.getElementsByTagName('NextMarker')[0].firstChild.nodeValue
        return '.'.join(ver.split('.')[:2])


class PythonEnvironment(Environment):
    @property
    def name(self):
        return 'python'

    @property
    def version(self):
        return sys.version

    def write_activate_script(self):
        dest = self.dest.name
        sh['ln'](
            '-s',
            sh.cwd / f'{dest}/bin/activate.fish',
            sh.cwd / f'{dest}/activate.fish',
        )

    def fetch(self, force=False):
        sh.python['-m', 'venv', self.dest] & FG


class FlutterEnvironment(Environment):
    @property
    def name(self):
        return 'flutter'

    @property
    def version(self):
        return 'master'

    def fetch(self, force=False):
        print('Fetching Flutter SDK:')
        sh['git'][
            'clone',
            'git://github.com/flutter/flutter.git',
            self.dest,
        ] & FG


ENVIRONMENTS = {
    'go': GoEnvironment,
    'node': NodeEnvironment,
    'python': PythonEnvironment,
    'flutter': FlutterEnvironment,
}
