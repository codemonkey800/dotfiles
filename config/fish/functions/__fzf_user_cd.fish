function __fzf_user_cd  -d 'Finds directories to potentially cd into.'
  find . -type 'd' -not \( \
    -path '.' \
    -o -path '*/.*' \
    -o -path '*/node_modules*' \
    -o -path '*/__pycache__*' \
  \) | sed 's|./||' | sort -fu
end
