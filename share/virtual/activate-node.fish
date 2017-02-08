#!/usr/bin/env fish

function deactivate
    set -e VIRTUAL_ENV
    if set -q OLD_PATH
        set -gx PATH $OLD_PATH
        set -e OLD_PATH
    end
    functions -e deactivate yarn
end

set -gx VIRTUAL_ENV '{{ venv }}'
set -gx OLD_PATH $PATH

if type -q yarn
    alias yarn 'env HOME={{ venv }} yarn'
end

set -gx PATH $PATH (yarn bin) > /dev/null ^ /dev/null
