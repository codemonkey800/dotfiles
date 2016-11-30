function __mkexe_help
    echo '
    Usage: mkexe filename [command|exe_path]

    Arguments:
        filename - The filename of the new executable script
        command  - A command to run through "which"
        exe_path - An absolute or relative path to an executable
    '
end

function __mkexe_create_file
    touch $argv[1]
    chmod +x $argv[1]
end

function mkexe --description "Creates a script that is executable."
    set n (count $argv)
    if test $n -eq 0; or contains -- "$argv" h help -h --help
        __mkexe_help
        return 0
    end

    set file $argv[1]

    if test -f $file
        if set -l shebang (head -n 1 $file | grep '#!' ^ /dev/null)
            echo "'$file' already has the following shebang: '$shebang'"
            return -1
        end
    end

    touch $file
    chmod +x $file

    set shebang '/usr/bin/env fish'
    if test $n -ge 2
        set command $argv[2]
        if test -f $command
            if not string match './*' $command > /dev/null ^ /dev/null
                set command "./$command"
            end
            set shebang $command
        else
            if string match -r '\s' "$command"
                echo 'Command not have spaces in them!'
                return -1
            end
            if not which $command  > /dev/null ^ /dev/null
                echo "$command isn't in your PATH"
                return -1
            end
            set shebang "/usr/bin/env $command"
        end
    end

    echo -e "#!$shebang\n" | cat - $file | sponge $file
end


