"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base Keymap settings
"
" These are vim keymaps that are safe to source
" inside non-vim programs that provide vim bindings, like Intellij
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" Escape insert mode
inoremap jk <esc>

" Move vertically by visual line
noremap j gj
noremap k gk

" Swap capital H and L for begin and end of lines
noremap H ^
noremap L $

" Don't do anything yo
noremap $ <nop>
noremap ^ <nop>

nnoremap <silent> Q :q!<CR>
nnoremap <silent> q :q<CR>

" Turn off search highlight
nnoremap <silent> <leader><space> :nohlsearch<CR>

" Space open/closes folds
nnoremap <space> za

" Adds a new line below or above without entering insert mode
noremap o o<esc>k
noremap O O<esc>j

" Redo last thing
noremap <silent> U :redo<CR>

" Pipe to selected to shell
vnoremap <silent> <leader>r :!%:p<CR>

" Save current file
nnoremap <silent> <C-s> :w<CR>

" Sort things
noremap <silent> <leader>s :sort<CR>
noremap <silent> <leader>S :sort!<CR>

" Select all text
noremap <silent> <leader>a ggvG

" Go back from tag using Ctrl-[, which makes more sense than Ctrl-t
nnoremap gt <C-]>
nnoremap gT <C-t>
nnoremap <C-]> <nop>

" Maps window split navigation to arrow keys
nnoremap <silent> <Left>  :wincmd h<CR>
nnoremap <silent> <Down>  :wincmd j<CR>
nnoremap <silent> <Up>    :wincmd k<CR>
nnoremap <silent> <Right> :wincmd l<CR>

