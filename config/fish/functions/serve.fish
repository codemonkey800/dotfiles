function serve -d 'Starts a static HTTP server in the current dir.'
  set cmd "python3 -m http.server"
  set port 8080

  if set -q 'argv[1]'
    set port $argv[1]
  end

  if test $port -lt 0 -o $port -gt 65535
    echo 'Port range allowed: 0-65535'
    return -1
  else if test $port -lt 1024
    # prepend sudo if we're using a reserved port
    set cmd "sudo $cmd"
  end

  set cmd "$cmd $port"
  eval "$cmd"
end

