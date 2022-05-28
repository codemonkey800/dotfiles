import os.path as path
import requests

from plumbum import FG, cli, local as sh

API_ROOT = 'https://gitignore.io/api'


def api_request(route):
    uri = path.join(API_ROOT, route)
    return requests.get(uri).text


def get_templates():
    response = api_request('list')
    response = ','.join(response.split('\n'))

    templates = {
        template.strip()
        for template in response.split(',')
        if template
    }
    return templates


def print_templates():
    templates = get_templates()
    for template in sorted(templates):
        print(template)


def select_templates():
    echo = sh['echo']
    fzf_tmux = sh['fzf-tmux']

    templates = get_templates()
    data = '\n'.join(sorted(templates))

    chain = echo[data] | fzf_tmux['-m']
    selected = {
        template.strip()
        for template in chain().split('\n')
        if template
    }

    return selected


def print_gitignore(selected):
    templates = get_templates()
    invalid = selected - (templates & selected)
    if invalid:
        invalid = ', '.join(sorted(invalid))
        raise ValueError(f'Invalid templates: {invalid}')

    route = ','.join(selected)
    response = api_request(route)

    print(response)


class App(cli.Application):
    '''
    Creates a `.gitignore` file in the current directory. If you don't specify
    template names, then an fzf window will open and you can select which
    templates you want to use.
    '''

    list_templates = cli.Flag(
        names=('l', 'list'),
        help='List templates available.',
    )

    def main(self, *selected):
        if self.list_templates:
            print_templates()
            return

        if not selected:
            selected = select_templates()

        print_gitignore(set(selected))


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
