# Aliases
alias dotfiles "fish -c 'cd $DOTFILES; and echo \\'Control-D to go back.\\'; and exec fish'"
alias e "$EDITOR"
alias exists 'type -q'
alias g 'git'
alias gr 'cd (git rev-parse --show-toplevel)'
alias info 'info --vi-keys'
alias lsof-del 'lsof +c 0 | grep -w DEL | pawk \'"{}: {}".format(f[0], f[-1:])\' | sort -u'
alias re "sudo -E $EDITOR"
alias wh 'type -p'

# Conditional Aliases
exists apm-beta; and alias apm 'apm-beta'
exists atom-beta; and alias atom 'atom-beta'
exists google-chrome-unstable; and alias chrome 'google-chrome-unstable'
exists htop; and alias top 'htop'
exists hub; and alias git "hub"; and alias g 'hub'
exists netstat; and alias lsports 'netstat -pelnut'
exists npm; and alias npmls 'npm ls --depth=0'
exists pdflatex; and alias pdflatex 'pdflatex -interaction=nonstopmode -shell-escape'
exists subl3; and alias subl 'subl3'

