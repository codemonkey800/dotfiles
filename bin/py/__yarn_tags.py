from common import yarn
from plumbum import cli


class App(cli.Application):
    '''
    Lists tags for specific package.
    '''

    def main(self, pkg):
        config = yarn.PackageConfig()

        try:
            config.load_remote(pkg)
        except ValueError:
            yarn.print_not_found(pkg)
            return -1

        yarn.print_label(f'Dist Tags for `{pkg}`')
        for tag in yarn.format_versions(config['dist-tags']):
            print(f'  {tag}')


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
