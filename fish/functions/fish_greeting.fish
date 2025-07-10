function fish_greeting -d 'Displays a fortune in a cowsay cow and pipes it to lolcat for color.'
  # Don't show greeting in VSCode terminal
  if test "$TERM_PROGRAM" = "vscode"
    return
  end

  set fortunes 'computers' 'drugs' 'food' 'myfortunes'

  if test (uname) != 'Darwin'
    set fortunes $fortunes 'linux'
  end

  fortune -n $fortunes \
    | cowsay -nf (random-cow) \
    | lolcat 2> /dev/null
  echo
end

