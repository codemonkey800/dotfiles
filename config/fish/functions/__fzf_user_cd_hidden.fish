function __fzf_user_cd_hidden -d 'Finds directories to potentially cd into, including hidden dirs.'
  find . -type 'd' -not \( \
    -path '.' \
    -o -path '*/.git*' \
    -o -path '*/.venv*' \
    -o -path '*/node_modules*' \
    -o -path '*/__pycache__*' \
  \) | sed 's|./||' | sort -fu
end

