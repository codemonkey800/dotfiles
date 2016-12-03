function l -d 'Lists all files in a directory or reads a file'
    set pager false
    set args
    set files

    for i in (seq (count $argv))
        set -l arg $argv[$i]
        switch $arg
            case -p --pager
                set pager true
            case '--*' '-*'
                set args $args $arg
            case '*'
                if test -e $arg
                    set files $files $arg
                end
        end
    end

    if test (count $files) -eq 1; and test -f $files[1]
        if eval $pager
            nvim -c 'runtime! macros/less.vim' $files[1]
        else
            pygmentize -g $files[1]
        end
    else
        set -l cmd 'ls -CAF'

        if test (uname) = 'Linux'
            set cmd "$cmd --color=auto"
        end

        set cmd "$cmd $args $files"

        if eval $pager
            set cmd "$cmd | $PAGER"
        end

        eval $cmd
    end
end

