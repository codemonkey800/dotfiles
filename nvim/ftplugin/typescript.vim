if exists('g:loaded_ftplugin_typescript')
  finish
endif
let g:loaded_ftplugin_typescript = 1

let g:nvim_typescript#type_info_on_hold = 1
let g:nvim_typescript#signature_complete = 1

nnoremap <silent> <leader>td :TSDef<CR>
nnoremap <silent> <leader>tr :TSRefs<CR>
nnoremap <silent> <leader>ttt :TSType<CR>
nnoremap <silent> <leader>ttd :TSTypeDef<CR>
nnoremap <silent> <leader>te :TSGetDiagnostics<CR>

" Prettify on save
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx PrettierAsync

" Update GitGutter on save
autocmd BufWritePre * GitGutter
