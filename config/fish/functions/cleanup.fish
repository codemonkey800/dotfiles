function cleanup -d 'Runs several cleanup utilities on my computer'
	echo 'y' | sudo pacman -Scc > /dev/null ^&1

  if set packages (pacman -Qqdtt)
      sudo pacman -Rscun --noconfirm $packages
  end

  set tmpfiles /tmp/{flow,fzf,npm,nvim,yaourt}*
  if test (count $tmpfiles) -gt 0
    echo "Removing "(count $tmpfiles)" temporary files!"
    sudo rm -rf $tmpfiles
  end

  rmshit -vy > /dev/null ^&1

  printf 'Done Cleaning!' | cowsay -f (random-cow) | lolcat
end
