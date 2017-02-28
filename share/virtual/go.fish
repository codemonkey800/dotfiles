# this file is part of the virtual script
# do not run directly except inside virtual environment

function deactivate
    set -e VIRTUAL_ENV
    set -e GOPATH
    set -e GOROOT
    if set -q OLD_PATH
        set -gx PATH $OLD_PATH
        set -e OLD_PATH
    end
    functions -e deactivate gopath
end

function gopath
    if not set -q argv[1]
        if set -q GOPATH
            cd $GOPATH
        end
    else
        if set -q GOPATH; and set -l i (contains -i $GOPATH/bin $PATH)
            set -e PATH[$i]
        end
        set -gx GOPATH $argv[1]
        set -gx PATH $PATH $GOPATH/bin > /dev/null ^ /dev/null
    end
end

set -gx VIRTUAL_ENV $PWD/{venv_dir}
set -gx GOROOT $PWD/{venv_dir}
set -gx OLD_PATH $PATH
set -gx PATH $PATH $GOROOT/bin

echo 'Use the gopath function to cd to or set GOPATH'

