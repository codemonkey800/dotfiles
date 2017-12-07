function yarn -w yarn -d 'Small, opinionated wrapper over Yarn. Similar to git command where __yarn-<cmd> is called with yarn <cmd>.'
  if not type -qf yarn
    echo 'Yarn is not installed!'
    return -1
  end

  set cmd 'command yarn'

  # If the first arg is a subcommand, then search for subcommands of yarn.
  if not string match -qr -- '-[a-zA-Z0-9]+' "$argv[1]"; and type -q "__yarn_$argv[1]"
    set cmd "__yarn_$argv[1]"
    set -e argv[1]
  end

  eval "$cmd $argv"
end
