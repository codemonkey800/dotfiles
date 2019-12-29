alias copy 'rsync -aP'
alias dc 'docker-compose'
alias exists 'type -q'
alias info 'info --vi-keys'
alias ll 'l -l'
alias lns 'ln -svf'
alias lsof-del 'lsof +c 0
  | grep -w DEL
  | pawk \'"{}: {}".format(f[0], f[-1:])\'
  | sort -u
'
alias move 'rsync -aP --remove-source-files'
alias paths 'echo $PATH | tr " " \n'
alias pdflatex 'pdflatex -interaction=nonstopmode -shell-escape'
alias public-ip 'curl -q "http://ipinfo.io/ip"'
alias r 'rm -rf'
alias re 'eval sudo -E $EDITOR'
alias rr 'sudo rm -rf'
alias top 'htop'
alias tree 'tree -aC'
alias wh 'type -P'

switch (uname)
case Linux
  alias cpu-temps 'watch -n 0.5 "sensors -f | grep Core"'
  alias lsports 'netstat -pelnut ^ /dev/null'
  alias ya 'yay'
  alias yag 'ya -G'
  alias yaq 'ya -Q'
  alias yar 'ya -Rscun'
  alias yas 'ya -S'
case Darwin
  alias chrome '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  alias code '/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
  alias code-insiders '/Applications/Visual\ Studio\ Code\ -\ Insiders.app/Contents/Resources/app/bin/code'
  alias git '/usr/local/bin/git'
  # Sudo required for macOS
  alias top 'sudo htop'
end

