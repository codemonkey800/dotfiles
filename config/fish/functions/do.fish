function do -d 'Wrapper for docker command.'
  if type -q "__do_$argv[1]"
    set -l command "$argv[1]"
    set -e argv[1]
    eval "__do_$command $argv"
  else
    docker $argv
  end
end

