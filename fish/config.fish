# Dotfiles path
set -gx DOTFILES (
  set -l config_file (readlink (status -f))
  set -l dir (dirname $config_file)
  pushd $dir
    cd ..
    pwd
  popd
)

# Source everything in core dir using file ordering
for core_script in $DOTFILES/fish/core/*.fish
  source $core_script
end

# keep only unique paths
set PATH (paths | awk '!x[$0]++')

if status -i
  # Don't use keychain for macOS
  if test (uname) != 'Darwin'
    set -l keys (
      for f in ~/.ssh/*.pub
        echo ~/.ssh/(basename $f .pub)
      end
    )

    if test (count $keys) -gt 0
      env SHELL=fish keychain \
        --agents ssh \
        --eval \
        --nogui \
        --quick \
        --quiet \
        $keys | source
    end
  end

  echo $SKIP_TMUX

  if not set -q SKIP_TMUX
    # startup tmux or connect to existing session
    if exists tmux; and test -z $TMUX
      if tmux ls | grep -q main
        exec tmux a -t (whoami)/main
      else
        exec tmux new -s (whoami)/main
      end
    end
  end
end

# Load completions from bin
begin
  set -l scripts (fd -d 1 -t l . $DOTFILES/bin)
  for x in $scripts
    $x --completion-fish | source
  end
end

# setup pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source

