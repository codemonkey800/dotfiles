function __yarn_global -d 'Wrapper over yarn global subcommand.'
  if test "$argv[1]" = 'ls'
    set argv[1] 'list'
  end

  eval "command yarn global $argv"
end
