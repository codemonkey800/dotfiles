# Aliases
alias e "$EDITOR"
alias re "sudo -E $EDITOR"
alias g "git"
alias groot "cd (git rev-parse --show-toplevel)"
alias info "info --vi-keys"
alias sed "sed -r"
alias top "htop"

# Conditional Aliases
if exists apm-beta
    alias apm "apm-beta"
end

if exists atom-beta
    alias atom "atom-beta"
end

if exists google-chrome-unstable
    alias chrome "google-chrome-unstable"
end

if exists hub
    alias git "hub"
    alias g "hub"
end

if exists netstat
    alias lsports "netstat -pelnut"
end

if exists subl3
    alias subl "subl3"
end

if exists pdflatex
    alias pdflatex "pdflatex -interaction=nonstopmode -shell-escape"
end
