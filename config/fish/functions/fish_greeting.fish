function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
    set cows (cowsay -l | sed 1d | string split ' ')
    set cow $cows[(random 1 (count $cows))]
    fortune 50% myfortunes 30% off 20% ascii-art \
        | cowsay -nf $cow \
        | lolcat
    echo
end

