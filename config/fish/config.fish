# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
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

# sort and keep only unique paths
set PATH (paths | sort -u)

# Symlink ssh configs if needed
if test (uname) = 'Darwin'
  if test (readlink ~/.ssh/config) = $DOTFILES/config/ssh/config
    ln -sf $DOTFILES/config/ssh/config-macos ~/.ssh/config
  end
else
  if test (readlink ~/.ssh/config) = $DOTFILES/config/ssh/config-macos
    ln -sf $DOTFILES/config/ssh/config ~/.ssh/config
  end
end

if status -i
  # Don't use keychain or automatic gpg server conf switching for macOS
  if test (uname) != 'Darwin'
    # stuff to do if a display server isn't available
    if test -z $DISPLAY
      # Start keychain for when the $DISPLAY variable isn't defined and fish is interactive
      if exists keychain
        set -l keys (
          for f in ~/.ssh/*.pub
            echo ~/.ssh/(basename $f .pub)
          end
        )

        if test (count $keys) -gt 0
          env SHELL=fish keychain --eval --agents ssh --quick --quiet --nogui $keys | source
        end
      end

      if test (readlink ~/.gnupg/gpg-agent.conf) = $DOTFILES/config/gnugpg/gpg-agent.conf
        toggle-pinentry > /dev/null
      end
    else
      # Have keychain kill all ssh-agent's if any are running and $DISPLAY is defined
      if exists keychain; and test (count (keychain -l)) -gt 0
        keychain --quiet -k all
      end

      if test -e ~/.keychain
        rm -rf ~/.keychain
      end

      if test (readlink ~/.gnupg/gpg-agent.conf) = $DOTFILES/config/gnugpg/gpg-agent-tty.conf
        toggle-pinentry > /dev/null
      end
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

