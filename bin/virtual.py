#!/usr/bin/env python3

import os
import os.path as path

from jinja2 import Environment, FileSystemLoader, Template
from plumbum import cli

class Virtual(cli.Application):
    TEMPLATE_DIR = path.realpath(f'{path.dirname(__file__)}/../share/virtual')
    VERSION = '0.1.0'

    @cli.switch(
        names=['--template-dir'],
        help='Set custom directory to search for templates.',
    )
    def template_dir(self, dir):
        self.template_dir = dir

    @cli.switch(
        names=['-d', '--directory'],
        help='Set custom directory to setup the virtual environment in.',
    )
    def virtual_dir(self, dir):
        self.directory = dir

    def main(self):
        self.env = Environment(loader=FileSystemLoader(self.TEMPLATE_DIR))

if __name__ == '__main__':
    Virtual.run()

