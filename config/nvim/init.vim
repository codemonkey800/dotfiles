call plug#begin('~/.config/nvim/plugins')

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

Plug 'airblade/vim-gitgutter'
Plug 'amirh/html-autoclosetag'
Plug 'ap/vim-css-color'
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dag/vim-fish'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'felixhummel/setcolors.vim'
Plug 'flazz/vim-colorschemes'
Plug 'gitignore'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf'
Plug 'justinmk/vim-dirvish'
Plug 'kassio/neoterm'
Plug 'majutsushi/tagbar'
Plug 'mips.vim'
Plug 'nginx.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'plasticboy/vim-markdown'
Plug 'raimondi/delimitmate'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'shime/vim-livedown'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-man'

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
colorscheme molokai

set ruler                      " Always show current positions along the bottom
set cmdheight=1                " Command bar is 1 unit high
set number                     " Show line numbers
set lazyredraw                 " Do not redraw while running macros
set report=0                   " Always report how many lines changed

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-json settings
let g:vim_json_syntax_conceal = 0

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Neomake settings
autocmd! BufWritePost * Neomake

" vim-markdown settings
let g:vim_markdown_math = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

" vim-lexical settings
augroup lexical
    autocmd!
    autocmd FileType markdown,mkd call lexical#init()
    autocmd FileType textile call lexical#init()
    autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

let g:lexical#thesaurus = ['~/.config/nvim/thesaurus.txt']
let g:lexical#dictionary = ['/usr/share/dict/american-english']

let g:lexical#spell_key = '<leader>s'
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'

" vim-pencil settings
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text call pencil#init()
augroup END

" Deoplete settings
let g:deoplete#enable_at_startup = 1

" vim-jsx settings
let g:jsx_ext_required = 0

" vim-editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

