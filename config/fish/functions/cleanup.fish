function cleanup -d 'Runs several cleanup utilities on my computer'
  echo 'y' | sudo pacman -Scc > /dev/null ^&1

  if set packages (pacman -Qqdtt)
    sudo pacman -Rscun --noconfirm $packages
  end

  set tmpfiles /tmp/{flow,fzf,npm,nvim,yaourt}*
  set tmpfiles_length (count $tmpfile)
  if test $tmpfiles_length -gt 0
    echo "Removing $tmpfiles_length temporary files!"
    sudo rm -rf $tmpfiles
  end

  rmshit -vy > /dev/null ^&1

  echo -n 'Done Cleaning!' | cowsay -f (random-cow) | lolcat
end
