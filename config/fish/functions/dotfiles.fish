function dotfiles -d 'Switches to or prints (in command substitution) the dotfiles repo.'
  if status -c
    echo $DOTFILES
    return
  end

  if test (count $argv) -eq 0
    cd $DOTFILES
    return
  end

  if contains -- -h $argv; or contains -- --help $argv
    echo 'Usage: dotfiles [directory|file] [editor-args]'
    echo
    echo 'Ommitting arguments has different results. If the command'
    echo 'is in command substitution, then the dotfiles directory is printed.'
    echo 'Otherwise, cd into the directory.'
    echo
    echo 'Arguments:'
    echo '  directory   - Switch to a specific directory.'
    echo '  file        - Activates the dotfiles virtualenv and opens a file for editing.'
    echo '  editor-args - Arguments to pass to $EDITOR if a file is specified.'
    return
  end

  # A directory is a file, so we make no distinction here.
  set file $DOTFILES/$argv[1]
  if test ! -e $file
    echo "'$file' does not exist!"
    return -1
  end

  if test -d $file
    cd $file
    return
  end

  pushd $DOTFILES
    # If a virtual env isn't present, create one.
    if test ! -f .venv/bin/activate.fish
      python -m venv .venv
      source .venv/bin/activate.fish
      pip install -r requirements.txt
    end
    if set -e VIRTUAL_ENV
      source .venv/bin/activate.fish
    end
    # Remove file arg and pass editor args.
    set -e argv[1]
    eval "$EDITOR $argv $file"
    deactivate
  popd
end

