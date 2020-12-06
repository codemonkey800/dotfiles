function l -w ls -d 'Lists all files in a directory or reads a file'
  set cmd
  set flags
  set files

  for arg in $argv
    switch $arg
     case '-*' '--*'
        set flags $flags $arg
      case '*'
        set files $files $arg
    end
  end

  if test (count $files) -eq 1 -a ! -d "$files[1]"
    switch "$files[1]"
      case '*.tar.gz'
        set cmd 'tar'
        set flags $flags '-tf'
      case '*.7z'
        set cmd '7z'
        set flags $flags 'l'
      case '*.zip'
        set cmd 'unzip'
        set flags $flags '-l'
      case '*'
        set cmd 'bat'
    end
  else
    set cmd 'ls'
    set flags $flags '-AFG'
  end

  $cmd $flags $files
end

