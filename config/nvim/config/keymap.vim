" core {{

let g:mapleader = ','

" base maps {{

" modified insert mode {{

function! SmartInsert(key)
  if &buftype ==# 'terminal'
    startinsert
  elseif len(getline('.')) == 0
    return 'cc'
  else
    return a:key
  endif
endfunction

nnoremap <silent> <expr> i SmartInsert('i')
nnoremap <silent> <expr> a SmartInsert('a')

" }}

" improves <C-l>
nnoremap <silent> <C-l> :nohlsearch<CR> :diffupdate<CR> :syntax sync fromstart<CR><C-l>

" escape insert mode
inoremap <silent> <C-c> <esc>
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
nnoremap <silent> <C-t> <nop>

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

function! BufferDelete(...)
  let l:force = a:0 > 0 && a:1
  if winnr('$') == 1 || BufferCount() == 1
    if l:force
        bdelete!
    else
        bdelete
    endif
  elseif !&modified
    bnext
    if l:force
        bdelete! #
    else
        bdelete #
    endif
  endif
endfunction

nnoremap <silent> <leader>w :call BufferDelete()<CR>
nnoremap <silent> <leader>W :call BufferDelete(1)<CR>
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
noremap <silent> <leader>sd :sort<CR>
noremap <silent> <leader>sa :sort!<CR>

" open nvim config for editing
nnoremap <silent> <leader>ve :edit $MYVIMRC<CR>

" source nvim config
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>

" select all text
noremap <silent> <leader>a ggvG$

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
noremap <silent> <leader>y "+y
nnoremap <silent> <leader>p "+p

" opens up command edit
nnoremap <silent> <M-c> q:
vnoremap <silent> <M-c> q:

" since shell is defined to /bin/bash for posix
" compatibility, we use the $shell environment variable
" to launch a terminal with the user's shell
nnoremap <silent> ~ :edit term://fish<CR>i
tnoremap <silent> jk <C-\><C-n>
tnoremap <silent> <Esc> <C-\><C-n>

" Search for visually selected text
vnoremap <silent> * y/<C-R>"<CR>

" }}

" spell maps {{

function! ToggleSpell()
    if &spell
        set nospell
    else
        set spell
    end
endfunction

nnoremap <silent> <M-s> :call ToggleSpell()<CR>

" }}

" }}

" plugin {{

" movement/text manipulation {{

" easyalign {{

" start interactive easyalign in visual mode
xmap <silent> ga <Plug>(EasyAlign)
" start interactive easyalign in normal mode
nmap <silent> ga <Plug>(EasyAlign)

" }}

" easymotion {{

map <silent> sw <Plug>(easymotion-bd-f2)
nmap <silent> sw <Plug>(easymotion-overwin-f2)

map <silent> ss <Plug>(easymotion-bd-w)
nmap <silent> ss <Plug>(easymotion-overwin-w)

map <silent> sc <Plug>(easymotion-bd-jk)
nmap <silent> sc <Plug>(easymotion-overwin-line)

" }}

" incsearch {{

function! s:FuzzyAll(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter(),
  \   ],
  \ }), get(a:, 1, {}))
endfunction

" map <silent> / <Plug>(incsearch-fuzzy-/)
" map <silent> ? <Plug>(incsearch-fuzzy-?)
" map <silent> g/ <Plug>(incsearch-fuzzy-stay)

noremap <silent> <expr> z/ incsearch#go(<SID>FuzzyAll())
noremap <silent> <expr> z? incsearch#go(<SID>FuzzyAll({ 'command': '?' ))
noremap <silent> <expr> zg/ incsearch#go(<SID>FuzzyAll({ 'is_stay': 1 }))

" }}

" }}

" user interface {{

" gitgutter {{

" next/prev diff chunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nmap <silent> [h <Plug>GitGutterPrevHunk

" }}

" }}

" utilitiy {{

" fzf.vim {{

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
\ }

let g:fzf_layout = { 'down': '~30%' }

function! GetFiles()
  let l:opts = {
    \ 'down': '30%',
    \ 'source': 'rg --files --hidden --follow',
    \ 'options': '--multi --prompt "Files>"',
  \ }
  return fzf#run(fzf#wrap('files', l:opts, 0))
endfunction

nnoremap <silent> <C-p> :call GetFiles()<CR>

" }}

" tmux-navigator {{

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

" undotree {{

" show/hide undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" }}

" }}

" }}
