function node-deps -d ''
  set filter '.dependencies, .devDependencies'
  switch "$argv[1]"
    case '-d' '--development'
      set filter '.devDependencies'
    case '-p' '--production'
      set filter '.dependencies'
    case '*'
      echo -e 'Usage: node-deps [options]\n'
      echo 'Options:'
      echo '  -d, --development - Lists only development dependencies'
      echo '  -p, --production  - Lists only production dependencies'
      return
  end

  if test -f package.json
    jq $filter package.json
  else
    echo 'No "package.json" in current directory.'
    return -1
  end
end

