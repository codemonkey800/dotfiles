function njs -d 'Simple script for installing node.js and yarn'
  set node_version $argv[1]
  set os (uname | tr '[:upper:]' '[:lower:]')
  set update_npm false

  if test -e $node_version
    echo 'Usage: njs <node_version|profile>'
    echo
    echo 'Examples:'
    echo '  $ njs 7.9.0'
    echo '  $ njs 10.0.0'
    echo
    echo 'Examples with profiles:'
    echo '  $ njs current'
    echo '  $ njs sumo'
    return
  end

  switch "$node_version"
    case 'current'
      set node_version (curl -sL 'https://semver.io/node/unstable')
      set update_npm true
    case 'sumo'
      set node_version '12.7.0'
      set is_sumo true
    case '*'
      echo "Invalid node_version: '$node_version'"
      exit -1
  end

  mkdir -p ~/.nodejs
  rm -rf ~/.nodejs/{node,yarn}

  pushd ~/.nodejs
    echo "Fetching node v$node_version"
    set -l base "node-v$node_version-$os-x64"
    wget -qO- --show-progress "https://nodejs.org/dist/v$node_version/$base.tar.gz" | tar -zxf -
    mv $base node

    echo 'Fetching latest yarn'
    wget -qO- --show-progress https://yarnpkg.com/latest.tar.gz | tar -zxf -
    mv yarn-* yarn
  popd

  set global_packages neovim npm-check-updates

  if eval $update_npm
    echo 'Updating npm!'
    set global_packages $global_packages npm@next
  end

  echo 'Installing global packages:'
  for package in $global_packages
    echo "  $package"
  end
  npm -g install $global_packages

  echo 'Done!'
end

