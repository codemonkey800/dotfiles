function e -d 'Edits a file with the current supported active editor, or $EDITOR'
  if pgrep -x 'atom' > /dev/null ^&1
    atom $argv
  else
    eval "$EDITOR $argv"
  end
end

