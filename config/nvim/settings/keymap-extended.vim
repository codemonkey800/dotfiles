"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymap Extended Settings
"
" This file extends the base keymap settings and adds vim/nvim specific
" keybindings or keybindings for plugins.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source ~/.config/nvim/settings/keymap.vim

" Open nvim config for editing
nnoremap <silent> <leader>ev :edit $MYVIMRC<CR>

" Source nvim config
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Opens up command edit
nnoremap <silent> <M-c> q:

" Ctrl-p like functionality with FZF
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

" Open current directory with file manager
nnoremap <silent> <leader>f :edit .<CR>

" Runs make
nnoremap <silent> <leader>b :!make<CR>
" Runs make clean
nnoremap <silent> <leader>B :!make clean<CR>

" Since shell is defined to /bin/bash for POSIX
" compatibility, we use the $SHELL environment variable
" to launch a terminal with the user's shell
nnoremap <silent> ~ :edit term://fish<CR>i
tnoremap <silent> jk <C-\><C-n>
tnoremap <silent> <Esc> <C-\><C-n>

" Shortcuts for buffer related stuff
nnoremap <silent> <C-j> :bp<CR>
nnoremap <silent> <C-k> :bn<CR>
nnoremap <silent> <leader>w :bp \| bd #<CR>
nnoremap <silent> <leader>W :bp \| bd! #<CR>
nnoremap <silent> <leader>l :ls<CR>
nnoremap <silent> <leader>t :new<CR>

" fakeclip keymaps
vnoremap <silent> <leader>c "+y<CR>
nnoremap <silent> <leader>v "*p<CR>

" Start interactive EasyAlign in visual mode
xmap <silent> ga <Plug>(EasyAlign)
" Start interactive EasyAlign in normal mode
nmap <silent> ga <Plug>(EasyAlign)

" Next/Prev diff chunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nmap <silent> [h <Plug>GitGutterPrevHunk

nnoremap <silent> <leader>u :UndotreeToggle<CR>

nnoremap <silent> <A-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <A-j> :TmuxNavigateDown<CR>
nnoremap <silent> <A-k> :TmuxNavigateUp<CR>
nnoremap <silent> <A-l> :TmuxNavigateRight<CR>

inoremap <silent> <A-h> <Esc> :TmuxNavigateLeft<CR>
inoremap <silent> <A-j> <Esc> :TmuxNavigateDown<CR>
inoremap <silent> <A-k> <Esc> :TmuxNavigateUp<CR>
inoremap <silent> <A-l> <Esc> :TmuxNavigateRight<CR>

tnoremap <silent> <A-h> <C-\><C-n> :TmuxNavigateLeft<CR>
tnoremap <silent> <A-j> <C-\><C-n> :TmuxNavigateDown<CR>
tnoremap <silent> <A-k> <C-\><C-n> :TmuxNavigateUp<CR>
tnoremap <silent> <A-l> <C-\><C-n> :TmuxNavigateRight<CR>

