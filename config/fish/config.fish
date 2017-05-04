# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end

# Dotfiles path
set -gx DOTFILES (
  set dir (status -f)
  if test -L $dir
    set dir (readlink $dir)
  end
  readlink -f (dirname $dir)/../..
)

source $DOTFILES/config/fish/colors.fish
source $DOTFILES/config/fish/variables.fish
source $DOTFILES/config/fish/aliases.fish
source $DOTFILES/config/fish/completions.fish

# sort and keep only unique paths
set PATH (paths | sort -u)

# exit if non-interactive at this point
not status -i; and exit

# stuff to do if a display server isn't available
if test -z $DISPLAY
  # source profile.d stuff if a display manager isn't used
  if exists bass
    for f in /etc/profile.d/*.sh
      bass source $f > /dev/null ^ /dev/null
    end
  end

  # Start keychain for when the $DISPLAY variable isn't defined and fish is interactive
  if exists keychain
    set -l keys (
      for f in ~/.ssh/*.pub
        echo ~/.ssh/(basename $f .pub)
      end
    )

    if test (count $keys) -gt 0
      keychain --eval --agents ssh --quick --quiet --nogui $keys | source
    end
  end
else
  # Have keychain kill all ssh-agent's if any are running and $DISPLAY is defined
  if exists keychain; and test -f ~/.keychain; and test (count (keychain -l)) -gt 0
    keychain --quiet -k all
    rm -rf ~/.keychain
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

