function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
  set cows (cowsay -l | sed 1d | string split ' ')
  set cow $cows[(random 1 (count $cows))]
  fortune -n long computers linux off myfortunes \
    | cowsay -nf $cow \
    | lolcat
  echo
end

