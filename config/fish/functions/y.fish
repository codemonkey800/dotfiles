function y -d 'Small, opinionated wrapper over Yarn.' -w yarn
  set -g should_exit false

  function __y_check_exe
    type -q $argv[1]; and return
    echo "$argv[1] is not installed! Run the following to install:"
    echo "  \$ sudo pacman -S $argv[1]"
    set should_exit true
    echo $should_exit
  end

  __y_check_exe yarn
  __y_check_exe npm

  if eval $should_exit
    clear-functions __y
    set -e should_exit
    return -1
  end

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

  clear-functions __y
  set -e should_exit
end
