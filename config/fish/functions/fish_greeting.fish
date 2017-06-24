function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
  fortune -n 'long' 'computers' 'linux' 'off' 'myfortunes' \
    | cowsay -nf (random-cow) \
    | lolcat
  echo
end

