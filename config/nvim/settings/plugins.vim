call plug#begin('~/.config/nvim/plugins')

" Autocomplete
Plug 'amirh/html-autoclosetag'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'raimondi/delimitmate'
Plug 'Shougo/echodoc.vim'
Plug 'SirVer/ultisnips'

" Deoplete
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
Plug 'SevereOverfl0w/deoplete-github'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-vim', { 'for': 'vim' }
Plug 'Shougo/neoinclude.vim'
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

" Syntaxes
Plug 'dag/vim-fish'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'Firef0x/PKGBUILD.vim'
Plug 'flowtype/vim-flow'
Plug 'gitignore'
Plug 'lervag/vimtex'
Plug 'nginx.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'plasticboy/vim-markdown'

" Tooling
Plug 'editorconfig/editorconfig-vim'
Plug 'janko-m/vim-test'
Plug 'kassio/neoterm'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-utils/vim-man'

" User Interface
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'felixhummel/setcolors.vim'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Utilitiy
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/fzf'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'

call plug#end()
