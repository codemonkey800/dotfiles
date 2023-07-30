function IncludeSource(file)
  execute 'source '
    \ . $DOTFILES
    \ . '/nvim/config/'
    \ . a:file
    \ . '.vim'
endfunction

call IncludeSource('plugins')
call IncludeSource('settings')
call IncludeSource('keymap')

