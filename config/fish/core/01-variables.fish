# development environment
set -gx EDITOR (type -p nvim)
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# GPG stuff
set -gx GPG_TTY (tty)

# pager stuff
set -gx PAGER less

# Use ligatures and stuff for bobthefish theme
set -g theme_nerd_fonts yes

# PATH stuff
set PATH \
  /opt/homebrew/bin \
  $DOTFILES/bin \
  ./node_modules/.bin \
  ~/bin \
  $PATH

# macOS specific vars
if test (uname) = 'Darwin'
  set PATH $PATH ~/Library/Python/*/bin
end
