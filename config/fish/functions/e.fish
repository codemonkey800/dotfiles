function e -d 'Edit files with Neovim'
  set cmd 'nvim'

  for i in (seq (count $argv))
    # I rarely use the  -r flag for nvim, so it's perfect.
    if contains -- "$argv[$i]" '-r' '--remote'
      set cmd 'nvr --remote-silent'
      set -e argv[$i]
    end
  end

  eval "$cmd $argv"
end

