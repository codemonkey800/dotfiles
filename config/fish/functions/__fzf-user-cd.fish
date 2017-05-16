function __fzf_user_cd  -d 'Finds directories to potentially cd into'
  find . \
    -type d \
    -not \( \
      -path '\.' \
      -o -path '*/\.*' \
    \) \
  | sed 's|\./||' | sort -fu
end
