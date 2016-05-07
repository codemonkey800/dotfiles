# Aliases
alias e "$EDITOR"
alias git-root 'cd git rev-parse --show-toplevel'

# Conditional Aliases
if test -f (which 'apm-beta' ^ /dev/null)
    alias apm 'apm-beta'
end

if test -f (which 'atom-beta') ^ /dev/null)
    alias atom 'atom-beta'
end

if test -f (which 'google-chrome-unstable') ^ /dev/null)
    alias chrome 'google-chrome-unstable'
end

if test -f (which 'hub') ^ /dev/null)
    alias git 'hub'
end

if test -f (which 'netstat') ^ /dev/null)
    alias lsports 'netstat -pelnut'
end

if test -f (which 'npm') ^ /dev/null)
    alias npmls 'npm ls --depth=0'
end

if test -f (which 'subl3') ^ /dev/null)
    alias subl 'subl3'
end

# Functions
function fish_greeting
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n
    echo
end

if functions -q gitignore
    function mkgitignore -d "Wrapper over gitignore function in gitignore fisher plugin"
        mkdir -p ~/.cache/
        gitignore $argv
    end
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

