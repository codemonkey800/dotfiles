# Alias completions
complete --command e --wraps nvim
complete --command exists --wraps which
complete --command g --wraps git
complete --command hub --wraps git
complete --command lc --wraps ls
complete --command ll --wraps ls
complete --command mkcd --wraps mkdir
complete --command r --wraps rm
complete --command re --wraps nvim

# Function completions
complete --command l --wraps ls
complete --command l --long-option pager --description 'Pipes output into $PAGER'

# Script completions
complete --command copy --wraps rsync

complete --command gpu --long-option on --description 'Turns on discrete gpu'
complete --command gpu --long-option off --description 'Turns off discrete gpu'
complete --command gpu --long-option help --description 'Prints help message'
complete --command update \
         --no-files \
         --short-option l --long-option list \
         --description 'List available updates.'
# complete --command update \
#          --exclusive \
#          --short-option p --long-option package-manager \
#          --arguments (update --list-package-managers) \
#          --description 'Updates packages for a specific manager.'
complete --command update \
         --no-files \
         --long-option list-package-managers \
         --description 'Lists all available package managers.'

