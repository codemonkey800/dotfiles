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
    ln -svf $DOTFILES/config/fish/functions/* ~/.config/fish/functions/
  end
end

