# less stuff
set -gx LESS '-R'
set -gx LESSOPEN '|pygmentize -g %s'

# development environment
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
set PATH $PATH $DOTFILES/bin
set PATH $PATH (yarn global bin)
set PATH $PATH ./node_modules/.bin

# FZF stuff
if type -q fzf
  set -gx FZF_TMUX 1
  set -gx FZF_FIND_FILE_COMMAND '__fzf_user_find'
  set -gx FZF_CD_COMMAND '__fzf_user_cd'
  set -gx FZF_CD_WITH_HIDDEN_COMMAND '__fzf_user_cd_hidden'
end

