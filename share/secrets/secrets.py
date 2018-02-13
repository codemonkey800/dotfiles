#!/usr/bin/env python3

import plumbum.cli as cli
import textwrap

from plumbum import local as sh

# chained command for getting secrets as per defined
# by the .gitignore file
_list_secrets = sh['git']['status', '--ignored', '-s', '.']
_list_secrets |= sh['grep']['!!']
_list_secrets |= sh['pawk']['f[1]']


# Convenience function to parse the data from the list_secrets command
def list_secrets():
    return _list_secrets(retcode=None).split('\n')[:-1]


def hide_secrets(gpg, compress, secrets_archive, secrets_encrypted_archive):
    secrets = list_secrets()

    if not secrets:
        print('No secrets found!')
        return

    print('Compressing secrets...')
    compress(secrets_archive, *secrets)

    if secrets_encrypted_archive.exists():
        print('Removing old encrypted secrets archive...')
        secrets_encrypted_archive.delete()

    print('Encrypting secrets with gpg2...')
    gpg(
        '--output', secrets_encrypted_archive,
        '--symmetric',
        secrets_archive,
    )

    print('Removing secrets...')
    secrets_archive.delete()
    for secret in secrets:
        f = sh.cwd / secret
        if f.exists():
            f.delete()

    print('Done !')
    print('Secrets Added:')
    print(textwrap.indent('\n'.join(secrets), '  '))


def show_secrets(gpg, decompress, secrets_archive, secrets_encrypted_archive):
    if not secrets_encrypted_archive.exists():
        print((
            'Secrets archive '
            f'"{secrets_encrypted_archive.basename}" '
            'does not exist'
        ))
        print(f'Run `{__file__} --hide` to hide secrets')
        return

    print('Decrypting secrets with gpg2...')
    gpg(
        '--output', secrets_archive,
        '--decrypt', secrets_encrypted_archive,
    )

    print('Extracting secrets...')
    decompress(secrets_archive)

    print('Removing secrets archive...')
    secrets_archive.delete()

    secrets = list_secrets()
    print('Done!')
    print('Secrets Revelead:')
    print(textwrap.indent('\n'.join(secrets), '  '))


class App(cli.Application):
    '''Hides or reveals secrets encrypted with gpg in the dotfiles repo.'''

    hide_secrets = cli.Flag(
        names='hide',
        help='Compresses and encrypts files inside the $DOTFILES/secrets dir',
    )
    show_secrets = cli.Flag(
        names='show',
        help='Decrypts and extracts secrets to the $DOTFILES/secrets dir',
    )

    def main(self):
        gpg = sh['gpg2']

        # convenience compression commands
        _7z = sh['7z']['-aoa', '-y', '-mx9']
        compress = _7z['a']
        decompress = _7z['x']

        secrets_archive = sh.cwd / f'{sh.cwd.basename}.7z'
        secrets_encrypted_archive = sh.cwd / f'{secrets_archive}.gpg'

        if self.hide_secrets:
            hide_secrets(
                gpg, compress,
                secrets_archive, secrets_encrypted_archive,
            )
        elif self.show_secrets:
            show_secrets(
                gpg, decompress,
                secrets_archive, secrets_encrypted_archive,
            )
        else:
            self.help()


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
