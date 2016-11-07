# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
    echo "==> Fisherman not found. Installing."
    curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
    fisher
end

source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/completions.fish

# Keychain stuff
if test (hostname) = "jeremy-dev-server"
    # Start keychain quietly
    eval (keychain --eval --agents ssh -Q --quiet --nogui ~/.ssh/{aur,vcs})
end

