function __fzf_search_dir -d "cd's into selected directory."
  set dir (
    fd \
      --hidden \
      --follow \
      --color always \
      --type d \
      --exclude .git \
    | fzf \
      --reverse \
      --ansi \
      --preview='tree -a -L 1 {}'
  )

  if test $status -eq 0
    cd $dir
  end

  commandline --function repaint
end
