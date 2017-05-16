# Shared Data

This directory contains user data that rarely changes. These files are different
from configuration files (such as those found in `etc` and `config`) where
configuration files must be purely text based. Shared files can be text based or
in some binary format.

Configuration files that don't get soft linked into `~/etc` or `/etc` may also
be put here (i.e. `share/shittyfiles`). Pretty much anything you wouldn't put in
`~/etc` or `/etc` is put in here.

## File Index
```
share/
├── latex/       - Templates, makefile, and resume for latex.
├── secrets/     - User secrets
├── virtual/     - Environment templates for `bin/virtual` scritp
├── myfortunes   - Fortunes used by fortune-mod
├── shittyfiles  - Shitty file listing for `bin/rmshit` script
└── stylish.json - Stylish configuration for Stylish extension
```
