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

nnoremap ~ :terminal<CR>
tnoremap <C-q> <C-\><C-n>

" Shortcuts for buffer related stuff
nnoremap <leader>m :bn<CR>
nnoremap <leader>n :bp<CR>
nnoremap <leader>w :bd!<CR>
nnoremap <leader>l :ls<CR>
nnoremap <leader>t :new<CR>

" Shortcuts to for tab related stuff
nnoremap <leader>M :tabn<CR>
nnoremap <leader>N :tabp<CR>
nnoremap <leader>W :tabc<CR>
nnoremap <leader>L :tabs<CR>
nnoremap <leader>T :tabnew<CR>

" fakeclip keymaps
vnoremap <leader>c "+y<CR>
nnoremap <leader>v "*p<CR>

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign in normal mode
nmap ga <Plug>(EasyAlign)

