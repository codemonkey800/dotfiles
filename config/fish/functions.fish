# Aliases
alias apm 'apm-beta'
alias atom 'atom-beta'
alias chrome 'google-chrome-unstable'
alias e "$EDITOR"
alias lsports 'netstat -pelnut'
alias git 'hub'

# Functions
function fish_greeting
    fortune 50% myfortunes 30% off 20% ascii-art | cowsay -n
    echo
end

function l
    if test -f "$argv"
        less -n "$argv"
        # pygmentize -g "$argv" | cat -n
	else
		ls -CAF --color=auto $argv
	end
end

function ll
    l -l $argv
end

function lc
    ll $argv | tail -n +2 | awk '{print $9}'
end

function mkcd
	if test ! -d "$argv"
		mkdir -p "$argv"
	end
	cd "$argv"
end

function myip
	if test "$argv" = "--public"
		wget http://ipinfo.io/ip -qO -
	else if test "$argv" = "--help"
		echo "myip [--public|--help]"
		echo "myip     - Prints the internal IP address"
		echo "--public - Prints the public IP of the access point"
		echo "--help   - Prints this message"
	else
		# Thank you!: http://www.if-not-true-then-false.com/2010/linux-get-ip-address/
		ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tail -n 1
	end
end

function r
	rm -rf $argv
end

function reboot-required
    if test -f "/run/reboot-required"
        echo "Reboot required!"
    else
        echo "You don't have to reboot!"
    end
end

function tree
   eval  (which tree) -C $argv | less
end


