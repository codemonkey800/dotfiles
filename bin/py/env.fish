set venv $DOTFILES/.venv
set activate_script $venv/bin/activate.fish

if test ! -f $activate_script
  echo 'Environment not available. Creating one.'
  python3 -m venv $venv
  source $activate_script
  pip install -r $DOTFILES/requirements.txt
end

source $activate_script

