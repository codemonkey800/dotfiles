function node-deps -d ''
  set filter '.dependencies, .devDependencies'
  switch "$argv[1]"
    case ''
    case 'dev'
      set filter '.devDependencies'
    case 'prod'
      set filter '.dependencies'
    case '*'
      echo -e 'Usage: node-deps [type]'
      echo
      echo 'Arguments:'
      echo '  type - The type of dependencies to list. Defaults to both.'
      echo
      echo 'Types:'
      echo '  dev  - Lists only development dependencies'
      echo '  prod - Lists only production dependencies'
      return
  end

  if test -f package.json
    jq $filter package.json
  else
    echo 'No "package.json" in current directory.'
    return -1
  end
end

