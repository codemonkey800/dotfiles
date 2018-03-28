function __fzf_user_find -d 'Finds files in the current directory.'
  find . -not \( \
    -path '.' \
    -o -path '*/.git*' \
    -o -path '*/.venv*' \
    -o -path '*/node_modules*' \
    -o -path '*/__pycache__*' \
  \) | sed 's|./||' | sort -fu
end
