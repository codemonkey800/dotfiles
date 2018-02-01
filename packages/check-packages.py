#!/usr/bin/env python3

import os.path as path
import subprocess
from argparse import ArgumentParser

PACKAGE_FILES = {
    path.join(
        path.dirname(__file__),
        path.basename(file),
    )
    for file in {
        'client',
        'common',
        'vm',
    }
}


def read_package_file(file):
    return set(map(str.strip, open(file)))


def list_installed_packages():
    proc = subprocess.run(
        ['yaourt', '-Qqe'],
        stdout=subprocess.PIPE,
    )
    result = proc.stdout.decode('utf-8').split('\n')
    return {
        line.strip()
        for line in result
        if line
    }


def print_packages(packages, label=None):
    if label:
        print(f'{label} Packages:')
    for package in sorted(packages):
        prefix = '  ' if label else ''
        print(prefix + package)


def main(args):
    installed = list_installed_packages()
    synced = {
        package
        for file in PACKAGE_FILES
        for package in read_package_file(file)
    }

    missing = synced - installed
    extraneous = installed - synced

    if args.missing:
        print_packages(missing)
    elif args.extraneous:
        print_packages(extraneous)
    else:
        print_packages(missing, 'Missing')
        print_packages(extraneous, 'Extraneous')


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        '-e', '--extraneous',
        action='store_true',
        help='List extraneous packages only',
    )
    parser.add_argument(
        '-m', '--missing',
        action='store_true',
        help='List missing packages only',
    )

    main(parser.parse_args())
