# Alias completions
complete -c exists -w which
complete -c ll -w ls
complete -c lc -w ls
complete -c mkcd -w mkdir
complete -c r -w rm
complete -c e -w $EDITOR
complete -c hub -w git
complete -c g -w git

# Function completions
complete -c l -w ls
complete -c l -l pager -d 'Pipes output into $PAGER'

# Script completions
complete -c copy -w rsync

complete -c gpu -l on -d 'Turns on discrete gpu'
complete -c gpu -l off -d 'Turns off discrete gpu'
complete -c gpu -l help -d 'Prints help message'

