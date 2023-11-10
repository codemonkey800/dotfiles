function g -d 'Wrapper over git' -w git
  set git '/bin/git'
  set email 'jeremyasuncion808@gmail.com'
  set extra_args

  if test (uname) = 'Darwin'
    set git '/opt/homebrew/bin/git'
  end

  if string match "$HOME/dev/me/*" $PWD > /dev/null
    set email 'jeremy@magiceden.io'
  end

  if test ($git config --global user.email) != "$email"
    $git config --global user.email $email
  end

  if test $argv[1] = 'c'
    set extra_args '--no-verify'
  end

  $git $argv $extra_args
end
