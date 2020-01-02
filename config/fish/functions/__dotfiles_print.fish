function __dotfiles_print -d 'Prints a dotfiles file with $DOTFILES prepended'
  for arg in $argv
    switch $arg
      case '-h' '--help' 'h' 'help'
        echo 'Usage: dotfiles print [directory|file]'
        return
    end
  end

  set file (
    set -q argv[1]
    and echo $DOTFILES/$argv[1]
    or echo $DOTFILES
  )
  if not test -e $file
    echo "'$file' does not exist!"
    return -1
  end

  echo $file | string replace '//' '/'
end

