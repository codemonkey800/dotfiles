#!/usr/bin/env python3

import plumbum.cli as cli

from plumbum import colors, local as sh

_secrets_root = sh.path(sh.env.expand('$DOTFILES/share/secrets'))
_secrets_archive = _secrets_root.join('secrets.7z')
_secrets_encrypted_archive = _secrets_archive.with_suffix('.gpg')


# Convenience function to parse the data from the list_secrets command
def list_secrets():
    git = sh['git']
    grep = sh['grep']
    pawk = sh['pawk']

    # Chained command for getting secrets as per defined by the .gitignore file
    _list_secrets = git['status', '--ignored', '-s', _secrets_root]
    _list_secrets |= grep['!!']
    _list_secrets |= pawk['f[1]']

    secrets = _list_secrets(retcode=None).split('\n')[:-1]
    secrets = [sh.path(secret).basename for secret in secrets if secret]
    secrets = [
        secret for secret in secrets
        if secret != _secrets_archive.basename
    ]

    return secrets


class App(cli.Application):
    '''Hides or reveals secrets encrypted with gpg in the dotfiles repo.'''

    @cli.switch(
        names=['l', 'list'],
        excludes=('hide', 'show'),
        help='List the secrets that would be added to the archive',
    )
    def list_secrets(self):
        colors.green.print('Secrets:')
        for secret in list_secrets():
            print(f'  {secret}')

    @cli.switch(
        names='hide',
        excludes=('show',),
        help='Compresses and encrypts files inside the $DOTFILES/secrets dir',
    )
    def hide_secrets(self):
        _7z = sh['7z']['-aoa', '-y', '-mx9']
        gpg = sh['gpg2']

        secrets = list_secrets()

        if not secrets:
            colors.red.print('No secrets found!')
            return

        colors.green.print('Compressing secrets...')
        with sh.cwd(_secrets_root):
            _7z('a', _secrets_archive, *secrets)

        if _secrets_encrypted_archive.exists():
            print('Removing old encrypted secrets archive...')
            _secrets_encrypted_archive.delete()

        colors.green.print('Encrypting secrets with gpg2...')
        gpg(
            '--output', _secrets_encrypted_archive,
            '--symmetric',
            _secrets_archive,
        )

        colors.green.print('Removing secrets...')
        _secrets_archive.delete()
        for secret in secrets:
            f = sh.cwd / secret
            if f.exists():
                f.delete()

        with colors.green:
            print('Done!')
            print('Secrets Added:')
        for secret in secrets:
            print(f'  {secret}')

    @cli.switch(
        names='show',
        excludes=('hide',),
        help='Decrypts and extracts secrets to the $DOTFILES/secrets dir',
    )
    def show_secrets(self):
        _7z = sh['7z']['-aoa', '-y', '-mx9']
        gpg = sh['gpg2']

        if not _secrets_encrypted_archive.exists():
            with colors.red:
                print((
                    'Secrets archive '
                    f'"{_secrets_encrypted_archive.basename}" '
                    'does not exist'
                ))
                print(f'Run `{__file__} --hide` to hide secrets')
            return

        prev_secrets = list_secrets()

        colors.green.print('Decrypting secrets with gpg2...')
        gpg(
            '--output', _secrets_archive,
            '--decrypt', _secrets_encrypted_archive,
        )

        colors.green.print('Extracting secrets...')
        with sh.cwd(_secrets_root):
            _7z('x', _secrets_archive)

        colors.green.print('Removing secrets archive...')
        _secrets_archive.delete()

        revealed_secrets = set(list_secrets()) - set(prev_secrets)
        print('Done!')
        if revealed_secrets:
            colors.green.print('Secrets Revelead:')
            for secret in sorted(revealed_secrets):
                print(f'  {secret}')
        else:
            print('No secrets revelead')

    def main(self):
        pass


if __name__ == '__main__':
    try:
        App.run()
    except KeyboardInterrupt as e:
        pass
