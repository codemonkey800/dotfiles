function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
  set fortunes 'long' 'computers' 'off' 'myfortunes'

  if test (uname) != 'Darwin'
    set fortunes $fortunes 'linux'
  end

  fortune -n $fortunes \
    | cowsay -nf (random-cow) \
    | lolcat ^ /dev/null
  echo
end

