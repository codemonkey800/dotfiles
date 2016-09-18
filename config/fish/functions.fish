# Functions
function fish_greeting
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n
    echo
end

function exists -d 'Silent wrapper over "which". Returns the status of the command'
    if test (count $argv) -gt 0
        which $argv[1] > /dev/null ^ /dev/null
    else
        echo 'You need to specify a command.'
        return -1
    end
end

function l -d "Lists all files in a directory or reads a file"
    if test (count $argv) -gt 0; and test -f $argv[-1]
        set -l i (contains -i -- -p $argv)
        set -l j (contains -i -- --pager $argv)
        if test \( -n $i \) -a \( $i -gt 0 \); or test \( -n $j \) -a \( $j -gt 0 \)
            less -N $argv[-1]
        else
            pygmentize $argv[-1]
        end
    else
        if test (uname) = "Darwin"
            ls -CAF $argv
        else
            ls -CAF --color=auto $argv
        end
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

# Aliases
alias e "$EDITOR"
alias g 'git'
alias groot 'cd (git rev-parse --show-toplevel)'

# Conditional Aliases
if exists apm-beta
    alias apm 'apm-beta'
end

if exists atom-beta
    alias atom 'atom-beta'
end

if exists google-chrome-unstable
    alias chrome 'google-chrome-unstable'
end

if exists hub
    alias git 'hub'
    alias g 'hub'
end

if exists netstat
    alias lsports 'netstat -pelnut'
end

if exists npm
    alias npmls 'npm ls --depth=0'
end

if exists subl3
    alias subl 'subl3'
end

if exists pdflatex
    alias pdflatex 'pdflatex -interaction=nonstopmode -shell-escape'
end

