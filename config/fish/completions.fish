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
function __dotfiles_list_files
  set files (ag -g '' $DOTFILES)

  for file in $files
   set -l dir (dirname $file)
   if test $dir != $DOTFILES
     set files $files $dir
   end
  end

  for i in (seq (count $files))
    set files[$i] (echo $files[$i] | string replace $DOTFILES '')
  end

  printf (echo $files | string replace -a ' ' '\n') | sort -u
end

complete -c dotfiles -x -d 'Open directory or open file for editing' -a '(__dotfiles_list_files)'

complete -c node-deps -x -d 'Lists only development dependencies.' -a dev
complete -c node-deps -x -d 'Lists only production dependencies.' -a prod

