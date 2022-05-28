#!/usr/bin/env fish

set name (basename (status -f))
set root $DOTFILES/bin/py
set script (
  test -f $root/$name.py
  and echo $root/$name.py
  or echo $root/$name/main.py
)

source $root/env.fish
python $script $argv

deactivate

