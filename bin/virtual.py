#!/usr/bin/env python3

import os
import os.path as path

from jinja2 import Environment, FileSystemLoader, Template
from plumbum import cli
from plumbum.cmd import mkdir

SUPPORTED_PLATFORMS = [
    'go',
    'node',
    'python',
]

TEMPLATE_DIR = path.realpath(f'{path.dirname(__file__)}/../share/virtual')

class Virtual(cli.Application):
    '''A script that bootstraps virtual environments.'''

    PROGNAME = 'Virtual'
    VERSION = '0.1.0'

    virtual_dir = cli.SwitchAttr(
        names=['-d', '--directory'],
        argtype=str,
        argname='directory',
        help='Set custom directory to setup the virtual environment in.',
        default='.venv',
    )

    template_dir = cli.SwitchAttr(
        names=['--template-dir'],
        argtype=str,
        argname='directory',
        help='Set custom directory to search for templates.',
        default=TEMPLATE_DIR,
    )

    def __init__(self, executable):
        super().__init__(self)
        self._list_platforms_flag_used = False

    @cli.switch(['-l', '--list-platforms'])
    def list_platforms(self):
        '''List available platforms for bootstrapping.'''
        print('Supported Platforms:')
        for p in SUPPORTED_PLATFORMS:
            print(f'    {p}')
        self._list_platforms_flag_used = True

    def main(self, env: cli.Set(*SUPPORTED_PLATFORMS) = 'node'):
        if self._list_platforms_flag_used:
            return

        self.env = Environment(loader=FileSystemLoader(self.template_dir))

    def _fetch(self):
        ...

if __name__ == '__main__':
    Virtual()

