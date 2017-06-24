function y -w yarn -d 'Small, opinionated wrapper over Yarn.'
  function __y_check_exe
    type -q $argv[1]; and return
    echo "$argv[1] is not installed! Run the following to install:"
    echo "  \$ sudo pacman -S $argv[1]"
    clear-functions 'y::'
    exit -1
  end

  __y_check_exe yarn
  __y_check_exe npm

  set yarn_dir $PWD/.yarn
  set flags "--mutex file:$yarn_dir/mutex"

  if set -q argv[1]
    switch $argv[1]
      case 'init'
        npm init
        return
      case 'global'
        set flags "--prefix $yarn_dir $flags"
    end
  end

  eval "env HOME=$yarn_dir yarn $argv $flags"

  clear-functions '__y'
end
