"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymap settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuck the other mapleader key lol
let mapleader = ","

" Escape insert mode
inoremap jk <esc>
tnoremap jk <C-\><C-n>

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

" Copy/Paste to X11 clipboard using xsel
vnoremap <leader>c "+y<CR>
noremap <leader>v "+p<CR>

" Adds a new line below or above without entering insert mode
noremap o o<esc>k
noremap O O<esc>j

" Redo last thing
noremap U :redo<CR>

" Runs make
noremap <leader>b :!make<CR>
" Runs make clean
noremap <leader>B :!make clean<CR>

" Pipe to selected to shell
vnoremap <leader>r :!eval $SHELL<CR>

noremap <leader>a ggvG

" Maps window split navigation to saner shortcuts
" nnoremap <Up>    :wincmd k<CR>
" nnoremap <Down>  :wincmd j<CR>
" nnoremap <Left>  :wincmd h<CR>
" nnoremap <Right> :wincmd l<CR>

nnoremap <Up>    :wincmd k<CR>
nnoremap <Down>  :wincmd j<CR>
nnoremap <Left>  :wincmd h<CR>
nnoremap <Right> :wincmd l<CR>

" Resizes windows using control and arrow key
nnoremap <S-Up>    :wincmd +<CR>
nnoremap <S-Down>  :wincmd -<CR>
nnoremap <S-Left>  :wincmd <<CR>
nnoremap <S-Right> :wincmd ><CR>

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

nnoremap <C-p> :FZF<CR>
nnoremap <F8> :TagbarToggle<CR>

nnoremap <F9> :call NextColor(1)<CR>
nnoremap <S-F9> :call NextColor(-1)<CR>
nnoremap <A-F9> :call NextColor(0)<CR>
