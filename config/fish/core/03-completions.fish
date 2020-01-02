# Alias completions
complete -c e -w nvim
complete -c lc -w ls
complete -c ll -w ls
complete -c mkcd -w mkdir
complete -c r -w rm
complete -c re -w nvim

# Function completions
function __core_list_files
  set files (
    find "$argv[1]" -not \( \
      -path '.' \
      -o -path '*/.git*' \
      -o -path '*/.venv*' \
      -o -path '*/node_modules*' \
      -o -path '*/__pycache__*' \
    \)
  )

  for file in $files
   set -l dir (dirname "$file")
   if test "$dir" != "$argv[1]"
     set files $files "$dir"
   end
  end

  for i in (seq (count $files))
    set files[$i] (echo $files[$i] | string replace "$argv[1]" '')
  end

  for file in $files
    echo "$file"
  end
end

function __core_list_dirs
  set files (__core_list_files "$argv[1]")
  for file in $files
    test -d "$argv[1]/$file"
    and echo "$file"
  end
end

function __core_is_git_dir
  git rev-parse --show-toplevel ^&1 /dev/null
end

function __core_get_function_description
  set match (
    string match -r "description '(.*)'" \
      (functions "$argv[1]" | head)
  )
  echo "$match[2]"
end

set __core_dotfiles_functions (
  functions -a \
    | rg '__dotfiles' \
    | string replace '__dotfiles_' ''
)

function __core_dotfiles_is_root_command
  set tokens (commandline -co)
  set command $tokens[2]
  not contains -- $command $__core_dotfiles_functions
end

function __core_dotfiles_is_subcommand
  set tokens (commandline -co)
  set command $tokens[2]
  test "$command" = "$argv[1]"
end

function __core_dotfiles_is_on_path_arg
  set token (commandline -t)
  string match -q '/*' $token
end

# Completions for dotfile commands
for f in $__core_dotfiles_functions
  complete \
    -c dotfiles \
    -f \
    -n '__core_dotfiles_is_root_command' \
    -a "$f" \
    -d (__core_get_function_description "__dotfiles_$f")
end

complete \
  -c dotfiles \
  -f \
  -n '__core_dotfiles_is_root_command' \
  -a '/' \
  -d 'Open/Print dotfiles file'

complete \
  -c dotfiles \
  -f \
  -n '__core_dotfiles_is_root_command && __core_dotfiles_is_on_path_arg' \
  -a '(__core_list_files $DOTFILES)'

complete \
  -c dotfiles \
  -f \
  -n '__core_dotfiles_is_subcommand fish' \
  -l 'setup-functions' \
  -d (__core_get_function_description '__dotfiles_fish')

complete \
  -c dotfiles \
  -f \
  -n '__core_dotfiles_is_subcommand open' \
  -a '(__core_list_files $DOTFILES)'

complete \
  -c dotfiles \
  -f \
  -n '__core_dotfiles_is_subcommand print' \
  -a '(__core_list_files $DOTFILES)'

complete -c gr -f -n '__core_is_git_dir' -a '(__core_list_dirs (git rev-parse --show-toplevel))'

# Script completions
complete -c gitignore -f -l list -s l -d 'List gitignore templates'

complete -c rmshit -r -l config -s c -d 'Specify a specific config file to load'
complete -c rmshit -f -l verbose -s v -d "Print out files as they're being deleted"
complete -c rmshit -f -l no-confirm -s y -d 'Delete shitty files without confirmation'

complete -c serve -f -l detach -s d -d 'Run server as tmux session'
complete -c serve -f -l kill -s k -d 'Kills server specified by port'
complete -c serve -f -l list -s l -d 'Lists running servers in background'
complete -c serve -x -l port -s p -d 'Port to start server on'
complete -c serve -r -l work-dir -s w -d 'Directory to start http server in'

complete -c update -f -l aur -d 'Updates pacman and aur packages using `yaourt`'
complete -c update -f -l fish -d 'Updates fisherman, fish completions, and links all dotfiles fish functions'
complete -c update -f -l git -d 'Updates repos located in ~/projects'
complete -c update -f -l pacman -d 'Updates pacman packages using `pacman`'
complete -c update -f -l pacmandb -d 'Updates pacman database using `reflector`'
complete -c update -f -l pkgfile -d 'Updates using `pkgfile`'

