#!/opt/homebrew/bin/fish

alias create_link 'ln -svf'

function create_link
  ln -svF $argv \
    | string replace $HOME '~' \
    | string replace $PWD "$(basename $PWD)" \
      | sed 's/^/  /'
end

function install_fisher
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | source && fisher install jorgebucaran/fisher
end

function setup_dirs
  mkdir -p ~/dev ~/var/tmp

  if test "$(readlink ~/etc)" != ~/.config/
    create_link ~/.config/ ~/etc
  end

  if test "$(readlink ~/var/cache)" != ~/.cache/
    create_link ~/.cache/ ~/var/cache
  end

end

function setup_fish
  install_fisher

  mkdir -p ~/etc/fish/functions
  create_link $PWD/fish/config.fish ~/etc/fish

  fisher install < $PWD/fish/fishfile
  create_link $PWD/fish/functions/*.fish ~/etc/fish/functions
  create_link $PWD/fish/fishfile ~/etc/fish
end

function setup_vscode
  set -l vscode_path 'vscode'

  if test (uname) = 'Darwin'
    set vscode_path ~/Library/Application\ Support/Code/User
  end

  create_link $PWD/vscode/*.json $vscode_path
end

function setup_nvim
  mkdir -p ~/etc/nvim/
  create_link $PWD/nvim/* ~/etc/nvim
end

function setup
  setup_dirs
  create_link $PWD/core/{*,.*} ~
  setup_fish
  create_link $PWD/tmux/{*,.*} ~
  setup_vscode
  setup_nvim
end

setup | sort

