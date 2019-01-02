function l -w ls -d 'Lists all files in a directory or reads a file'
  set cmd 'ls -CAF'

  if test (uname) = 'Linux'
    set cmd "$cmd --color=auto"
  end

  eval "$cmd $argv"
end

