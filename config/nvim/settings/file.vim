"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set fileencoding=utf-8       " Default for new files
set termencoding=utf-8       " Terminal encoding
set fileformats=unix,dos,mac " Supports all three in this order
set fileformat=unix          " Default file format

set tabstop=4                " 4 spaces
set softtabstop=4            " 4 spaces
set shiftwidth=4             " 4 spaces
set expandtab                " Fuck tabs ;)

set undodir=/tmp/nvim
set undofile

autocmd BufEnter .{babel,eslint}rc :setf json
autocmd BufLeave term://* stopinsert
autocmd FileType help :wincmd l

