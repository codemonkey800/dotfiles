function g -w git -d 'Git wrapper with added sugar on top.'
  # If on Linux, just use normal git command and git config.
  if test (uname) = 'Linux'
    git $argv
    return
  end

  # Assume from here we're on macOS.
  alias __g_git '/usr/local/bin/git'

  # Switch to macOS gpg2
  __g_git config --global 'gpg.program' '/usr/local/MacGPG2/bin/gpg2'

  # Dynamically switch between Sumo Logic email and personal email.
  if string match -qr '.*projects/sumo.*' $PWD
    __g_git config --global 'user.email' 'jasuncion@sumologic.com'
  else
    __g_git config --global 'user.email' 'jeremyasuncion808@gmail.com'
  end

  __g_git $argv
  clear-functions __g
end

