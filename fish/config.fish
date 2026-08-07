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

# Optional machine-local overrides, restored by setup.fish's secrets step — never tracked here
if test -f ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
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

  if not set -q SKIP_TMUX
    # startup tmux or connect to existing session
    if exists tmux; and test -z $TMUX
      if tmux has-session -t main 2>/dev/null
        exec tmux -u a -t main
      else if tmux ls 2>/dev/null | head -1 | string replace -r ':.*' '' | read -l first_session
        exec tmux -u a -t $first_session
      else
        exec tmux -u new -s main
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

# setup pyenv if available
# if type -q pyenv
#   set -Ux PYENV_ROOT $HOME/.pyenv
#   fish_add_path $PYENV_ROOT/bin
#   pyenv init - fish | source
# end

