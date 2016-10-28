call plug#begin('~/.config/nvim/plugins')

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" Autocomplete
Plug 'amirh/html-autoclosetag'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'carlitux/deoplete-ternjs'
Plug 'ervandew/supertab'
Plug 'raimondi/delimitmate'
Plug 'Rip-Rip/clang_complete'
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'Shougo/neco-vim'
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'zchee/deoplete-jedi'

" Linting
Plug 'benekastah/neomake'

" Movement/Text Manipulation
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
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
Plug 'shime/vim-livedown'
Plug 'tpope/vim-fugitive'

" User Interface
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'felixhummel/setcolors.vim'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Utilitiy
Plug 'airblade/vim-rooter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/fzf'
Plug 'kassio/neoterm'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'vim-utils/vim-man'

call plug#end()
