Dotfiles
===========
Here's a bunch of useless configuration files for my Linux installation.

I have config files for stuff like fish shell, i3, and xinitrc.

I also have random scripts that are not actually configuration files, but scripts. So yeah.

Structure
=========
So I structured my files to resemble my Linux OS sort of. So files and directories that go in
`~/.config` are located in the `config` directory. 

The `scripts` directory should be placed in wherever user binaries are placed. For Linux,
this would be `/usr/local/bin`. For OSX, I tend to create a directory in `$HOME` named
bin and add it to my `PATH` environment variable.

The packages directories contains text files that list my installed packages at the time.
So far it has my Arch packages and Atom packages.

Setup
=====
For the `config` directory, simply copy the files over to your `~/.config` directory:
```bash
cp -r config ~/.config
```

For the scripts, you can copy them or run `install` to your user binaries:
```bash
sudo install scripts/* /usr/local/bin
# or
sudo cp scripts/* /usr/local/bin
```

License
=======
The MIT License (MIT)

Copyright (c) 2016 Jeremy Asuncion

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

