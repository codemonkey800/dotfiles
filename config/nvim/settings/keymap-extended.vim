" This file extends the base keymap settings and adds vim or nvim specific
" keybindings.

source ~/.config/nvim/settings/keymap.vim

" Escape nvim terminal
tnoremap jk <C-\><C-n>

" Runs make
noremap <leader>b :!make<CR>
" Runs make clean
noremap <leader>B :!make clean<CR>

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

" Ctrl-p like functionality with FZF
nnoremap <C-p> :FZF<CR>

" Color settings thing
nnoremap <F9> :call NextColor(1)<CR>
nnoremap <S-F9> :call NextColor(-1)<CR>
nnoremap <A-F9> :call NextColor(0)<CR>

" Show NERDTree on F1
noremap <F1> :NERDTreeToggle<CR>

