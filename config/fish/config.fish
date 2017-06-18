# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
  echo "==> Fisherman not found. Installing."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
  echo 'Fisher installed. Restart your shell and use the "fisher" command.'
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

function __config-set-gpg-agent-type
  set -l gpg_agent_conf_path "$DOTFILES/config/gnugpg/gpg-agent%s.conf"

  switch $argv[1]
    case 'tty'
      set gpg_agent_conf_path (printf $gpg_agent_conf_path '-tty')
    case '*'
      set gpg_agent_conf_path (printf $gpg_agent_conf_path '')
  end

  if test \
    -f $gpg_agent_conf_path \
    -a -d ~/.gnupg \
    -a $gpg_agent_conf_path != (readlink ~/.gnupg/gpg-agent.conf)
    ln -sf $gpg_agent_conf_path ~/.gnupg/gpg-agent.conf
    gpg-connect-agent reloadagent /bye
  end
end

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

  __config-set-gpg-agent-type tty

  if test -d ~/.gnupg -a $DOTFILES/config/gnugpg/gpg-agent-tty.conf != ~/.gnupg/gpg-agent.conf
    ln -sf $DOTFILES/config/gnugpg/gpg-agent-tty.conf ~/.gnupg/gpg-agent.conf
  end
else
  # Have keychain kill all ssh-agent's if any are running and $DISPLAY is defined
  if exists keychain; and test (count (keychain -l)) -gt 0
    keychain --quiet -k all
  end
  if test -e ~/.keychain
    rm -rf ~/.keychain
  end

  __config-set-gpg-agent-type default
end

# startup tmux or connect to existing session
if exists tmux; and test -z $TMUX
  if tmux ls | grep -q main
    exec tmux a -t (whoami)/main
  else
    exec tmux new -s (whoami)/main
  end
end

 clear-functions __config

