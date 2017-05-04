# this file is part of the virtual script
# do not run directly except inside virtual environment

function deactivate
    set -e VIRTUAL_ENV
    if set -q OLD_PATH
        set PATH $OLD_PATH
        set -e OLD_PATH
    end
    functions -e deactivate destroy
end

function destroy
    deactivate
    set -l count (count (rm -rfv {venv_dir}))
    echo "Deleted $count files from virtual env!"
end

set -gx VIRTUAL_ENV $PWD/{venv_dir}
set -gx OLD_PATH $PATH
set PATH $PATH $PWD/{venv_dir}/bin

