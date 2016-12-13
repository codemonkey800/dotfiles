"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if (has("termguicolors"))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set cmdheight=1 " Command bar is 1 unit high
set number      " Show line numbers
set lazyredraw  " Do not redraw while running macros
set report=0    " Always report how many lines changed
set noshowmode  "Don't show INSERT, NORMAL, or VISUAL"

syntax on
colorscheme jellybeans

hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none

