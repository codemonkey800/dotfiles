function yarn -w yarn -d 'Small, opinionated wrapper over Yarn. Similar to git command where __yarn-<cmd> is called with yarn <cmd>.'
  if not type --no-functions --query yarn
    echo 'Yarn is not installed!'
    return -1
  end

  set cmd 'command yarn'
  set is_subcommand false
  set is_user_command false

  if not string match -qr -- '-[a-zA-Z0-9]+' "$argv[1]"
    set is_subcommand true
  end

  if type --query "__yarn_$argv[1]"
    set is_user_command true
  end

  if eval "eval $is_subcommand; and $is_user_command"
    set cmd "__yarn_$argv[1]"
    set -e argv[1]
  end

  eval "$cmd $argv"
end
