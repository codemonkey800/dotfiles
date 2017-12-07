function gitignore -d "Retrieves gitignore files from gitignore.io"
  function __gitignore_help
    echo 'Usage: gitignore [list|<template>...]'
    echo
    echo 'Arguments:'
    echo '  template - Template or templates to fetch.'
    echo
    echo 'Commands:'
    echo '  list     - Lists all gitignore templates available.'
    echo
    echo 'Notes:'
    echo '  You can add multiple templates by using spaces or commas to'
    echo '  separate them. The comma format is the default used by'
    echo '  gitignore.io. If you omit any arguments, then an fzf window will pop up.'
    echo
    echo 'Example:'
    echo '  Fetch gitignore for node'
    echo '    $ gitignore node'
    echo
    echo '  Fetch gitignore for node and python'
    echo '    $ gitignore node,python'
    echo '    $ gitignore node python'
  end

  function __gitignore_fetch -a endpoint
    curl -sL "https://gitignore.io/api/$endpoint"
  end

  function __gitignore_check_response -a response
    set matches (
      echo "$response" \
        | string match -r '[\S]+ is undefined' \
        | pawk 'f[0]'
    )
    if test (count $matches) -eq 0
      return
    else
      echo "The following templates don't exist:"
      for match in $matches
        echo "  $match"
      end
      return -1
    end
  end

  function __gitignore_fzf
    set endpoint 'https://gitignore.io/api'
    set selected (
      curl -sL "$endpoint/list" \
        | tr ',' '\n' \
        | sort -u \
        | fzf-tmux -m
    )

    if test -z $selected
      echo 'No templates selected.'
      return
    end

    set selected (echo $selected | tr ' ' ',')
    curl -sL "$endpoint/$selected"
  end

  set argc (count $argv)
  set exit_code 0
  set current_ifs "$IFS"

  if test $argc -eq 0
    __gitignore_fzf
  else
    switch "$argv[1]"
      case 'list'
        __gitignore_fetch list | string split ','
      case 'help'
        __gitignore_help
      case '*'
        # The only way to preserve newlines from a command substitution
        # is to set the IFS variable to an empty string. Thank you to
        # glenn jackman for the solution to this problem:
        # https://stackoverflow.com/a/29515237
        set -l endpoint (string join ',' $argv)

        set IFS ''
        set -l response (__gitignore_fetch "$endpoint")
        set IFS "$current_ifs"

        __gitignore_check_response "$response"
        and echo "$response"
        or set exit_code -1
      end
  end

  clear-functions '__gitignore'
  return $exit_code
end
