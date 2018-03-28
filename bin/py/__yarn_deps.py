import json

from plumbum import (
    cli,
    colors,
    commands,
    local as sh,
)


class PackageConfig:
    def __init__(self):
        self.dev = None
        self.peer = None
        self.prod = None

    def format_packages(self, packages):
        if packages is None:
            return set()
        return {
            f'{pkg}@{version}'
            for pkg, version in packages.items()
        }

    def set_packages(self, manifest):
        self.dev = manifest.get('devDependencies', None)
        self.peer = manifest.get('peerDependencies', None)
        self.prod = manifest.get('dependencies', None)

        self.dev = self.format_packages(self.dev)
        self.peer = self.format_packages(self.peer)
        self.prod = self.format_packages(self.prod)

    def load_local(self, manifest_file):
        if not manifest_file.exists():
            raise ValueError(f"Manifest file doesn't exist: {manifest_file}")
        with open(manifest_file) as f:
            manifest = json.load(f)
            self.set_packages(manifest)

    def load_remote(self, pkg):
        yarn = sh['yarn']
        try:
            data = yarn('--json', 'info', pkg)
        except commands.ProcessExecutionError as e:
            colors.red.print('Package not found:', end='')
            colors.green.print(pkg)
            raise e

        manifest = json.loads(data)['data']
        self.set_packages(manifest)


class App(cli.Application):
    '''
    Queries dependencies of local or remote packages. If you
    don't supply the --dev, --peer, or --prod flags, then all package
    dependencies will be listed.

    You can use load remote or local packages:
        # Load local package:
        $ yarn deps ~/projects/app/package.json
        # Load remote package:
        $ yarn deps eslint-config-airbnb
    '''

    dev = cli.Flag(
        names='dev',
        help='List development dependencies.',
    )

    peer = cli.Flag(
        names='peer',
        help='List peer dependencies.',
    )

    prod = cli.Flag(
        names='prod',
        help='List production dependencies.',
    )

    raw = cli.Flag(
        names=('r', 'raw'),
        help='List dependenies without fancy formatting.',
    )

    def print_packages(self, config, dev=False, peer=False):
        if dev:
            label = 'Development'
            packages = config.dev
        elif peer:
            label = 'Peer'
            packages = config.peer
        else:
            label = 'Production'
            packages = config.prod

        if not packages:
            return

        if self.raw:
            for package in packages:
                print(package)
            return

        colors.green.print(f'{label} Dependencies:')
        for package in packages:
            print(f'  {package}')

    def main(self, pkg='package.json'):
        config = PackageConfig()

        pkg_file = sh.path(pkg)
        if pkg_file.exists():
            config.load_local(pkg_file)
        else:
            config.load_remote(pkg)

        show_all = not (self.dev or self.peer or self.prod)
        if self.prod or show_all:
            self.print_packages(config)
        if self.dev or show_all:
            self.print_packages(config, dev=True)
        if self.peer or show_all:
            self.print_packages(config, peer=True)


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
