"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymap Extended Settings
"
" This file extends the base keymap settings and adds vim/nvim specific
" keybindings or keybindings for plugins.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source ~/.config/nvim/settings/keymap.vim

" Open nvim config for editing
nnoremap <leader>ev :edit $MYVIMRC<CR>

" Source nvim config
nnoremap <leader>sv :source $MYVIMRC<CR>

" Ctrl-p like functionality with FZF
nnoremap <C-p> :FZF<CR>
" Open current directory with file manager
nnoremap <leader>f :edit .<CR>

" Runs make
nnoremap <leader>b :!make<CR>
" Runs make clean
nnoremap <leader>B :!make clean<CR>

" Since shell is defined to /bin/bash for POSIX
" compatibility, we use the $SHELL environment variable
" to launch a terminal with the user's shell
nnoremap ~ :terminal bash -c 'exec $SHELL'<CR>
tnoremap <C-q> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>

" Shortcuts for buffer related stuff
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bD :bd!<CR>
nnoremap <leader>bl :ls<CR>
nnoremap <leader>bN :new<CR>

" fakeclip keymaps
vnoremap <leader>c "+y<CR>
nnoremap <leader>v "*p<CR>

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign in normal mode
nmap ga <Plug>(EasyAlign)

