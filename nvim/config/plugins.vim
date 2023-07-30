call plug#begin('~/.config/nvim/plugins')

" autocomplete {{

" other autocomplete-ish plugins{{

Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'

" }}

" }}

" language utilities {{

Plug 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'typescript'] }
Plug 'jparise/vim-graphql', { 'for': ['javascript', 'typescript'] }
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn',
  \ 'for': ['javascript', 'typescript'],
\ }

" }}

" linting {{

Plug 'dense-analysis/ale'

" }}

" movement/text manipulation {{

Plug 'bronson/vim-trailing-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'junegunn/vim-easy-align'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

" }}

" prose {{

Plug 'reedes/vim-lexical'
Plug 'reedes/vim-wordy'

" }}

" snippets {{

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'justinj/vim-react-snippets', { 'for': ['jsx', 'typescript'] }

" }}

" syntaxes {{

Plug 'sheerun/vim-polyglot'
Plug 'tasn/vim-tsx'

" }}

" user interface {{

Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/visual-split.vim'

" }}

" utility {{

Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'gisphm/vim-gitignore'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/ansiesc.vim'

" }}

" special plugins {{

" vim-devicons must be loaded after the other plugins
Plug 'ryanoasis/vim-devicons'

" }}


call plug#end()

