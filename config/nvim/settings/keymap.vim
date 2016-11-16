"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base Keymap settings
"
" These are vim keymaps that are safe to source
" inside non-vim programs that provide vim bindings, like Intellij
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuck the other mapleader key lol
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

" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Space open/closes folds
nnoremap <space> za

" Copy/Paste to host keyboard
vnoremap <leader>c "+y<CR>
nnoremap <leader>v "+p<CR>

" Adds a new line below or above without entering insert mode
noremap o o<esc>k
noremap O O<esc>j

" Redo last thing
noremap U :redo<CR>

" Pipe to selected to shell
noremap <leader>r :!%:p<CR>

" Sort things
noremap <leader>s :!sort<CR>
noremap <leader>S :!sort -r<CR>

" Select all text
noremap <leader>a ggvG

" Maps window split navigation to saner shortcuts
nnoremap <Up>    :wincmd k<CR>
nnoremap <Down>  :wincmd j<CR>
nnoremap <Left>  :wincmd h<CR>
nnoremap <Right> :wincmd l<CR>

" Resizes windows using control and arrow key
nnoremap <S-Up>    :wincmd +<CR>
nnoremap <S-Down>  :wincmd -<CR>
nnoremap <S-Left>  :wincmd <<CR>
nnoremap <S-Right> :wincmd ><CR>

