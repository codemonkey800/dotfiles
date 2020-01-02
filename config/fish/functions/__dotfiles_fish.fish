function __dotfiles_fish -d 'Commands related to my fish setup'
  set setup_functions false

  for arg in $argv
    switch $arg
      case '--setup-functions'
        set setup_functions true
      case '*'
        echo 'Usage: dotfiles open [directory|file] [editor-args]'
        echo
        echo 'Arguments:'
        echo '  --setup-functions - Creates symbolic links for fish functions'
        return
    end
  end

  if eval $setup_functions
    pushd ~/.config/fish/functions
      echo 'Linking fish functions:'
      ln -svf $DOTFILES/config/fish/functions/* $PWD
      echo

      echo 'Cleaning broken links:'
      for f in $PWD/*
        if not test -e $f
          rm -v $f
        end
      end
    popd
  end
end

