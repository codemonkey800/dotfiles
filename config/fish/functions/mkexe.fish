function mkexe -d 'Creates a script that is executable.'
  set n (count $argv)
  if test $n -eq 0; or contains -- "$argv" h help -h --help
    __mkexe_help
    __mkexe_exit
  end

  set file "$argv[1]"

  if test -f $file; and set shebang (head -n 1 $file | grep '#!' ^ /dev/null)
    echo "'$file' already has the following shebang: '$shebang'"
    __mkexe_exit -1
  end

  set shebang '/usr/bin/env fish'
  if test $n -ge 2
    set command $argv[2]
    if test -f $command
      test -x $command; and set shebang $command
    else
      if string match -r '\s' "$command"
        echo 'Command not have spaces in them!'
        return -1
      end
      if not type -fp $command > /dev/null ^&1
        echo "$command isn't in your PATH"
        return -1
      end
      set shebang "/usr/bin/env $command"
    end
  end

  touch $file
  chmod +x $file
  echo -e "#!$shebang\n" | cat - $file | sponge $file
end

function __mkexe_help
  echo 'Usage: mkexe filename [command|exe_path]'
  echo
  echo 'Arguments:'
  echo '  filename - The filename of the new executable script'
  echo '  command  - A command to run through "type"'
  echo '  exe_path - An absolute or relative path to an executable'
end

function __mkexe_create_file
  touch "$argv[1]"
  chmod +x "$argv[1]"
end

function __mkexe_exit
  clear-functions __mkexe
  set exit_status 0
  if set -q 'argv[1]'
    set exit_status "$argv[1]"
  end
  exit "$argv[1]"
end

