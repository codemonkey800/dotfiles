# Secrets

Collection of any sensitive data of mine that has to be kept secret.

## Usage

The `secrets.py` script leverages git and a `.gitignore` file to determine what
files are secrets. The `.gitignore` file in the current working directory
ignores everything by default and maintains a whitelist of files not to ignore.
Add anything not secret to the gitignore.

### Hiding

To hide all your secrets, run:

```sh
$ ./secrets.py --hide
```

This will create a new 7zip archive named `secrets.7z` containing your secrets,
if any. It then uses `gpg2` to symmetrically encrypt the archive. Symmetric
encryption is used so the encrypted file is not tied to a specific GPG key. You
will, still need `gpg2` to decrypt the file.

### Showing

To show all your secrets, run:

```sh
$ ./secrets.py --show
```
