set -gx __DOTFILES_ALIASES

function __alias
  set __DOTFILES_ALIASES $__DOTFILES_ALIASES "$argv"
  alias $argv
end

function ls-aliases
  for x in $__DOTFILES_ALIASES
    set -l parts (string split ' ' $x)
    set -l alias $parts[1]
    set -l command "$parts[2..-1]"

    echo "$alias: $command"
  end
end

__alias c 'copy'
__alias cat 'bat'
__alias copy 'rsync -aP --filter=":- .gitignore"'
__alias dc 'docker-compose'
__alias dotfiles 'cd $DOTFILES'
__alias e 'nvim'
__alias exists 'type -q'
__alias info 'info --vi-keys'
__alias ll 'l -l'
__alias lns 'ln -svf'
__alias move 'rsync -aP --remove-source-files'
__alias paths 'echo $PATH | tr " " \n'
__alias public-ip 'curl -q "http://ipinfo.io/ip"'
__alias r 'rm -rf'
__alias re 'eval sudo -E $EDITOR'
__alias rr 'sudo rm -rf'
__alias tf 'terraform'
__alias top 'htop'
__alias tree 'tree -aC'
__alias wh 'type -P'

switch (uname)
  case Linux
    __alias claude '/home/jeremy/.claude/local/claude'
    __alias cpu-temps 'watch -n 0.5 "sensors -f | grep Core"'
    __alias lsports 'netstat -pelnut ^ /dev/null'
    __alias pdflatex 'pdflatex -interaction=nonstopmode -shell-escape'
    __alias ya 'yay'
    __alias yag 'ya -G'
    __alias yaq 'ya -Q'
    __alias yar 'ya -Rscun'
    __alias yas 'ya -S'

    # Use systemd genie in WSL
    if string match -qr 'microsoft' (uname -a)
      __alias systemctl 'genie -c sudo systemctl'
    end
  case Darwin
    __alias chrome '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
    # Sudo required for macOS
    __alias top 'sudo htop'
end

functions -e __alias

