function IncludeSource(file)
  execute 'source '
    \ . $DOTFILES
    \ . '/config/nvim/config/'
    \ . a:file
    \ . '.vim'
endfunction

call IncludeSource('plugins')
call IncludeSource('settings')
call IncludeSource('keymap')

