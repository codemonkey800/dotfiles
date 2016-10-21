# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f $HOME/.config/fish/functions/fisher.fish
    echo "==> Fisherman not found. Installing."
    curl -sLo $HOME/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
    fisher
end

source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/completions.fish

# Init stuff
if test (hostname) = "jeremy-dev-server"
    if test $status -eq 0
        # Start keychain quietly
        eval (keychain --eval --agents ssh -Q --quiet --nogui $HOME/.ssh/id_rsa)
    end
end

