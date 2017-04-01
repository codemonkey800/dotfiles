# Aliases
alias dotfiles "fish -c '
    cd $DOTFILES;
    echo Control-D to go back.;
    exec fish
'"
alias e "$EDITOR"
alias exists 'type -q'
alias g 'git'
alias gr 'cd (git rev-parse --show-toplevel)'
alias info 'info --vi-keys'
alias lns 'ln -svf'
alias lsof-del 'lsof +c 0
    | grep -w DEL
    | pawk \'"{}: {}".format(f[0], f[-1:])\'
    | sort -u
'
alias nm-restart 'sudo systemctl restart NetworkManager'
alias paths 'echo $PATH | tr " " \n'
alias re "sudo -E $EDITOR"
alias r 'rm -rf'
alias rr 'sudo rm -rf'
alias wh 'type -P'

# Conditional Aliases

# Convenience function for conditionally
# setting aliases.
# Usage: __aliasif <alias> <command>
function __aliasif
    if exists (echo $argv[2] | pawk f[0])
        alias $argv[1] $argv[2]
    end
end

__aliasif apm 'apm-beta'
__aliasif atom 'atom-beta'
__aliasif chrome 'google-chrome-unstable'
__aliasif code 'code-insiders'
__aliasif copy 'rsync -aP'
__aliasif g 'hub'
__aliasif git "hub"
__aliasif lsports 'netstat -pelnut ^ /dev/null'
__aliasif npmls 'npm ls --depth=0'
__aliasif pdflatex 'pdflatex -interaction=nonstopmode -shell-escape'
__aliasif subl 'subl3'
__aliasif top 'htop'
__aliasif tree 'tree -faC'

functions -e __aliasif

