function y -w yarn -d 'Small, opinionated wrapper over Yarn.'
  function __y_check_exe
    type -q $argv[1]; and return
    echo "$argv[1] is not installed! Run the following to install:"
    echo "  \$ sudo pacman -S $argv[1]"
    clear-functions '__y'
    exit -1
  end

  __y_check_exe yarn
  __y_check_exe npm

  set yarn_dir $PWD/.yarn

  function __y_wrapper
    env HOME=$yarn_dir yarn $argv
  end

  if set -q argv[1]
    switch $argv[1]
      case 'init'
        npm init
        return
      case 'ls'
        npm ls
        return
      case 'global'
        set -e argv[1]
        __y_wrapper global --prefix=$yarn_dir $argv
        return
    end
  end

  __y_wrapper $argv

  clear-functions '__y'
end
