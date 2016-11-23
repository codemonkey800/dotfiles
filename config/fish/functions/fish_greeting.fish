function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n | lolcat
    echo
end

