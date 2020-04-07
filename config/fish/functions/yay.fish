function yay -d 'Wrapper over yay to use genie bottle if in WSL'
  if string match -qr 'microsoft' (uname -a)
    genie -c "yay $argv"
  else
    command yay $argv
  end
end
