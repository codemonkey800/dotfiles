" plugins {{

call plug#begin('~/.config/nvim/plugins')

" autocomplete {{

Plug 'alvan/vim-closetag'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'

" }}

" deoplete {{

Plug 'Shougo/deoplete.nvim'

" sources {{

Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim', { 'for': 'vim' }
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'mhartington/nvim-typescript', { 'for': 'typescript' }
Plug 'steelsojka/deoplete-flow', { 'for': 'javascript' }
Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp'] }
Plug 'ujihisa/neco-look'
Plug 'wellle/tmux-complete.vim'
Plug 'zchee/deoplete-go', { 'for': 'go' }
Plug 'zchee/deoplete-jedi', { 'for': 'python' }

" }}

" plugins {{

Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neopairs.vim'

" }}

" }}

" language utilities {{

Plug 'flowtype/vim-flow'
Plug 'heavenshell/vim-jsdoc'

" }}

" linting {{

Plug 'benekastah/neomake'

" }}

" movement/text manipulation {{

Plug 'bronson/vim-trailing-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'junegunn/vim-easy-align'
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
Plug 'justinj/vim-react-snippets'

" }}

" syntaxes {{

Plug 'ekalinin/Dockerfile.vim'
Plug 'sheerun/vim-polyglot'

" }}

" user interface {{

Plug 'Shougo/denite.nvim'
Plug 'Tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'flazz/vim-colorschemes'
Plug 'justinmk/vim-dirvish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/visual-split.vim'

" }}

" utility {{

Plug 'ansiesc.vim'
Plug 'brooth/far.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'gitignore'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'moll/vim-node'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'

" }}

call plug#end()

" }}

" nvim settings {{

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

if (has('termguicolors'))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme jellybeans
hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none

" }}

" force nvim to use system python interpreters {{

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'
let g:python3_host_skip_check = 1

" }}

" force nvim to use bash for posix compatibility {{

if &shell =~# 'fish$'
  set shell=bash
endif

" }}

" autocmd {{

augroup mycmds
  autocmd!
  autocmd BufEnter .{babel,eslint}rc :setf json
  autocmd BufLeave term://* stopinsert
  autocmd FileType help :wincmd l
  autocmd FileType vim :set foldmarker={{,}} foldlevel=0 foldmethod=marker
augroup END

" }}

" }}

" keymaps {{

let g:mapleader = ','

" base maps {{

" modified insert mode {{

function! SmartInsert()
  if &buftype ==# 'terminal'
    startinsert
  elseif len(getline('.')) == 0
    return 'cc'
  else
    return 'i'
  endif
endfunction

nnoremap <silent> <expr> i SmartInsert()

" }}

" improves <C-l>
nnoremap <C-l> :nohlsearch<CR> :diffupdate<CR> :syntax sync fromstart<CR><C-l>

" escape insert mode
inoremap <silent> jk <esc>

" move vertically by visual line
noremap <silent>  j gj
noremap <silent>  k gk

" swap capital H and L for begin and end of lines
noremap <silent>  H ^
noremap <silent>  L $

" quit and force quit maps
nnoremap <silent> Q :q!<CR>
nnoremap <silent> q :q<CR>

" space open/closes folds
nnoremap <space> za

" adds a new line below or above without entering insert mode
noremap o o<esc>k
noremap O O<esc>j

" redo last thing
noremap <silent> U :redo<CR>

" save current file
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>li

" Go back from tag using Ctrl-[, which makes more sense than Ctrl-t
nnoremap <silent> gt <C-]>
nnoremap <silent> gT <C-t>
nnoremap <silent> <C-]> <nop>

" }}

" buffer maps {{

function! BufferCount()
  let l:len = 0
  for l:i in range(1, bufnr('$'))
    if buflisted(l:i)
      let l:len += 1
    endif
  endfor
  return l:len
endfunction

function! BufferDelete()
  if winnr('$') == 1 || BufferCount() == 1
    bdelete
  elseif !&modified
    bnext
    bdelete #
  endif
endfunction

nnoremap <silent> <leader>w :call BufferDelete()<CR>
nnoremap <silent> <leader>l :ls<CR>
nnoremap <silent> <leader>n :enew<CR>

" next/previous buffers
nnoremap <silent> <C-k> :bn<CR>
nnoremap <silent> <C-j> :bp<CR>

"}}

" fancy maps {{

" run file if it's executable {{

function! ExecuteCurrentFile()
  if executable(expand('%:p'))
    !./%
  endif
endfunction

nnoremap <silent> <leader>r :call ExecuteCurrentFile()<CR>

" }}

" sort things
noremap <silent> <leader>s :sort<CR>
noremap <silent> <leader>S :sort!<CR>

" open nvim config for editing
nnoremap <silent> <leader>ve :edit $MYVIMRC<CR>

" source nvim config
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>

" select all text
noremap <silent> <leader>a ggvG$

" open current directory with file manager
nnoremap <silent> <leader>f :Dirvish<CR>

" runs neomake on the current dir
nnoremap <silent> <leader>b :Neomake!<CR>

" Plug mappings {{

function! CleanVimPlugins()
  PlugClean!
  call delete(fnamemodify($MYVIMRC, ':p:h') . '/autoload/plug.vim.old')
endfunction

nnoremap <silent> <leader>pc :call CleanVimPlugins()<CR>
nnoremap <silent> <leader>pi :PlugInstall<CR>
nnoremap <silent> <leader>ps :PlugStatus<CR>
nnoremap <silent> <leader>pu :PlugUpdate \| PlugUpgrade \| UpdateRemotePlugins<CR>

" }}

" system clipboard
noremap <silent> <leader>c "+y
nnoremap <silent> <leader>v "+p

" opens up command edit
nnoremap <silent> <M-c> q:
vnoremap <silent> <M-c> q:

" since shell is defined to /bin/bash for posix
" compatibility, we use the $shell environment variable
" to launch a terminal with the user's shell
nnoremap <silent> ~ :edit term://fish<CR>i
tnoremap <silent> jk <C-\><C-n>
tnoremap <silent> <Esc> <C-\><C-n>

" }}

" }}

" plugin settings/keymaps {{

" autocomplete {{
" }}

" deoplete {{

" core {{

" settings {{

let g:deoplete#enable_at_startup = 1

let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_smart_case = 1

let g:deoplete#keyword_patterns = {}

" }}

" custom sets {{

call deoplete#custom#set('_', 'min_pattern_length', 0)
call deoplete#custom#set('_', 'sorters', ['sorter_word'])
call deoplete#custom#set('_', 'matchers', [
  \ 'matcher_length',
  \ 'matcher_full_fuzzy',
\ ])
call deoplete#custom#set('_', 'converters', [
  \ 'converter_auto_delimiter',
  \ 'converter_auto_paren',
  \ 'converter_remove_overlap',
  \ 'converter_truncate_abbr',
  \ 'converter_truncate_menu',
\ ])

" }}

" keymaps {{

inoremap <silent> <expr> <C-g> deoplete#undo_completion()
inoremap <silent> <expr> <C-l> deoplete#refresh()

inoremap <silent> <expr> <C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <silent> <expr> <BS> deoplete#smart_close_popup()."\<C-h>"

function! s:DeopleteCR() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

inoremap <silent> <CR> <C-r>=<SID>DeopleteCR()<CR>

" }}

" }}

" plugins {{

" echodoc {{

let g:echodoc_enable_at_startup = 1

" }}

" neopairs {{

let g:neopairs#enable = 1

" }}

" }}

" sources {{

" nvim-typescript {{

let g:nvim_typescript#signature_complete = 0
let g:nvim_typescript#type_info_on_hold = 1

" }}

" tmux-complete {{

let g:tmuxcomplete#trigger = ''

" }}

" }}

" }}

" language utilities {{

" vim-flow {{

let g:flow#enable = 0
let g:flow#omnifunc = 0

" }}

" vim-jsdoc {{

let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1

" }}

" }}

" linting {{

" Neomake {{

let g:neomake_javascript_enabled_makers = ['eslint', 'flow']
let g:neomake_jsx_enabled_makers = ['eslint', 'flow']
let g:neomake_highlight_lines = 1

autocmd! BufWritePost * Neomake

" }}

" }}

" movement/text manipulation {{

" easyalign {{

" start interactive easyalign in visual mode
xmap <silent> ga <Plug>(EasyAlign)
" start interactive easyalign in normal mode
nmap <silent> ga <Plug>(EasyAlign)

" }}

" easymotion {{

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

map s <Plug>(easymotion-bd-f2)
nmap s <Plug>(easymotion-overwin-f2)

map <leader><leader>L <Plug>(easymotion-bd-jk)
nmap <leader><leader>L <Plug>(easymotion-overwin-line)

map <leader><leader>w <Plug>(easymotion-bd-w)
nmap <leader><leader>w <Plug>(easymotion-overwin-w)

" }}

" incsearch {{

function! s:FuzzyAll(...) abort
  return extend(copy({
  \   'converters': [
  \   incsearch#config#fuzzy#converter(),
  \   incsearch#config#fuzzyspell#converter(),
  \   ],
  \ }), get(a:, 1, {}))
endfunction

map <silent> / <Plug>(incsearch-fuzzy-/)
map <silent> ? <Plug>(incsearch-fuzzy-?)
map <silent> g/ <Plug>(incsearch-fuzzy-stay)

noremap <silent> <expr> z/ incsearch#go(<SID>FuzzyAll())
noremap <silent> <expr> z? incsearch#go(<SID>FuzzyAll({ 'command': '?' ))
noremap <silent> <expr> zg/ incsearch#go(<SID>FuzzyAll({ 'is_stay': 1 }))

" }}

" }}

" prose {{

" vim-lexical {{
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

let g:lexical#thesaurus = ['~/.config/nvim/mthesaur.txt']
let g:lexical#dictionary = ['/usr/share/dict/american-english']

let g:lexical#spell_key = '<leader>t'
let g:lexical#thesaurus_key = '<leader>T'
let g:lexical#dictionary_key = '<leader>k'

" }}

" }}

" snippets {{
" }}

" syntaxes {{

" vim-polyglot {{

let g:polyglot_disabled = ['dockerfile']

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

" dirvish {{

autocmd FileType dirvish call fugitive#detect(@%)

" }}

" gitgutter {{

" next/prev diff chunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nmap <silent> [h <Plug>GitGutterPrevHunk

" }}

" Tagbar {{

nnoremap <silent> <leader>t :Tagbar<CR>

" }}

" }}

" utilitiy {{

" fzf.vim {{
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'}
let g:fzf_layout = { 'down': '~30%' }

function! GetFiles()
  let l:opts = {}
  let l:opts.down = '30%'
  let l:opts.source = 'pt -g "" --hidden --global-gitignore --ignore .git'

  call system('git status')

  if v:shell_error == 0
    let l:name = 'gitfiles'
    let l:opts.options = '--prompt "Git Files>"'
  else
    let l:name = 'files'
    let l:opts.options = '--prompt "Files>"'
  endif

  return fzf#run(fzf#wrap(l:name, l:opts, 0))
endfunction

nnoremap <silent> <C-p> :call GetFiles()<CR>

" }}

" tmux-navigator {{
let g:tmux_navigator_no_mappings = 1

" navigate to next window in vim or tmux
nnoremap <silent> <A-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <A-j> :TmuxNavigateDown<CR>
nnoremap <silent> <A-k> :TmuxNavigateUp<CR>
nnoremap <silent> <A-l> :TmuxNavigateRight<CR>

" same as above but escape if in insert mode
inoremap <silent> <A-h> <Esc> :TmuxNavigateLeft<CR>
inoremap <silent> <A-j> <Esc> :TmuxNavigateDown<CR>
inoremap <silent> <A-k> <Esc> :TmuxNavigateUp<CR>
inoremap <silent> <A-l> <Esc> :TmuxNavigateRight<CR>

" same for terminal mode
tnoremap <silent> <A-h> <C-\><C-n> :TmuxNavigateLeft<CR>
tnoremap <silent> <A-j> <C-\><C-n> :TmuxNavigateDown<CR>
tnoremap <silent> <A-k> <C-\><C-n> :TmuxNavigateUp<CR>
tnoremap <silent> <A-l> <C-\><C-n> :TmuxNavigateRight<CR>

" }}

" vim-editorconfig {{

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" }}

" undotree {{

let g:undotree_WindowLayout = 1
let g:undotree_SplitWidth = 50
let g:undotree_DiffpanelHeight = 20

" show/hide undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" }}

" }}

" }}

