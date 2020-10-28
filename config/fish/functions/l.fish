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
    set cmd 'bat'
  else
    set cmd 'ls'
    set flags $flags '-AFG'
  end

  $cmd $flags $files
end

