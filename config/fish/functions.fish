# Functions
function fish_greeting
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n | lolcat
    echo
end

function exists -d "Silent wrapper over "which". Returns the status of the command"
    if test (count $argv) -gt 0
        which $argv[1] > /dev/null ^ /dev/null
    else
        echo "You need to specify a command."
        return -1
    end
end

function gi -d "Simple commandline client for accessing the gitignore.io api"
    function _request
        curl -L -s "https://www.gitignore.io/api/$argv"
    end

    switch "$argv"
        case "list"
            _request list | sed 's/,/\n/g' | sort
        case "*"
            _request $argv
    end
end

function l -d "Lists all files in a directory or reads a file"
    if test (count $argv) -gt 0; and test -f $argv[-1]
        set -l i (contains -i -- -p $argv)
        set -l j (contains -i -- --pager $argv)
        if test \( -n $i \) -a \( $i -gt 0 \); or test \( -n $j \) -a \( $j -gt 0 \)
            less -N $argv[-1]
        else
            pygmentize -g $argv[-1]
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
    ll $argv | tail -n +2 | pawk f[8:]
end

function mkcd
    if test ! -d "$argv"
        mkdir -p "$argv"
    end
    cd "$argv"
end

function public-ip -d "Gets the public ip using an external service"
    curl -q "http://ipinfo.io/ip"
end

function r -d "An alias for rm -rf"
    rm -rf $argv
end

if exists tree
    function tree -d "Runs the tree command with color enabled and pipes it to less for paging"
       eval  (which tree) -C $argv | less
    end
end

