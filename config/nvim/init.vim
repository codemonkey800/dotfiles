call plug#begin('~/.config/nvim/plugins')

Plug 'airblade/vim-gitgutter'
Plug 'benekastah/neomake'
Plug 'bling/vim-bufferline'
Plug 'bronson/vim-trailing-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'gitignore'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'kassio/neoterm'
Plug 'kien/ctrlp.vim'
Plug 'mhinz/vim-grepper'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'shime/vim-livedown'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-man'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

filetype indent plugin on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase smartcase       " Case insensitive search
set modeline                   " Allow Vim mode lines to change Vim settings
set hidden                     " Allow change to buffer without saving
set mouse=a                    " Sometimes a mouse is useful ;)
set noerrorbells               " Fuck bells
set novisualbell               " Fuck bells man
set t_Co=256                   " COLORS
set exrc                       " Scan working directory for .vimrc files
set secure                     " Do the above securely

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
colorscheme obsidian

set ruler                      " Always show current positions along the bottom
set cmdheight=1                " Command bar is 1 unit high
set number                     " Show line numbers
set lazyredraw                 " Do not redraw while running macros
set report=0                   " Always report how many lines changed

hi Normal ctermbg=None
hi NonText ctermbg=None

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Tab Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions=tcrqn        " autowrap and comments or something
set smartindent                " Smart indent or some shit
set cindent                    " C indent or some shit
set showmatch                  " Show matching brackets
set matchtime=5                " BLINK THE FUCKING BRACKETS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileencoding=utf-8        " Default for new files
set termencoding=utf-8        " Terminal encoding
set fileformats=unix,dos,mac  " Supports all three in this order
set fileformat=unix           " Default file format

set tabstop=4                 " 4 spaces
set softtabstop=4             " 4 spaces
set shiftwidth=4              " 4 spaces
set expandtab                 " Fuck tabs ;)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable                " Enable folding
set foldlevelstart=10         " Open most folds by default
set foldnestmax=10            " TOO MANY FOLDS D=<

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymap settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuck the other mapleader key lol
let mapleader = ","

" Escape insert mode
imap jk <esc>
tmap jk <C-\><C-n>

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

" Copy/Paste to X11 clipboard
vmap <leader>c "+y
nmap <leader>v "+p

" Adds a new line below or above without entering insert mode
noremap o o<esc>k
noremap O O<esc>j

" Sorts the line case insensitive
vmap <leader>s :%!sort -f<CR>
" Same but reverse
vmap <leader>S :%!sort -fr<CR>

" Maps window split navigation to saner shortcuts
nmap <Up>    :wincmd k<CR>
nmap <Down>  :wincmd j<CR>
nmap <Left>  :wincmd h<CR>
nmap <Right> :wincmd l<CR>

" Resizes windows using control and arrow key
nmap <S-Up>   :wincmd +<CR>
nmap <S-Down> :wincmd -<CR>
nmap <S-Left> :wincmd <<CR>
nmap <S-Right>:wincmd ><CR>

" Shortcuts for buffer related stuff
nmap <leader>m :bn<CR>
nmap <leader>n :bp<CR>
nmap <leader>w :bd!<CR>
nmap <leader>l :ls<CR>
nmap <leader>t :new<CR>
nmap <leader>E :vs<CR>
nmap <leader>O :sp<CR>

" Shortcuts to for tab related stuff
nmap <leader>M :tabn<CR>
nmap <leader>N :tabp<CR>
nmap <leader>W :tabc!<CR>
nmap <leader>L :tabs<CR>
nmap <leader>T :tabnew<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline settings
let g:airline#extensions#tabline#enabled = 1

" NERDTree settings
map <F1> :NERDTreeToggle<CR>

" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Neomake settings
autocmd! BufWritePost * Neomake

" vim-markdown settings
let g:vim_markdown_math = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

