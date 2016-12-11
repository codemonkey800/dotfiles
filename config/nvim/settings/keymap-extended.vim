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

" Ctrl-p like functionality with FZF
function! GetFiles()
    let l:opts = {}
    let l:opts.source = 'pt -g ""'
    let l:opts.down = '30%'

    call system('git status')

    if v:shell_error == 0
        let l:opts.options = '--prompt "Git Files>"'
    else
        let l:opts.options = '--prompt "Files>"'
    endif

    return fzf#run(fzf#wrap('files', l:opts, 0))
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
nnoremap ~ :edit term://fish<CR>i
tnoremap <C-q> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>

" Shortcuts for buffer related stuff
nnoremap <silent> <C-j> :bp<CR>
nnoremap <silent> <C-k> :bn<CR>
nnoremap <silent> <leader>w :bp \| bd #<CR>
nnoremap <silent> <leader>W :bp \| bd! #<CR>
nnoremap <silent> <leader>l :ls<CR>
nnoremap <silent> <leader>t :new<CR>

" fakeclip keymaps
vnoremap <leader>c "+y<CR>
nnoremap <leader>v "*p<CR>

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign in normal mode
nmap ga <Plug>(EasyAlign)

" Next/Prev diff chunk
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

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

