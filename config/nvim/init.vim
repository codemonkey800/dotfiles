" plugins {{

call plug#begin('~/.config/nvim/plugins')

" autocomplete {{

Plug 'amirh/html-autoclosetag'
Plug 'ervandew/supertab'
Plug 'othree/jspc.vim', { 'for': 'javascript' }
Plug 'raimondi/delimitmate'

" }}

" deoplete {{

Plug 'Shougo/deoplete.nvim'

Plug 'SevereOverfl0w/deoplete-github', { 'for': 'gitcommit' }
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim', { 'for': 'vim' }
Plug 'Shougo/neopairs.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neopairs.vim'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'mhartington/deoplete-typescript', { 'for': 'typescript' }
Plug 'steelsojka/deoplete-flow', { 'for': 'javascript' }
Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp'] }
Plug 'ujihisa/neco-look'
Plug 'wellle/tmux-complete.vim'
Plug 'zchee/deoplete-go', { 'for': 'go' }
Plug 'zchee/deoplete-jedi', { 'for': 'python' }

" }}

" linting {{

Plug 'benekastah/neomake'

" }}

" movement/text manipulation {{

Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'

" }}

" prose {{

Plug 'reedes/vim-lexical'
Plug 'reedes/vim-wordy'

" }}

" snippets {{

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" }}

" syntaxes {{

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

" }}

" user interface {{

Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'flazz/vim-colorschemes'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" }}

" utilitiy {{

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
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'janko-m/vim-test'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'kassio/neoterm'
Plug 'mbbill/undotree'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
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

" file formats {{{

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
set completeopt=menu,menuone,noinsert
set foldmethod=syntax
set lazyredraw
set noshowmode
set nowrap
set number
set report=0
set showmatch

if (has("termguicolors"))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme jellybeans
hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none

" }}

" force nvim to use system python interpreters {

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'
let g:python3_host_skip_check = 1

" }

" force nvim to use bash for posix compatibility {

if &shell =~# 'fish$'
    set shell=bash
endif

" }

" autocmd {

autocmd BufEnter .{babel,eslint}rc :setf json
autocmd BufLeave term://* stopinsert
autocmd FileType help :wincmd l
autocmd FileType vim :set foldmarker={{,}} foldlevel=0 foldmethod=marker

" }

" }}

" keymaps {{

" base maps {{

" modified insert mode {{

function! SmartInsert()
    if len(getline('.')) == 0
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
noremap $ <nop>
noremap ^ <nop>

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

" <leader> maps {{

let mapleader = ","

" Pipe to selected to shell
vnoremap <silent> <leader>r :!%:p<CR>

" sort things
noremap <silent> <leader>s :sort<CR>
noremap <silent> <leader>S :sort!<CR>

" open nvim config for editing
nnoremap <silent> <leader>ev :edit $MYVIMRC<CR>

" source nvim config
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
" select all text
noremap <silent> <leader>a ggvG

" open current directory with file manager
nnoremap <silent> <leader>f :edit .<CR>

" runs make
nnoremap <silent> <leader>b :!make<CR>
" runs make clean
nnoremap <silent> <leader>B :!make clean<CR>

" buffer maps
nnoremap <silent> <leader>w :bp \| bd #<CR>
nnoremap <silent> <leader>W :bp \| bd! #<CR>
nnoremap <silent> <leader>l :ls<CR>
nnoremap <silent> <leader>t :new<CR>

" }}

" fancy maps {{

" opens up command edit
nnoremap <silent> <M-c> q:
vnoremap <silent> <M-c> q:


" since shell is defined to /bin/bash for posix
" compatibility, we use the $shell environment variable
" to launch a terminal with the user's shell
nnoremap <silent> ~ :edit term://fish<CR>i
tnoremap <silent> jk <C-\><C-n>
tnoremap <silent> <Esc> <C-\><C-n>

" shortcuts for buffer related stuff
nnoremap <silent> <C-j> :bp<CR>
nnoremap <silent> <C-k> :bn<CR>

" }}

" }}

" plugin settings/keymaps {{

" autocomplete {{
" }}

" deoplete {{

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1

let g:deoplete#keyword_patterns = {}
let g:deoplete#sources = {}
let g:deoplete#sources_ = ['buffer', 'tag']

" tmux-complete
let g:tmuxcomplete#trigger = ''

" deoplete-github {{
let g:deoplete#sources.gitcommit = ['github']
let g:deoplete#keyword_patterns.gitcommit = '.+'
let g:deoplete#omni#input_patterns = {}
call deoplete#util#set_pattern(
    \ g:deoplete#omni#input_patterns,
    \ 'gitcommit',
    \ [g:deoplete#keyword_patterns.gitcommit])
" }}

" }}

" deoplete  {{

" deoplete-flow
function! TrimNewline(str)
    return substitute(a:str, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

let s:flow_path = ''
if executable('flow')
    let s:flow_path = TrimNewline(system('which flow'))
else
    let s:cmd = ''
    if executable('yarn')
        let s:cmd = 'yarn'
    elseif executable('npm')
        let s:cmd = 'npm'
    endif

    if s:cmd != ''
        let s:flow_path = resolve(
                    \ TrimNewline(system(s:cmd . ' bin'))
                    \ . '/flow')
        if !executable(s:flow_path)
            let s:flow_path = ''
        endif
    endif
end

let g:deoplete#sources#flow#flow_bin = s:flow_path

" }}

" linting {{

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint', 'flow']
let g:neomake_highlight_lines = 1

autocmd! BufWritePost * Neomake

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

map <leader><leader> <Plug>(easymotion-bd-w)
nmap <leader><leader> <Plug>(easymotion-overwin-w)

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

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 2

" vim-jsx
let g:jsx_ext_required = 0

" }}

" user interface {{

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'jellybeans'
let g:airline#extensions#tabline#enabled = 1

" onedark.vim
let g:onedark_terminal_italics = 1

" }}

" utilitiy {{

" echodoc
set noshowmode
let g:echodoc_enable_at_startup = 1

" fakeclip {{
let g:vim_fakeclip_tmux_plus = 1

" fakeclip keymaps
vnoremap <silent> <leader>c "+y<CR>
nnoremap <silent> <leader>v "*p<CR>

" }}

" fzf.vim {{
let g:fzf_action = {
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'}
let g:fzf_layout = { 'down': '~30%' }

function! GetFiles()
    let l:opts = {}
    let l:opts.down = '30%'
    let l:opts.source = 'pt -g "" --hidden --ignore .git'

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

" gitgutter {{

" next/prev diff chunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nmap <silent> [h <Plug>GitGutterPrevHunk

" }}

" incsearch {{
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter(),
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent> <expr> / incsearch#go(<SID>config_fuzzyall())
noremap <silent> <expr> ? incsearch#go(<SID>config_fuzzyall({ 'command': '?' ))
noremap <silent> <expr> g/ incsearch#go(<SID>config_fuzzyall({ 'is_stay': 1 }))

" }}

" Neoterm
let g:neoterm_shell = "fish"

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

" vim-editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" undotree {{
let g:undotree_WindowLayout = 1
let g:undotree_SplitWidth = 50
let g:undotree_DiffpanelHeight = 20

" show/hide undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" }}

" }}

" }}

