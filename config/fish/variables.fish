# less stuff
set -gx LESS '-R'
set -gx LESSOPEN '|pygmentize -g %s'

# development environment
set -gx DIRENV_LOG_FORMAT
set -gx EDITOR (type -p nvim)
set -gx NVIM_LISTEN_ADDRESS /tmp/nvim-(whoami).socket
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# GPG stuff
set -gx ENCRYPTION_KEY A1CE3226F4FDEFF5
set -gx GPG_TTY (tty)
set -gx SIGNING_KEY 3FCC32880193C153

# locale stuff
set -gx LANG en_US.UTF-8

# pager stuff
set -gx PAGER less

# PATH stuff
set PATH $PATH ~/bin
set PATH $PATH $DOTFILES/bin

# FZF stuff
if type -q fzf
  set -gx FZF_TMUX 1

  # set fzf find file command to use the_silver_searcher
  # this includes hidden files and directories by default
  set -gx FZF_FIND_FILE_COMMAND '
    if git status > /dev/null ^&1
      set -l files (
        ag -g "" \
           --hidden \
           --ignore .git \
           ^ /dev/null
      )
      for f in $files
        echo $f
        dirname $f
      end | sort -fru
  '

  # set fzf cd command to use the_silver_searcher
  set -gx FZF_CD_COMMAND '
    set -l files (ag -g "" --ignore .git ^ /dev/null)
    for f in $files
      set -l dir (dirname $f)
      test "$dir" != "."; and echo $dir
    end | sort -fru
  '

  # set fzf cd with hidden command to use the platinum_searcher if in git repo,
  # otherwise use find command
  set -gx FZF_CD_WITH_HIDDEN_COMMAND '
    set -l files (
      ag -fg "" \
         --hidden \
         --ignore .git \
         ^ /dev/null
    )
    for f in $files
      dirname $f
    end | sort -fru
  '
end

