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
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'felixhummel/setcolors.vim'
Plug 'Firef0x/PKGBUILD.vim'
Plug 'flazz/vim-colorschemes'
Plug 'gitignore'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf'
Plug 'justinmk/vim-dirvish'
Plug 'kassio/neoterm', { 'commit': '9e33da0a'}
Plug 'majutsushi/tagbar'
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
Plug 'uarun/vim-protobuf'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-utils/vim-man'

call plug#end()
