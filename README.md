<p align="center">
  <a href="https://dotfiles.github.io/" target="_blank">
    <img src="images/dotfiles.png" width="30%">
  </a>
</p>

<p align="center">
  <a href="http://forthebadge.com/" target="_blank">
    <img src="http://forthebadge.com/images/badges/compatibility-club-penguin.svg">
  </a>
  <a href="http://forthebadge.com/" target="_blank">
    <img src="http://forthebadge.com/images/badges/certified-snoop-lion.svg">
  </a>
</p>

---

# Dotfiles :tada::tada::tada:

## Emoji Index :heart_eyes:

I've recently started using Emojis in a lot of my commit messages, READMEs, and
wherever I can on GitHub. Here's what each emoji I use represents. It may be
subject to change:

- :tada: - Commits that include something so amazing that I have to celebrate :tada:
- :wrench: - Commits that are relatively small to medium in size
- :warning: - Commits that introduce configs or code that break things

## Introduction :mag:

Aside from being free and having a [penguin](https://en.wikipedia.org/wiki/Tux)
for a mascot, a Linux based OS is probably *the* best for customization.
[Dotfiles](https://en.wikipedia.org/wiki/Dotfiles) are essentially hidden files
and directories, such as `~/.bashrc`, `~/.config/`, and `~/.local/` to name a
few.

Dotfiles are not strictly limited to configuration files. You can have
executable scripts, package listings for backups, build files, etc.  (At least,
that's what I have in my dotfiles :stuck_out_tongue_winking_eye:)

As a side note, since this is my personal configuration repo, it is subject to
change rapidly since I tend to change my mind frequently on how I want my setup
to be.

## Features :package:

Although my dotfiles are tailored to my development environment, you can easily
use them as a bootstrap for a new system, a base for your own set of dotfiles,
or even take a subset of my dotfiles and incorporate it into your own.

- Fish
  - [Fisherman](http://fisherman.sh/) for plugins and themes
  - [Keychain](https://wiki.archlinux.org/index.php?title=SSH_keys#Keychain) support for environments where $DISPLAY isn't defined
  - Configuration split into aliases, functions, variables, and completions
- NeoVim
  - Asynchronous autocompletion for a variety of languages using [Deoplete](https://github.com/Shougo/deoplete.nvim)
  - Plugin management using [vim-plug](https://github.com/junegunn/vim-plug)
  - Configuration files split into settings modules
- LaTeX
  - Makefile for compiling LaTeX documents that make use of `pythontex`
  - Template files: `basic.tex` and `math.tex`
- A bunch of useful scripts
  - `rmshit` - Sources a list of files to delete file named `~/.shittyfiles`
  - `update` - A big ass script that runs updates
- Pacman
  - Yaourt for package management and Powerpill for parallel and segmented downloads
- Git
  - Some useful (or useless) git aliases
  - Various custom git commands
  - [hub](https://hub.github.com/) wrapper for CLI interaction with GitHub
- Backup Package Listings
  - Atom Packages
  - npm global modules
  - Fisherman plugins
  - Arch packages
- And a bunch more that I can't remember!

## Structure :penguin:

I've structured the repo to map *somewhat* directly to how it would be laid out
in your home directory. The directory structure below only shows files that are
symlinked to their respective locations. More detailed instructions on setting
up everything are below.

Note: A `x -> y` will indicate that a symbolic link `y` points to `x`.

```
config/
  fish/
    aliases.fish      -> ~/.config/fish/aliases.fish
    completions.fish  -> ~/.config/fish/completions.fish
    ...
  gitconfig           -> ~/.gitconfig
  npmrc               -> ~/.npmrc
  nvim/
    init.vim          -> ~/.config/nvim/init.vim
    mthesaur.txt      -> ~/.config/nvim/thesauraus.txt
    spell             -> ~/.config/nvim/spell
    UltiSnips         -> ~/.config/nvim/UltiSnips/
etc/
  pacman/ # The following symlinks require root permission
    makepkg.conf      -> /etc/pacman.d/makepkg.conf
    pacman.conf       -> /etc/pacman.conf
    yaourtrc          -> /etc/yaourtrc
```

## macOS/Windows Support :computer:

Some of my dotfiles will be incompatible with macOS and Windows. For example,
anything pacman related cannot be used.  Any other settings that are highly
dependent on either a Linux based OS or Arch Linux won't work on macOS or
Windows.

For Windows, you'll most likely either need to install
[Cygwin](https://www.cygwin.com/), use the [Bash
Subsystem](https://msdn.microsoft.com/en-us/commandline/wsl/about), or run a
Linux distro in a VM.

Personally, I use Windows on my desktop and run Arch in VMWare Workstation. For my laptop, I dual boot with MacOS and Arch.

## License :page_with_curl:

The MIT License (MIT)

Copyright (c) 2017 Jeremy Asuncion

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
