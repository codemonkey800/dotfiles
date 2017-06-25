# Alias completions
complete -c e -w nvim
complete -c exists -w which
complete -c g -w git
complete -c hub -w git
complete -c lc -w ls
complete -c ll -w ls
complete -c mkcd -w mkdir
complete -c r -w rm
complete -c re -w nvim

# Function completions
complete -c l -l pager -d 'Pipes output into $PAGER'

complete -c node-deps -l development -d 'Lists only development dependencies'
complete -c node-deps -l production -d 'Lists only production dependencies'
complete -c node-deps -s d -d 'Lists only development dependencies'
complete -c node-deps -s p -d 'Lists only production dependencies'

# Script completions
complete -c gpu -l help -d 'Prints help message'
complete -c gpu -l off -d 'Turns off discrete gpu'
complete -c gpu -l on -d 'Turns on discrete gpu'

