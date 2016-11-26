"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if (has("termguicolors"))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set ruler       " Always show current positions along the bottom
set cmdheight=1 " Command bar is 1 unit high
set number      " Show line numbers
set lazyredraw  " Do not redraw while running macros
set report=0    " Always report how many lines changed

syntax on
colorscheme onedark

