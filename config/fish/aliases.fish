# Aliases
alias e "$EDITOR"
alias re "sudo -E $EDITOR"
alias g "git"
alias groot "cd (git rev-parse --show-toplevel)"
alias info "info --vi-keys"
alias sed "sed -r"
alias top "htop"

# Conditional Aliases
exists apm-beta; and alias apm "apm-beta"
exists atom-beta; and alias atom "atom-beta"
exists google-chrome-unstable; and alias chrome "google-chrome-unstable"
exists hub; and alias git "hub"; and alias g "hub"
exists netstat; and alias lsports "netstat -pelnut"
exists subl3; and alias subl "subl3"
exists pdflatex; and alias pdflatex "pdflatex -interaction=nonstopmode -shell-escape"

