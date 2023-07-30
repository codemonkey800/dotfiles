function __yarn_tags -d 'Prints dist tags for a package'
  set package "$argv[1]"

  if test "$package" = ''
    echo 'yarn tags <package>'
    exit -1
  end

  yarn info "$package" dist-tags
end
