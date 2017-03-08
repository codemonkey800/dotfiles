nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <M-r> :call LanguageClient_textDocument_rename()<CR>

" autocmd! FileType * LanguageClientStart

