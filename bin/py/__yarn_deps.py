from common import yarn
from plumbum import (
    cli,
    colors,
    local as sh,
)


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
            packages = config['devDependencies']
        elif peer:
            label = 'Peer'
            packages = config['peerDependencies']
        else:
            label = 'Production'
            packages = config['dependencies']

        if not packages:
            return

        packages = yarn.format_versions(packages)

        if self.raw:
            for package in packages:
                print(package)
            return

        yarn.print_label(f'{label} Dependencies:')
        for package in packages:
            print(f'  {package}')

    def main(self, pkg='package.json'):
        config = yarn.PackageConfig()

        pkg_file = sh.path(pkg)
        if pkg_file.exists():
            config.load_local(pkg_file)
        else:
            try:
                config.load_remote(pkg)
            except ValueError:
                yarn.print_not_found(pkg)
                return -1

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
