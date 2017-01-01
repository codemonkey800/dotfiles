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
                set files $files $arg
        end
    end

    if test (count $files) -eq 1; and test -f $files[1]
        if test -f $files[1]
            if eval $pager
                nvim -c 'runtime! macros/less.vim' $files[1]
            else
                pygmentize -g $files[1]
            end
        else
            echo "'$files[1]' doest not exist!"
            return -1
        end
    else
        for file in $files
            if not test -e $file
                echo "'$file' does not exist!"
                return -1
            end
        end

        set -l args "$args -CAF"

        if test (uname) = 'Linux'
            set args "$args --color=always"
        end

        set args "$args $files"

        if eval $pager
            eval "ls $args | $PAGER"
        else
            eval "ls $args"
        end
    end
end

