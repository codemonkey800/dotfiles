# Aliases
alias chrome 'google-chrome-unstable'
alias e "$EDITOR"
alias git 'hub'
alias git-root 'cd (git rev-parse --show-toplevel)'
alias lsports 'netstat -pelnut'
alias subl 'subl3'

# Functions
function fish_greeting
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n
    echo
end

function l -d "Lists all files in a directory or reads a file"
    if test -f "$argv"
        less -N "$argv"
    else
        ls -CAF --color=auto $argv
    end
end

function ll -d "Lists all files in a directory and prints their permissions and shit"
    l -l $argv
end

function lc -d "Lists all files in a directory in a column"
    ll $argv | tail -n +2 | awk '{print $9}'
end

function mkcd
    if test ! -d "$argv"
        mkdir -p "$argv"
    end
    cd "$argv"
end

function my-public-ip -d "Gets the public ip using an external service"
    wget http://ipinfo.io/ip -qO-
end

function r -d "An alias for rm -rf"
    rm -rf $argv
end

function tree -d "Runs the tree command with color enabled and pipes it to less for paging"
   eval  (which tree) -C $argv | less
end

