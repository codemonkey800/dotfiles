# this file is part of the virtual script
# do not run directly except inside virtual environment

function add-node-module
    set -l dir (yarn bin)
    if test -d $dir
        set -gx PATH $PATH $dir
    else
        echo "Nothing added for $PWD"
    end
end

function deactivate
    set -e VIRTUAL_ENV
    if set -q OLD_PATH
        set -gx PATH $OLD_PATH
        set -e OLD_PATH
    end
    functions -e deactivate add-node-module
end

set -gx VIRTUAL_ENV $PWD/{venv_dir}
set -gx OLD_PATH $PATH
set -gx PATH $PATH $PWD/{venv_dir}/bin

add-node-module

