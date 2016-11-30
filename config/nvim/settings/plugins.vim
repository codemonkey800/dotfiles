"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugins')

" Autocomplete
Plug 'amirh/html-autoclosetag'
Plug 'ervandew/supertab'
Plug 'raimondi/delimitmate'
Plug 'Shougo/echodoc.vim'

" Deoplete
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
Plug 'SevereOverfl0w/deoplete-github'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim', { 'for': 'vim' }
Plug 'Shougo/neoinclude.vim', { 'commit': 'bde1512' }
Plug 'steelsojka/deoplete-flow', { 'for': 'javascript' }
Plug 'wellle/tmux-complete.vim'
Plug 'zchee/deoplete-go', { 'for': 'go' }
Plug 'zchee/deoplete-jedi', { 'for': 'python' }

" Linting
Plug 'benekastah/neomake'

" Movement/Text Manipulation
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'

" Prose
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Syntaxes
Plug 'dag/vim-fish'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'Firef0x/PKGBUILD.vim'
Plug 'flowtype/vim-flow'
Plug 'lervag/vimtex'
Plug 'nginx.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'

" User Interface
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'c0r73x/neotags.nvim'
Plug 'felixhummel/setcolors.vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Utilitiy
Plug 'airodactyl/neovim-ranger'
Plug 'ansiesc.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'cazador481/fakeclip.neovim'
Plug 'editorconfig/editorconfig-vim'
Plug 'fszymanski/fzf-gitignore.nvim'
Plug 'gitignore'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf'
Plug 'kassio/neoterm'
Plug 'Tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

call plug#end()
