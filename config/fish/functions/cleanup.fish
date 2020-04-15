function cleanup -d 'Runs several cleanup utilities on my computer.'
  echo 'y' | sudo pacman -Scc &> /dev/null

  if set packages (pacman -Qqdtt)
    sudo pacman -Rscun --noconfirm $packages
  end

  rmshit -vy &> /dev/null

  echo -n 'Done Cleaning!' | cowsay -f (random-cow) | lolcat
end
