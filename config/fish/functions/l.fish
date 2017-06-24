function l -d 'Lists all files in a directory or reads a file'
  set pager false
  set args
  set files

  for i in (seq (count $argv))
    set -l arg $argv[$i]
    switch $arg
      case -p --pager
        set pager true
      case '--*' '-*'
        set args $args $arg
      case '*'
        set files $files $arg
    end
  end

  if test (count $files) -eq 1; and test -f "$files[1]"
    if test -f "$files[1]"
      if eval "$pager"
        eval "less -N $files[1]"
      else
        # pipe file through syntax highlighter
        # depending on syntax
        switch (echo "$files[1]" | pawk -F'.' 'f[-1]')
          case 'json'
            jq '.' "$files[1]"
          case '*'
            pygmentize -g "$files[1]"
        end
      end
    else
      echo "'$files[1]' doest not exist!"
      return -1
    end
  else
    for file in $files
      if not test -e "$file"
        echo "'$file' does not exist!"
        return -1
      end
    end

    set cmd 'ls -CAF'

    if test (uname) = 'Linux'
      set cmd "$cmd --color=auto"
    end

    set cmd "$cmd $args $files"

    if eval $pager
      set cmd "$cmd | $PAGER"
    end

    eval $cmd
  end
end

