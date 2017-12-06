function tmpd -d 'Switches to or prints (in command substitution) the temporary home directory.'
  if status -c
    echo ~/var/tmp
    return
  end
  cd ~/var/tmp
end

