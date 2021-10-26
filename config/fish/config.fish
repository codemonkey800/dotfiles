# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fAhtr
  echo 'Fisher installed. Restart your shell and use the "fisher" command.'
end

# Dotfiles path
set -gx DOTFILES (
  set -l rl 'readlink'
  if test (uname) = 'Darwin'
    set rl 'greadlink'
  end

  set -l config_file (status -f)
  set -l config_file (eval "$rl -e $config_file")
  set -l dir (dirname $config_file)
  eval "$rl -e $dir/../.."
)

# Source everything in core dir using file ordering
for core_script in $DOTFILES/config/fish/core/*.fish
  source $core_script
end

# keep only unique paths
set PATH (paths | awk '!x[$0]++')

# Symlink ssh configs if needed
begin
  set -l ssh_config (readlink ~/.ssh/config)

  if test (uname) = 'Darwin'
    if test "$ssh_config" = $DOTFILES/config/ssh/config
      ln -sf $DOTFILES/config/ssh/config-macos ~/.ssh/config
    end
  else if test "$ssh_config" = $DOTFILES/config/ssh/config-macos
    ln -sf $DOTFILES/config/ssh/config ~/.ssh/config
  end
end

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

  # startup tmux or connect to existing session
  if exists tmux; and test -z $TMUX
    if tmux ls | grep -q main
      exec tmux a -t (whoami)/main
    else
      exec tmux new -s (whoami)/main
    end
  end
end



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/jasuncion/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

