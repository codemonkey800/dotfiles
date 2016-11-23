function l -d 'Lists all files in a directory or reads a file'
    if test (count $argv) -gt 0; and test -f $argv[-1]
        set -l i (contains -i -- -p $argv)
        set -l j (contains -i -- --pager $argv)
        if test \( -n $i \) -a \( $i -gt 0 \); or test \( -n $j \) -a \( $j -gt 0 \)
            less -N $argv[-1]
        else
            pygmentize -g $argv[-1]
        end
    else
        if test (uname) = 'Darwin'
            ls -CAF $argv
        else
            ls -CAF --color=auto $argv
        end
    end
end

