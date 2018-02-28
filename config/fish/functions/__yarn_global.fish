function __yarn_global -d 'Wrapper over yarn global subcommand.'
  if test "$argv[1]" = 'ls'
    set -e argv[1]
    set cmd "$cmd list"
  end

  eval "$cmd $argv"
end
