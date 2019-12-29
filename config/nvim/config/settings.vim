" core {{

" required {{

filetype plugin indent on
syntax on

" }}

" disable bells {{

set noerrorbells
set novisualbell
set t_vb=

" }}

" encoding {{

set fileencoding=utf-8
set termencoding=utf-8

" }}

" file formats/file handling {{

set backupcopy=yes
set fileformat=unix
set fileformats=unix,dos,mac

" }}

" persistent undo {{

set undodir=/tmp/nvim
set undofile

" }}

" space style and size {{

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" }}

" text formatting {{

set cindent
set ignorecase
set smartcase
set smartindent

" }}

" user interface {{

set cmdheight=1
set completeopt=menu,menuone,noinsert,noselect
set foldlevelstart=10
set foldmethod=syntax
set hidden
set lazyredraw
set noshowmode
set nowrap
set number
set report=0
set showmatch
set relativenumber

if (has('termguicolors'))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme jellybeans
hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none

set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono\ 14

" }}

" force nvim to use system python interpreters {{

if system('uname') =~ 'Darwin'
  let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python_host_prog = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
endif

let g:python3_host_skip_check = 1

" }}

" force nvim to use bash for posix compatibility {{

if &shell =~# 'fish$'
  set shell=bash
endif

" }}

" autocmd {{

augroup core_cmds
  autocmd BufLeave term://* stopinsert
  autocmd BufWritePre * FixWhitespace
  autocmd FileType help wincmd L
augroup END

" }}

" }}

" plugin {{

" autocomplete {{

" }}

" language utilities {{

" vim-jsdoc {{

let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1

" }}

" }}

" linting {{

" }}

" movement/text manipulation {{

" easymotion {{

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" }}

" prose {{

" vim-lexical {{
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType tex call lexical#init()
  autocmd FileType text call lexical#init()
  autocmd FileType textile call lexical#init()
augroup END

let g:lexical#thesaurus = ['~/.config/nvim/mthesaur.txt']
let g:lexical#dictionary = ['/usr/share/dict/american-english']

" }}

" }}

" snippets {{
" }}

" syntaxes {{

" vim-polyglot {{

let g:polyglot_disabled = [
  \ 'dockerfile',
  \ 'typescript',
\ ]

" }}

" syntax configurations {{

" vim-javascript {{

let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" }}

" vim-json {{

let g:vim_json_syntax_conceal = 0

" }}

" vim-jsx {{

let g:jsx_ext_required = 0

" }}

" vim-markdown {{

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 2

" }}

" }}

" }}

" user interface {{

" Airline {{

let g:airline_powerline_fonts = 1
let g:airline_theme = 'jellybeans'
let g:airline#extensions#tabline#enabled = 1

" }}

" chromatica.nvim {{

let g:chromatica#enable_at_startup = 1
let g:chromatica#responsive_mode=1

" }}

" }}

" utilitiy {{

" tmux-navigator {{
let g:tmux_navigator_no_mappings = 1
" }}

" vim-editorconfig {{

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" }}

" undotree {{

let g:undotree_WindowLayout = 1
let g:undotree_SplitWidth = 50
let g:undotree_DiffpanelHeight = 20

" }}

" }}

" }}

