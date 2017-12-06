# Command Completions
complete -c hub -w git

# Alias completions
complete -c e -w nvim
complete -c lc -w ls
complete -c ll -w ls
complete -c mkcd -w mkdir
complete -c r -w rm
complete -c re -w nvim

# Function completions
complete -c dotfiles -x -d 'Open directory or open file for editing' -a (
  set files (ag -g '')
  set dirs

  for file in $files
    set -l dir (dirname $file)
    if test $dir != .
      set dirs $dirs $dir
    end
  end

  echo $files $dirs | sort -u
)

complete -c node-deps -x -d 'Lists only development dependencies.' -a dev
complete -c node-deps -x -d 'Lists only production dependencies.' -a prod

