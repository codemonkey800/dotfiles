source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish

# Init stuff
if test -z $DISPLAY
    # Start keychain quietly
    keychain -q $HOME/.ssh/id_rsa
end

