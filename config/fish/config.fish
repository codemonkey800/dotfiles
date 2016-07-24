source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish

# Init stuff
if test -z $DISPLAY
    # Start keychain
    keychain $HOME/.ssh/id_rsa
end

