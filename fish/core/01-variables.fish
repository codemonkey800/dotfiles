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
  $DOTFILES/bin \
  ./node_modules/.bin \
  ~/go/bin \
  ~/.local/bin \
  $PATH

# codex needs a dummy key when no real OpenAI key is set
if type -q codex; and not set -q OPENAI_API_KEY
  set -gx OPENAI_API_KEY dummy
end

# macOS specific vars
if test (uname) = 'Darwin'
  set JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
  set ANDROID_HOME /Users/jasuncion/Library/Android/sdk
  set PATH \
      $PATH \
      ~/Library/Python/*/bin \
      /opt/homebrew/bin \
      /opt/homebrew/opt/libpq/bin \
      ~/.claude/local
end
