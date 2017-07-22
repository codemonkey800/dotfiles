function yarn -w yarn -d 'Small, opinionated wrapper over Yarn.'
  function __yarn_check_exe
    type -q $argv[1]; and return
    echo "$argv[1] is not installed! Run the following to install:"
    echo "  \$ sudo pacman -S $argv[1]"
    return -1
  end

  set yarn_dir $PWD/.yarn
  set cmd 'yarn'
  set exit_code 0

  __yarn_check_exe yarn
  or set exit_code -1

  __yarn_check_exe npm
  or set exit_code -1

  test (count $argv) -gt 0
  and switch "$argv[1]"
    case 'init'
      set cmd 'npm init'
    case 'ls'
      set cmd 'npm ls'
    case 'global'
      set -e argv[1]
      set cmd "$cmd global --prefix=$yarn_dir"
      if set -q argv[1]; and test "$argv[1]" = 'ls'
        set -e argv[1]
        set cmd "$cmd list $argv"
      else
        set cmd "$cmd $argv"
      end
    case '*'
      set cmd "$cmd $argv"
  end

  eval "command $cmd"
  set exit_code $status

  clear-functions '__yarn'
  return $exit_code
end
