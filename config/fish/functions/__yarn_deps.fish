function __yarn_deps -d 'Prints dependencies or devDependencies of a toplevel package.json'
  set show_dev true
  set show_prod true
  set show_peer true
  set package "$argv[2]"

  switch "$argv[1]"
    case 'help'
      echo -e 'Usage: yarn deps [type] [package]'
      echo
      echo 'Arguments:'
      echo '  type - The type of dependencies to list. Defaults to both.'
      echo
      echo 'Types:'
      echo '  dev  - Lists only development dependencies'
      echo '  prod - Lists only production dependencies'
      echo '  peer - Lists only peer dependencies'
      return
    case 'dev'
      set show_prod false
      set show_peer false
    case 'prod'
      set show_dev false
      set show_peer false
    case 'peer'
      set show_dev false
      set show_prod false
    case '*'
      set package "$argv[1]"
  end

  if test -z "$package"
    set data (cat package.json)
  else
    if not yarn info "$package" > /dev/null ^&1
      echo "'$package' does not exist!"
      return -1
    end
    set data (yarn --json info "$package" | jq '.data')
  end

  if eval $show_dev
    echo 'Development Dependencies:'
    echo "$data" | jq '.devDependencies'
  end
  if eval $show_prod
    echo 'Production Dependencies:'
    echo "$data" | jq '.dependencies'
  end
  if eval $show_peer
    echo 'Peer Dependencies:'
    echo "$data" | jq '.peerDependencies'
  end
end

