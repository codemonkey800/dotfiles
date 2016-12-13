"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set fileencoding=utf-8       " Default for new files
set termencoding=utf-8       " Terminal encoding
set fileformats=unix,dos,mac " Supports all three in this order
set fileformat=unix          " Default file format

" Use spaces over tabs and use 4 spaces per indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Persistent undos for a session
set undodir=/tmp/nvim
set undofile

autocmd BufEnter .{babel,eslint}rc :setf json
autocmd BufLeave term://* stopinsert
autocmd FileType help :wincmd l

