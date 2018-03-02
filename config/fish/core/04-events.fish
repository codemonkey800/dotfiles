# Event handler that monitors current working directory an adds $PWD/node_modules/.bin to $PATH if it exists.
function node-modules-bin -v PWD
  set dir $PWD/node_modules/.bin

  if test -d $dir
    set PATH $PATH $dir
    set -gx __node_modules_bin_last_dir $dir

    echo "Added $dir to your PATH"
  else if set -q __node_modules_bin_last_dir
    set -l idx -1
    for i in (seq (count $PATH))
      if test $__node_modules_bin_last_dir = $PATH[$i]
        set idx $i
        break
      end
    end

    set -e __node_modules_bin_last_dir

    if test $idx -ge 0
      set -e PATH[$idx]
    end

    echo "Removed $dir from your PATH"
  end
end
