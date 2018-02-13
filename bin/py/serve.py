import os
import plumbum.cli as cli

from plumbum import FG, local as sh

SERVER_TEMPLATE = '  {}. PID = {}, Port = {}, Directory = {}'


def get_running_server(line):
    ps = sh['ps']
    grep = sh['grep']
    pawk = sh['pawk']
    readlink = sh['readlink']

    # http/<port>: -> http/port
    line = line[:-1]
    # http/port -> port
    port = line.split('/')[1]
    port = int(port)

    find_pid = (
        ps['-ef']
        | grep['-E', f'http\\.server.*{port}']
        | grep['-Ev', '(fish|grep)']
        | pawk['f[1]']
    )
    pid = int(find_pid())

    directory = readlink('-e', f'/proc/{pid}/cwd').strip()

    return (pid, port, directory)


def get_running_servers():
    grep = sh['grep']
    pawk = sh['pawk']
    tmux = sh['tmux']

    find_servers = tmux['list-sessions'] | grep['http'] | pawk['f[0]']

    servers = [
        get_running_server(line)
        for line in find_servers(retcode=None).split('\n')
        if line
    ]

    return servers


def print_servers(servers):
    if not servers:
        print('No servers running')
        return

    print('Running Servers:')
    for i, server in enumerate(get_running_servers()):
        print(SERVER_TEMPLATE.format(i + 1, *server))


def is_server_running(servers, port):
    for server in servers:
        if port == server[1]:
            return True
    return False


def start_foreground_server(port):
    python = sh['python3']
    python['-m', 'http.server', port] & FG


def start_background_server(port):
    tmux = sh['tmux']
    with sh.env(TMUX=''):
        new_session = tmux[
            'new-session',
            '-s', f'http/{port}',
            f'python3 -m http.server {port}',
            ';', 'detach',
        ] > os.devnull

        new_session & FG


def kill_background_server(port):
    tmux = sh['tmux']
    kill_session = tmux[
        'kill-session',
        '-t', f'http/{port}',
    ] > os.devnull

    kill_session & FG


class App(cli.Application):
    '''Runs http server in foreground or many in background using tmux.'''

    detach = cli.Flag(
        names=['d', 'detach'],
        help='Run server as tmux session',
    )

    kill_server = cli.Flag(
        names=['k', 'kill'],
        requires=['port'],
        help='Kills server specified by port.',
    )

    list_servers = cli.Flag(
        names=['l', 'list'],
        help='Lists running servers in background',
    )

    port = cli.SwitchAttr(
        names=('-p', '--port'),
        argtype=int,
        argname='port',
        default=8080,
        help='Port to start server on',
    )

    workdir = cli.SwitchAttr(
        names=('-w', '--work-dir'),
        argtype=cli.ExistingDirectory,
        argname='directory',
        default=sh.cwd,
        help='Directory to start http server in',
    )

    def main(self):
        servers = get_running_servers()

        if self.list_servers:
            print_servers(servers)
            return

        found_running = is_server_running(servers, self.port)

        if found_running and not self.kill_server:
            print(f'{self.port} is already in use')
            return
        elif not found_running and self.kill_server:
            print(f'No server running on {self.port}')
            return

        if self.kill_server:
            kill_background_server(self.port)
            return

        os.chdir(self.workdir)

        if not self.detach:
            print(f'Root: {self.workdir}')
            start_foreground_server(self.port)
            return

        start_background_server(self.port)


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
