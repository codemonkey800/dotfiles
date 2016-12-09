"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugins')

" Autocomplete
Plug 'amirh/html-autoclosetag'
Plug 'ervandew/supertab'
Plug 'othree/jspc.vim', { 'for': 'javascript' }
Plug 'raimondi/delimitmate'

" Deoplete
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
Plug 'SevereOverfl0w/deoplete-github', { 'for': 'gitcommit' }
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim', { 'for': 'vim' }
Plug 'Shougo/neoinclude.vim'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'carlitux/deoplete-ternjs', { 'for': 'javascript' }
Plug 'mhartington/deoplete-typescript', { 'for': 'typescript' }
Plug 'wellle/tmux-complete.vim'
Plug 'zchee/deoplete-go', { 'for': 'go' }
Plug 'zchee/deoplete-jedi', { 'for': 'python' }

" Linting
Plug 'benekastah/neomake'

" Movement/Text Manipulation
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'

" Prose
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'

" Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Syntaxes
Plug 'Firef0x/PKGBUILD.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'dag/vim-fish'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'lervag/vimtex'
Plug 'nginx.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/yajs.vim'
Plug 'plasticboy/vim-markdown'
Plug 'sheerun/vim-polyglot'

" User Interface
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'flazz/vim-colorschemes'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Utilitiy
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'Tagbar'
Plug 'airodactyl/neovim-ranger'
Plug 'ansiesc.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'cazador481/fakeclip.neovim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'direnv/direnv.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'gitignore'
Plug 'janko-m/vim-test'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'kassio/neoterm'
Plug 'mbbill/undotree'
Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

call plug#end()

