if exists('g:loaded_ftplugin_typescript')
  finish
endif
let g:loaded_ftplugin_typescript = 1

let g:nvim_typescript#type_info_on_hold = 1
let g:nvim_typescript#signature_complete = 1

nnoremap gd :TSDef<CR>

