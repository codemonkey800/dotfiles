function toggle-pinentry -d 'Swaps the current gpg-agent.conf link to gpg-agent.conf or gpg-agent-tty.conf'
  set -l next_conf $DOTFILES/config/gnugpg/gpg-agent.conf
  set -l gpg_conf ~/.gnupg/gpg-agent.conf

  if test (readlink $gpg_conf) = $DOTFILES/config/gnugpg/gpg-agent.conf
    set next_conf (dirname $next_conf)/gpg-agent-tty.conf
  end

  ln -svf $next_conf $gpg_conf
  gpg-connect-agent reloadagent /bye
end

