function cleanup -d 'Runs several cleanup utilities on my computer.'
  echo 'y' | sudo pacman -Scc > /dev/null ^&1

  if set packages (pacman -Qqdtt)
    sudo pacman -Rscun --noconfirm $packages
  end

  rmshit -vy > /dev/null ^&1

  echo -n 'Done Cleaning!' | cowsay -f (random-cow) | lolcat
end
