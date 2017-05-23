function cleanup --description 'Runs several cleanup utilities on my computer'
	echo 'y' | sudo pacman -Scc > /dev/null ^&1

    if set -l packages (pacman -Qqdtt)
        sudo pacman -Rscun --noconfirm $packages
    end

    eval 'sudo rm -rf /tmp/{flow,fzf,npm,nvim,yaourt}*' ^ /dev/null

    rmshit -vy > /dev/null ^&1

    printf 'Done Cleaning!' | cowsay -f (random-cow) | lolcat
end
