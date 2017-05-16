function __fzf_user_find -d 'Finds files in the current directory'
  ag -l --hidden --ignore .git | sort -fu
end
