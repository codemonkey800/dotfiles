function do -w docker -d 'Wrapper for docker command.'
  set command "$argv[1]"

  if type -q "__do_$command"
    echo eval "__do_$command $argv[2..-1]"
  else
    echo docker $argv
  end
end

