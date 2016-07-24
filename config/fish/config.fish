source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish

# Init stuff
if test -z $DISPLAY
    # Start keychain quietly
    eval (keychain --eval --agents ssh -Q --quiet --nogui $HOME/.ssh/id_rsa)
end

