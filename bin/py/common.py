import os
import sys

from plumbum import local as sh

dotfiles_path = sh.path(sh.env.expand('$DOTFILES'))


def check_linux():
    '''Checks if the the current script is running on Linux.'''
    if not sys.platform.startswith('linux'):
        print('Must be run on Linux')
        sys.exit(-1)


def check_root():
    '''Checks if the current script is running under root'''
    if os.getuid() != 0:
        print('Must be run as root!')
        sys.exit(-1)
