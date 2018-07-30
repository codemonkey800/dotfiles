function g -d 'Git wrapper with added sugar on top.'
  set git '/usr/bin/git'
  set is_macos false

  if test (uname) = 'Darwin'
    set git '/usr/local/bin/git'
    set is_macos true
    eval "$git config --global gpg.program /usr/local/MacGPG2/bin/gpg2"
  else
    eval "$git config --global gpg.program /usr/bin/gpg2"
  end

  if string match -qr '.*projects/sumo.*' $PWD
    eval "$git config --global user.email jasuncion@sumologic.com"
  else
    eval "$git config --global user.email jeremyasuncion808@gmail.com"
  end

  if eval $is_macos
    /usr/local/bin/git $argv
  else
    /usr/bin/git $argv
  end
end

