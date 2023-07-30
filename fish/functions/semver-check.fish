function semver-check -d 'Uses semver.io to check versions for node, npm, and yarn.'
  # Mapping of variable name to friendly string name
  set node 'Node'
  set npm 'NPM'
  set yarn 'Yarn'

  for x in 'node' 'npm' 'yarn'
    set -l current_version (eval "$x" -v | string replace 'v' '')
    set -l latest_version (curl -s "https://semver.io/$x/unstable")
    if test "$current_version" = "$latest_version"
      echo "$$x $current_version up-to-date!"
    else
      echo "$$x $current_version -> $latest_version"
    end
  end
end

