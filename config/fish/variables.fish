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
set PATH $PATH ./node_modules/.bin

# FZF stuff
if type -q fzf
  set -gx FZF_TMUX 1

  function __fzf_user_find \
    -d 'Finds files in the current directory'
    ag -l --hidden --ignore .git | sort -fu
  end

  function __fzf_user_cd \
    -d 'Finds directories to potentially cd into'
    find . \
      -type d \
      -not \( \
        -path '\.' \
        -o -path '*/\.*' \
      \) \
    | sed 's|\./||' | sort -fu
  end
  function __fzf_user_cd_hidden \
    -d 'Finds directories to potentially cd into, including hidden dirs'
    find . \
      -type d \
      -not \( \
        -path '\.' \
        -o -path '*/\.git' \
        -o -path '*/\.git/*' \
      \) \
    | sed 's|\./||' | sort -fu
  end

  set -gx FZF_FIND_FILE_COMMAND '__fzf_user_find'
  set -gx FZF_CD_COMMAND '__fzf_user_cd'
  set -gx FZF_CD_WITH_HIDDEN_COMMAND '__fzf_user_cd_hidden'
end

