import json

from plumbum import (
    cli,
    colors,
    commands,
    local as sh,
)


class App(cli.Application):
    '''
    Lists tags for specific package.
    '''

    def main(self, pkg):
        yarn = sh['yarn']

        try:
            response = yarn('info', '--json', pkg, 'dist-tags')
            data = json.loads(response)['data']
        except commands.ProcessExecutionError:
            print(colors.red & colors.bold | 'Package not found:', end=' ')
            colors.green.print(pkg)
            return -1

        print(colors.green & colors.bold | f'Dist Tags for `{pkg}`')
        keys = sorted(data.keys())
        for key in keys:
            val = data[key]
            print(f'  {key}@{val}')


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
