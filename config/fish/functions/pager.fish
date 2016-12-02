function pager --description 'Function that pipes data or the contents of a file to $PAGER'
    if test (count $argv) -eq 0; and status --is-interactive
        eval $PAGER
    else if test -n $argv[1] -a -f $argv[1]
        cat $argv[1] | eval $PAGER
    else
        echo 'You need to provide a file or pipe to the pager.'
        return -1
    end
end

