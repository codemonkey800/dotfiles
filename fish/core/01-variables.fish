# development environment
set -x EDITOR (type -p nvim)
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# GPG stuff
set -x GPG_TTY (tty)

# pager stuff
set -x PAGER less

# Use ligatures and stuff for bobthefish theme
set -g theme_nerd_fonts yes

# PATH stuff
set PATH \
  /opt/homebrew/bin \
  $DOTFILES/bin \
  ./node_modules/.bin \
  $PATH

# macOS specific vars
if test (uname) = 'Darwin'
  set PATH $PATH ~/Library/Python/*/bin
end
