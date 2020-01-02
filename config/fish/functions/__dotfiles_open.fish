function __dotfiles_open -d 'Opens a directory or file in $EDITOR with virtualenv activated'
  set is_no_env false

  for i in (seq (count $argv))[-1..1]
    set arg $argv[$i]

    switch $arg
      case '--no-env'
        set -e argv[$i]
        set is_no_env true
      case '-h' '--help' 'h' 'help'
        echo 'Usage: dotfiles open [options] [directory|file] [editor-args]'
        echo
        echo 'Options:'
        echo '  --no-env    - Don\'t use virtualenv'
        echo
        echo 'Arguments:'
        echo '  directory   - Switch to a specific directory.'
        echo '  file        - Activates the dotfiles virtualenv and opens a file for editing.'
        echo '  editor-args - Arguments to pass to $EDITOR if a file is specified.'
        return
    end
  end

  set file (
    set -q argv[1]
    and echo $DOTFILES/$argv[1]
    or echo $DOTFILES
  )
  if not test -e $file
    echo "'$file' does not exist!"
    return -1
  end

  if eval $is_no_env
    if test -d $file
      cd $file
    else
      # Remove file arg and pass editor args.
      set -e argv[1]
      eval "$EDITOR $argv $file"
    end
  else
    pushd $DOTFILES
      # If a virtual env isn't present, create one.
      if not test -f .venv/bin/activate.fish
        python -m venv .venv
        source .venv/bin/activate.fish
        pip install -r requirements.txt
      end

      if not set -q VIRTUAL_ENV
        source .venv/bin/activate.fish
      end

      if test -d $file
        # Run in another shell to go back to last directory
        cd $file
        fish -C 'echo "Ctrl+D to return to previous directory"'
      else
        # Remove file arg and pass editor args.
        set -e argv[1]
        eval "$EDITOR $argv $file"
      end

      deactivate
    popd
  end
end

