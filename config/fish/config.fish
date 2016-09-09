source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/completions.fish

# Init stuff
if test -z $DISPLAY; and exists keychain
    if test $status -eq 0
        # Start keychain quietly
        eval (keychain --eval --agents ssh -Q --quiet --nogui $HOME/.ssh/id_rsa)
    end
end

