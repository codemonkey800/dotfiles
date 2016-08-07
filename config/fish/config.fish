source ~/.config/fish/variables.fish
source ~/.config/fish/functions.fish

# Init stuff
which keychain > /dev/null ^ /dev/null
if test -z $DISPLAY
    if test $status -ne 0
        # Start keychain quietly
        eval (keychain --eval --agents ssh -Q --quiet --nogui $HOME/.ssh/id_rsa)
    end
end

