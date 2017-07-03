function y -w yarn -d 'Small, opinionated wrapper over Yarn.'
  function __y_check_exe
    type -q $argv[1]; and return
    echo "$argv[1] is not installed! Run the following to install:"
    echo "  \$ sudo pacman -S $argv[1]"
    clear-functions '__y'
    return -1
  end

  __y_check_exe yarn; or return -1
  __y_check_exe npm; or return -1

  set yarn_dir $PWD/.yarn
  set cmd "env HOME=$yarn_dir yarn"

  if test (count $argv) -gt 0
    switch $argv[1]
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
  end

  eval "$cmd"

  clear-functions '__y'
end
