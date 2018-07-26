set venv $DOTFILES/.venv
set activate_file $venv/bin/activate.fish

if not test -f $activate_file
  echo 'Environment not available. Creating one.'
  python3 -m venv $venv
  source $activate_file
  pip install -r $DOTFILES/requirements.txt
  clear
end

if not set -q VIRTUAL_ENV
  source $activate_file
end

