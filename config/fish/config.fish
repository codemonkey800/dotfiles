# Automatically download and setup fisher if it's not installed
# Code shamelessly copied from: https://github.com/fisherman/fisherman/wiki/Bootstrap
if not test -f ~/.config/fish/functions/fisher.fish
    echo "==> Fisherman not found. Installing."
    curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
    fisher
end

if functions -q bass; and test -f /etc/profile
    bass source /etc/profile
end

# Dotfiles path
set -gx DOTFILES (
    set dir (status -f)
    if test -L $dir
        set dir (readlink $dir)
    end
    readlink -f (dirname $dir)/../..
)

source $DOTFILES/config/fish/variables.fish
source $DOTFILES/config/fish/aliases.fish
source $DOTFILES/config/fish/completions.fish

eval (direnv hook fish)

if status -i
    if exists keychain
        # Start keychain for when the $DISPLAY variable isn't defined and fish is interactive
        if test -z $DISPLAY
            set -l keys
            for f in ~/.ssh/*.pub
                set keys $keys ~/.ssh/(basename $f .pub)
            end

            if test (count $keys) -gt 0
                keychain --eval --agents ssh --quick --quiet --nogui $keys | source
            end
        else if test (count (keychain -l)) -gt 0
            # Have keychain kill all ssh-agent's if any are running and $DISPLAY is defined
            keychain --quiet -k all
        end
    end

    if exists tmux; and test -z $TMUX
        if tmux ls | grep main ^&1 /dev/null
            exec tmux a -t (whoami)/main
        else
            exec tmux new -s (whoami)/main
        end
    end
end


