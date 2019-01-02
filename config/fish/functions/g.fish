function g -w git -d 'Git wrapper with added sugar on top.'
  # If on Linux, just use normal git command and git config.
  if test (uname) = 'Linux'
    git $argv
    return
  end

  # Assume from here we're on macOS.
  set git '/usr/local/bin/git'

  # Switch to macOS gpg2
  $git config --global 'gpg.program' '/usr/local/MacGPG2/bin/gpg2'

  # Dynamically switch between Sumo Logic email and personal email.
  if string match -qr '.*projects/sumo.*' $PWD
    $git config --global 'user.email' 'jasuncion@sumologic.com'
  else
    $git config --global 'user.email' 'jeremyasuncion808@gmail.com'
  end

  $git $argv
end

