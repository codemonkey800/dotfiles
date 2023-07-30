function dotfiles -d 'Utility command for working with my dotfiles.'
  set functions (
    functions -a \
      | rg '__dotfiles' \
      | string replace '__dotfiles_' ''
  )

  if set -q argv[1] && contains -- $argv[1] '-h' '--help' 'h' 'help'
    echo 'Usage: dotfiles [command]'
    echo
    echo 'The default command used is `open` or `print` in command substitution'
    echo
    echo 'Commands:'

    set max_name_length 0
    for f in $functions
      set name_length (string length "$f")
      if test $name_length -gt $max_name_length
        set max_name_length $name_length
      end
    end

    for f in $functions
      set match (
        string match -r "description '(.*)'" \
          (functions "__dotfiles_$f" | head)
      )
      set name_length (string length "$f")
      set padding_length (math "$max_name_length - $name_length")
      set padding ''

      for i in (seq $padding_length)
        set padding "$padding "
      end

      echo "  $f $padding- $match[2]"
    end

    return
  end

  if contains -- $argv[1] $functions
    set command $argv[1]
    set -e argv[1]
  else if status -c
    set command print
  else
    set command open
  end

  eval "__dotfiles_$command $argv"
end
